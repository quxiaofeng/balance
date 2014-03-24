function [ ] = resumable( ...
    expFunctionHandle, ...
    varNameList, ...
    varRangeList, ...
    expEnv)
%resumable Summary of this function goes here
%   Detailed explanation goes here

% Usage:
%
% varNameList  = {'DELTA'     'SIGMA'     'FILTERSIZE'    'BLOCK'};
% varRangeList = {[0.1 0.2]   [1 2]       [10 20]         [100 200]};
% resumable( ...
%     @objectfunction, ... % expFunctionHandle
%     'Test', ...                   % experimentCodeName
%     varNameList, ...
%     varRangeList, ...
%     expEnv);                      % expEnv
%


% init path for 'SaveResultsToAnExcel', 'ResumableExperiment'

% folder
% Experiment prefix
% prepare vars, ranges, and combinations
[combinationList, excelNameStrings, excelIndexList] = parsevarrange(...
    varNameList, varRangeList);
% init excels
results = cell(size(excelNameStrings,1),1);
for iExcelLine = 1:size(excelNameStrings,1)
    results{iExcelLine} = initresult( ...
        excelNameStrings(iExcelLine,:), cell2mat(varRangeList(1)), ...
        cell2mat(varRangeList(2)));
end

% init resumable
cacheFileName = [expEnv.CODENAME '_cache.mat'];
[combination, isFinished, percentage] = ...
    initresumable(combinationList, cacheFileName);

% init resumable for result index
cacheExcelFileName = [expEnv.CODENAME '_excel_cache.mat'];
[excelIndex, ~, ~] = ...
    initresumable(excelIndexList, cacheExcelFileName);

previousPercentage = 0;
tStart = tic;
isFirstRun = true;
% main loop
while(~isFinished)
    
    % time ticking
    tElapsed = toc(tStart);
    tStart = tic;
    
    % print out log if it is not the first exp or it is not a pick up exp
    if isFirstRun
        isPickup = percentage > 0;
        if isPickup
            fprintf('Start from %03.3f%% \n', percentage*100);
            load([expEnv.CODENAME '_results.mat'], 'results');
        else
            fprintf('Start \n');
        end
    else
        howLongTimeToGo = tElapsed ...
            * (1 - percentage)...
            / (percentage - previousPercentage);
        future = seconds2string(howLongTimeToGo);
        fprintf('    %03.3f%% finished. Still %s to go ... \n', ...
            percentage*100, future);
    end
    
    previousPercentage = percentage;
    isFirstRun = false;
    
    % make a result folder
    resultFolder = fullfile(expEnv.RESULTFOLDER, ...
        [expEnv.CODENAME,'-',datestr(now,'yyyymmdd-HHMMSS')]);
    if exist(resultFolder,'dir') ~= 7
        mkdir(resultFolder);
    end
    
    % experiment code
    currentResult = expFunctionHandle(combination, varNameList, expEnv);
    
    
    % save results to an excel file
    firstValue = [];
    eval(sprintf('firstValue = combination.%s;', ...
        cell2mat(varNameList(1)))); % extract fisrt value name
    secondValue = [];
    eval(sprintf('secondValue = combination.%s;', ...
        cell2mat(varNameList(2))));% extract second value name
    results{excelIndex} ...
        = updateresult(results{excelIndex},...
        firstValue,secondValue,currentResult);
    save([expEnv.CODENAME '_results.mat'], 'results');
    for i=1:length(results)
        xlswrite(fullfile(resultFolder,excelNameStrings(i,:)),results{i});
    end
    
    % update resumable experiment
    [combination, isFinished, percentage] = ...
        updateresumable(combinationList, cacheFileName);
    [excelIndex, ~, ~] = ...
        updateresumable(excelIndexList, cacheExcelFileName);
    
    % stop criteria
    if abs(percentage-1) < eps
        fprintf('All finished.\n');
    end
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ timeString ] = seconds2string( seconds )
%SECONDS2STRING Summary of this function goes here
%   Detailed explanation goes here

seconds = double(seconds);
if seconds <= 0
    timeString = '';
    return;
end

SECONDS_PER_MONTH  = 2592000;
SECONDS_PER_WEEK   = 604800;
SECONDS_PER_DAY    = 86400;
SECONDS_PER_HOUR   = 3600;
SECONDS_PER_MINUTE = 60;

