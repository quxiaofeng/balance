function [ combination, flag, percent] = ...
    ResumableExperimentStart(combinationList, cacheFileName)
%RESUMABLEEXPERIMENTSTART Summary of this function goes here
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
        [combination, flag, percent] = ResumableExperimentUpdate;
        return;
    end
else
    % init
    progress = 0;
    save(cacheFileName, 'combinationList', 'progress');
end
combination = combinationList(progress+1);
flag = 'continue';
percent = progress / length(combinationList);
end

