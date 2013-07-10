% Usage:
%   ResumableExcelResultSavingExample();
%   % clean result folders
%   resultDir = dir('exp-*');
%   for i=1:length(resultDir);rmdir(resultDir(i).name,'s');end;

% init path
addpath('SaveResultsToAnExcel');
addpath('ResumableExperiment');

% prepare ranges
DELTARANGE      = 0.1:0.1:0.2;
SIGMARANGE      = 1:1:2;
FILTERSIZERANGE = [10 20];
DATAFOLDER      = cd;

% init excels
results10 = InitResultsForExcel('Delta\Sigma FilterSize 10',...
    DELTARANGE,SIGMARANGE);
results20 = InitResultsForExcel('Delta\Sigma FilterSize 20',...
    DELTARANGE,SIGMARANGE);

% init combinations for resumable
i=1;
for FILTERSIZE = FILTERSIZERANGE;
    for    DELTA = DELTARANGE;
        for    SIGMA = SIGMARANGE;
            combinationList(i).filtersize = FILTERSIZE;
            combinationList(i).delta = DELTA;
            combinationList(i).sigma = SIGMA;
            i = i+1;
        end
    end
end

% init resumable
cacheFileName = 'test_cache.mat';
[combination, flag, percentage] = ...
    ResumableExperimentStart(combinationList, cacheFileName);

% main loop
while(~strcmp(flag,'finished'))
    % read all arguments
    FILTERSIZE = combination.filtersize;
    DELTA = combination.delta;
    SIGMA = combination.sigma;
    % print out log
    fprintf(['%3.2f%% finished... \n', ...
        '\tDelta %3.3f Sigma %3.3f FILTERSIZE %3.3f '],...
        percentage*100,DELTA,SIGMA,FILTERSIZE);
    % make a result folder
    RESULTFOLDER = fullfile(DATAFOLDER, ...
        ['exp-',datestr(now,'yyyymmdd-HHMMSS'), '_result']);
    if exist(RESULTFOLDER,'dir') ~= 7
        mkdir(RESULTFOLDER);
    end
    
    % experiment code
    eer = SIGMA + DELTA + FILTERSIZE;
    
    % print out result
    fprintf('EER, %3.3f%%\n',eer*100.0);
    
    % save results to excel
    if FILTERSIZE == 10
        results10 = SaveAValueToResults(results10,DELTA,SIGMA,eer);
    else
        results20 = SaveAValueToResults(results20,DELTA,SIGMA,eer);
    end
    xlswrite(fullfile(RESULTFOLDER,'results_filtersize_10.xls'),results10);
    xlswrite(fullfile(RESULTFOLDER,'results_filtersize_20.xls'),results20);
    
    % update resumable experiment
    [combination, flag, percentage] = ...
        ResumableExperimentUpdate(combinationList, cacheFileName);
    if abs(percentage-1) < eps
        fprintf('All finished.\n\n');
    end
end