timeString = '';
if seconds > SECONDS_PER_MONTH % How many monthes
    tMonthes = floor(seconds/SECONDS_PER_MONTH);
    seconds = mod(seconds, SECONDS_PER_MONTH);
    if isempty(timeString)
        timeString = sprintf('%.0f Months',tMonthes);
    else
        timeString = strjoin({timeString sprintf('%.0f Months',tMonthes)});
    end
end
if seconds > SECONDS_PER_WEEK % How many weeks
    tWeeks = floor(seconds/SECONDS_PER_WEEK);
    seconds = mod(seconds, SECONDS_PER_WEEK);
    if isempty(timeString)
        timeString = sprintf('%.0f Weeks',tWeeks);
    else
        timeString = strjoin({timeString sprintf('%.0f Weeks',tWeeks)});
    end
end
if seconds > SECONDS_PER_DAY % How many days
    tDays = floor(seconds/SECONDS_PER_DAY);
    seconds = mod(seconds, SECONDS_PER_DAY);
    if isempty(timeString)
        timeString = sprintf('%.0f Days',tDays);
    else
        timeString = strjoin({timeString sprintf('%.0f Days',tDays)});
    end
end
if seconds > SECONDS_PER_HOUR % How many hours
    tHours = floor(seconds/SECONDS_PER_HOUR);
    seconds = mod(seconds, SECONDS_PER_HOUR);
    if isempty(timeString)
        timeString = sprintf('%.0f Hours',tHours);
    else
        timeString = strjoin({timeString sprintf('%.0f Hours',tHours)});
    end
end
if seconds > SECONDS_PER_MINUTE % How many minutes
    tMinutes = floor(seconds/SECONDS_PER_MINUTE);
    seconds = mod(seconds, SECONDS_PER_MINUTE);
    if isempty(timeString)
        timeString = sprintf('%.0f Minutes',tMinutes);
    else
        timeString = strjoin({timeString sprintf('%.0f Minutes',tMinutes)});
    end
end
if seconds > eps % How many seconds
    if isempty(timeString)
        timeString = sprintf('%.2f Seconds',seconds);
    else
        timeString = strjoin({timeString sprintf('%.2f Seconds',seconds)});
    end
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [combinationArray, excelNameStrings, excelIndex, ...
    excelNameStringForEachCombination] = parsevarrange(...
    varNameList, varRangeList)
%parsevarrange Parse the range of each var and make a combinationArray
%   Detailed explanation goes here
%
%% Vars
%
% *Input*
%       varNameList - String cell of var names
%
%       Example:
%           varNameList = {'DELTA','SIGMA','FILTERSIZE','BLOCK'};
%
%       varRangeList - Double array cell of vars' range
%
%       Example:
%           varRangeList = {0.1:0.1:0.2, 1:1:2, [10 20], [100 200]};
%
%
% *Output*
%       combinationArray - the struct array of all vars
%
%       Example:
%           combinationArray(1).FILTERSIZE = 10;
%
%       excelNameStrings - the excel string for each result
%
%       Example:
%           >> disp(excelNameStrings)
%           Result FILTERSIZE 10 BLOCK 100.xls
%           Result FILTERSIZE 20 BLOCK 100.xls
%           Result FILTERSIZE 10 BLOCK 200.xls
%           Result FILTERSIZE 20 BLOCK 200.xls
%
%       excelIndex - the index of result of excel file name
%
%       Example:
%             excelIndex =
%                  1
%                  1
%                  1
%                  1
%                  2
%                  2
%                  2
%                  2
%                  3
%                  3
%                  3
%                  3
%                  4
%                  4
%                  4
%                  4
%

