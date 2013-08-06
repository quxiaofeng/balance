% Usage:
%   Add path for 'SaveResultsToAnExcel', 'ResumableExperiment'
%   Run this script.

clean = true;
run = false;

if clean
    % clean result folders
    resultDir = dir('Test-*');
    for i=1:length(resultDir)
        rmdir(resultDir(i).name,'s');
    end;
end

if run
    varNameList  = {'DELTA'     'SIGMA'     'FILTERSIZE'    'BLOCK'};
    varRangeList = {[0.1 0.2]   [1 2]       [10 20]         [100 200]};
    ResumableExcelSavingExperiment( ...
        @ResumableTestExperiment, ... % expFunctionHandle
        'Test', ...                   % experimentCodeName
        varNameList, ...
        varRangeList, ...
        cd);                          % DATAFOLDER
end
