function [ eer ] = exampleexperiment(combination, varNameList, ...
    RESULTFOLDER)
%RESUMABLETESTEXPERIMENT Summary of this function goes here
%   Detailed explanation goes here

% Extract values from combination
for i = 1:length(varNameList)
    eval( sprintf('%s = combination.%s;', ...
        cell2mat(varNameList(i)), cell2mat(varNameList(i))));
end

% simulated experiment code
eer = SIGMA + DELTA + FILTERSIZE + BLOCK;

display(sprintf(['\nSIGMA = %3.3f; DELTA = %3.3f; FILTERSIZE = %3.3f; ', ...
    'BLOCK = %3.3f'], SIGMA, DELTA, FILTERSIZE, BLOCK));
display(sprintf('RESULTFOLDER = %s\n',...
    RESULTFOLDER));

end

