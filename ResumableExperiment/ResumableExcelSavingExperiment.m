function [ ] = ResumableExcelSavingExperiment( ...
    expFunctionHandle, ...
    experimentCodeName, ...
    varNameList, ...
    varRangeList, ...
    DATAFOLDER)
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
%     cd);                          % DATAFOLDER
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

% main loop
while(~strcmp(flag,'finished'))
    
    % print out log
    fprintf('%3.2f%% finished \n', percentage*100);
    
    % make a result folder
    RESULTFOLDER = fullfile(DATAFOLDER, ...
        [experimentCodeName,'-',datestr(now,'yyyymmdd-HHMMSS')]);
    if exist(RESULTFOLDER,'dir') ~= 7
        mkdir(RESULTFOLDER);
    end
    
    % experiment code
    currentResult = expFunctionHandle(combination, varNameList);
    
    % save results to an excel file
    firstValue = [];
    eval(sprintf('firstValue = combination.%s;',cell2mat(varNameList(1))));
    secondValue = [];
    eval(sprintf('secondValue = combination.%s;',cell2mat(varNameList(2))));
    results{excelIndex} ...
        = SaveAValueToResults(results{excelIndex},...
        firstValue,secondValue,currentResult);
    for i=1:length(results)
        xlswrite(fullfile(RESULTFOLDER,excelNameStrings(i,:)),results{i});
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

