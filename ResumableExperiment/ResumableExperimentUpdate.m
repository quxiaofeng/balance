function [combination, flag, percent] ...
    = ResumableExperimentUpdate(combinationList, cacheFileName)
%RESUMABLEEXPERIMENTUPDATE Summary of this function goes here
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
        flag = 'finished';
        percent = 1.0;
    else
        % continue
        combination = combinationList(progress + 1);
        flag = 'continue';
        percent = progress / length(combinationList);
        save(cacheFileName, 'combinationList', 'progress');
    end
else
    % init
    [combination, flag, percent] = ...
        ResumableExperimentStart(combinationList);
end

end