% Parse value matrix from var value ranges
for iCombination=1:length(varRangeList)
    thisRange = cell2mat(varRangeList(iCombination));
    thisRange = thisRange(:);
    if iCombination == 1
        valueMatrix = thisRange;
    else
        newColumnOfValue = repmat(thisRange',[size(valueMatrix,1), 1]);
        newColumnOfValue = newColumnOfValue(:);
        oldValueMatrix = repmat(valueMatrix, [length(thisRange), 1]);
        valueMatrix = [oldValueMatrix, newColumnOfValue];
    end
end

valueCells = num2cell(valueMatrix);

% Parse struct from matrix for return
combinationArray = cell2struct(valueCells', varNameList, 1);

% Parse Excel File Name String
leadingString = 'Result ';
if length(varRangeList) == 2
    excelNameStrings = leadingString;
elseif length(varRangeList) > 2
    % Parse values to string
    for iCombination=3:length(varRangeList)
        thisRange = cell2mat(varRangeList(iCombination));
        thisRange = thisRange(:);
        if iCombination == 3
            thisRange = num2str(thisRange);
            thisRangeWithName = [...
                repmat([cell2mat(varNameList(iCombination)) ' '], ...
                [size(thisRange,1) 1]) thisRange];
            excelNameStrings = [repmat([leadingString], ...
                [size(thisRangeWithName,1), 1]) thisRangeWithName];
        else
            newColumnOfValue = repmat(thisRange', ...
                [size(excelNameStrings,1), 1]);
            newColumnOfValue = num2str(newColumnOfValue(:));
            newColumnVarName = repmat(...
                [' ' cell2mat(varNameList(iCombination)) ' '], ...
                [size(newColumnOfValue, 1), 1]);
            oldValueMatrix = repmat(excelNameStrings, ...
                [length(thisRange), 1]);
            excelFileExt = repmat('.xls', ...
                [size(oldValueMatrix,1), 1]);
            excelNameStrings = [oldValueMatrix, ...
                newColumnVarName, newColumnOfValue, excelFileExt];
        end
    end
end

% Parse the excel index
first2Size = length(cell2mat(varRangeList(1))) ...
    * length(cell2mat(varRangeList(2)));
excelIndex = [];
excelNameStringForEachCombination = [];
for iCombination=1:size(excelNameStrings,1),
    excelIndex = [excelIndex; ones(first2Size,1) * iCombination];
    excelNameStringForEachCombination = ...
        [excelNameStringForEachCombination; ...
        repmat(excelNameStrings(iCombination,:), [first2Size, 1])];
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [combination, isFinished, percent] = ...
    initresumable(combinationList, cacheFileName)
%initresumable Summary of this function goes here
%   Detailed explanation goes here
%     + Start
%       + search for existing progress_cache.mat
%       + if found, load combinationList and progress, return a combination and 'continue'
%       + if not found, init the combinationList and progress
%     + Init
%       + create a progress_cache.mat
%       + create a combinationList
%       + init the progress
%       + save combinationList and progress
%       + return a combination and 'continue'

switch nargin
    case 2
    case 1
        cacheFileName = 'progress_cache.mat';
    otherwise
        error('Wrong number of parameters!');
end

% start
if exist(cacheFileName,'file') == 2
    % resume
    load(cacheFileName,'combinationList','progress');
    if progress >= length(combinationList)
        [combination, isFinished, percent] = updateresumable;
        return;
    end
else
    % init
    progress = 0;
    save(cacheFileName, 'combinationList', 'progress');
end
combination = combinationList(progress+1);
isFinished = false;
percent = progress / length(combinationList);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [combination, isFinished, percent] ...
    = updateresumable(combinationList, cacheFileName)
%updateresumable Update the resumable env
%   Detailed explanation goes here
%     + Update
%       + load existing progress_cache.mat
%       + if yes, update the progress
%       + if not, goto Start
%       + check if finished.
%       + if not finished, return another combination and 'continue'
%       + if finished, delete progress_cache.mat and return last combination and 'finished'

switch nargin
    case 2
    case 1
        cacheFileName = 'progress_cache.mat';
    otherwise
        error('Wrong number of parameters!');
end

% check
if exist(cacheFileName,'file') == 2
    % update
    load(cacheFileName,'combinationList','progress');
    progress = progress + 1;
    if progress >= length(combinationList)
        % finished
        delete(cacheFileName);
        combination = combinationList(end);
        isFinished = true;
        percent = 1.0;
    else
        % continue
        combination = combinationList(progress + 1);
        isFinished = false;
        percent = progress / length(combinationList);
        save(cacheFileName, 'combinationList', 'progress');
    end
else
    % init
    [combination, isFinished, percent] = ...
        updateresumable(combinationList);
end

end



