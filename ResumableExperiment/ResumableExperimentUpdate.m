function [ combination, flag, percent ] ...
    = ResumableExperimentUpdate( combinationList )
%RESUMABLEEXPERIMENTUPDATE Summary of this function goes here
%   Detailed explanation goes here
%     + Update
%       + load existing progress_cache.mat
%       + if yes, update the progress
%       + if not, goto Start
%       + check if finished.
%       + if not finished, return another combination and 'continue'
%       + if finished, delete progress_cache.mat and return last combination and 'finished'

% check
if exist('progress_cache.mat','file') == 2
    % update
    load('progress_cache.mat','combinationList','progress');
    progress = progress + 1;
    if progress >= length(combinationList)
        % finished
        delete('progress_cache.mat');
        combination = combinationList{end};
        flag = 'finished';
        percent = 1.0;
    else
        % continue
        combination = combinationList{progress + 1};
        flag = 'continue';
        percent = progress/length(combination);
        save('progress_cache.mat','combinationList','progress');
    end
else
    % init
    [combination, flag, percent] = ...
        ResumableExperimentStart(combinationList);
end

end

