function [ ] = ResumableExcelSavingExperiment( ...
    expFunctionHandle, ...
    experimentCodeName, ...
    varNameList, ...
    varRangeList, ...
    rootFolder)
%RESUMABLEEXCELSAVINGEXPERIMENT Summary of this function goes here
%   Detailed explanation goes here

% Usage:
%
% varNameList  = {'DELTA'     'SIGMA'     'FILTERSIZE'    'BLOCK'};
% varRangeList = {[0.1 0.2]   [1 2]       [10 20]         [100 200]};
% ResumableExcelSavingExperiment( ...
%     @ResumableTestExperiment, ... % expFunctionHandle
%     'Test', ...                   % experimentCodeName
%     varNameList, ...
%     varRangeList, ...
%     cd);                          % rootFolder
%


% init path for 'SaveResultsToAnExcel', 'ResumableExperiment'

% folder
% Experiment prefix
% prepare vars, ranges, and combinations
[combinationList, excelNameStrings, excelIndexList] = ParseVarAndRange(...
    varNameList, varRangeList);
% init excels
results = cell(size(excelNameStrings,1),1);
for iExcelLine = 1:size(excelNameStrings,1)
    results{iExcelLine} = InitResultsForExcel( ...
        excelNameStrings(iExcelLine,:), cell2mat(varRangeList(1)), ...
        cell2mat(varRangeList(2)));
end

% init resumable
cacheFileName = [experimentCodeName '_cache.mat'];
[combination, flag, percentage] = ...
    ResumableExperimentStart(combinationList, cacheFileName);

% init resumable for result index
cacheExcelFileName = [experimentCodeName '_excel_cache.mat'];
[excelIndex, ~, ~] = ...
    ResumableExperimentStart(excelIndexList, cacheExcelFileName);

previousPercentage = 0;
tStart = tic;
% main loop
while(~strcmp(flag,'finished'))
    
    % time ticking
    tElapsed = toc(tStart);
    tStart = tic;
    
    % print out log
    if previousPercentage > eps && percentage > previousPercentage
        howLongTimeToGo = tElapsed ...
            * (1 - percentage)...
            / (percentage - previousPercentage);
        future = Seconds2String(howLongTimeToGo);
        fprintf('%3.2f%% finished. Still %s to go. \n', ...
            percentage*100, future);
    else
        fprintf('%3.2f%% finished \n', percentage*100);
    end
    previousPercentage = percentage;
    
    % make a result folder
    resultFolder = fullfile(rootFolder, ...
        [experimentCodeName,'-',datestr(now,'yyyymmdd-HHMMSS')]);
    if exist(resultFolder,'dir') ~= 7
        mkdir(resultFolder);
    end
    
    % experiment code
    currentResult = expFunctionHandle(combination, varNameList, resultFolder);
    
    % save results to an excel file
    firstValue = [];
    eval(sprintf('firstValue = combination.%s;', ...
        cell2mat(varNameList(1))));
    secondValue = [];
    eval(sprintf('secondValue = combination.%s;', ...
        cell2mat(varNameList(2))));
    results{excelIndex} ...
        = SaveAValueToResults(results{excelIndex},...
        firstValue,secondValue,currentResult);
    for i=1:length(results)
        xlswrite(fullfile(resultFolder,excelNameStrings(i,:)),results{i});
    end
    
    % update resumable experiment
    [combination, flag, percentage] = ...
        ResumableExperimentUpdate(combinationList, cacheFileName);
    [excelIndex, ~, ~] = ...
        ResumableExperimentUpdate(excelIndexList, cacheExcelFileName);
    
    % stop criteria
    if abs(percentage-1) < eps
        fprintf('All finished.\n');
    end
end

end

