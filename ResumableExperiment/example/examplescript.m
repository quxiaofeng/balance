% Usage:
%   Add path for 'SaveResultsToAnExcel', 'ResumableExperiment'
%   Run this script.

CleanResult = true;
RunExample = false;

if CleanResult
    % Clean result folders
    resultDir = dir('Test-*');
    for i=1:length(resultDir)
        rmdir(resultDir(i).name,'s');
    end;
    delete('Test_results.mat');
end

expFunctionHandle   = @exampleexperiment;
varNameList         = {'DELTA'     'SIGMA'     'FILTERSIZE'    'BLOCK'};
varRangeList        = {[0.1 0.2]   [1 2]       [10 20]         [100 200]};
expEnv.RESULTFOLDER = cd;       % expEnv.RESULTFOLDER is a must
expEnv.CODENAME     = 'Test';   % expEnv.CODENAME is a must

if RunExample
    resumable( ...
        expFunctionHandle, ...
        varNameList, ...
        varRangeList, ...
        expEnv);
end
