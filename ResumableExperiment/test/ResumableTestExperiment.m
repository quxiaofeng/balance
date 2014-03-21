function [ eer ] = ResumableTestExperiment(combination, varNameList, ...
    RESULTFOLDER)
%RESUMABLETESTEXPERIMENT Summary of this function goes here
%   Detailed explanation goes here

% Extract values from combination
for i = 1:length(varNameList)
    eval( sprintf('%s = combination.%s;', ...
        cell2mat(varNameList(i)), cell2mat(varNameList(i))));
end

% real experiment code
eer = SIGMA + DELTA + FILTERSIZE + BLOCK;

end

