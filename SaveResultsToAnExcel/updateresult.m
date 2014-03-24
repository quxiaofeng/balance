function [ results ] = updateresult( results, ...
    rowValue, colValue, currentValue )
%UPDATERESULT Saves a value to the results structure array
%   Saves the currentValue to the results structure array according to the rowValue and colValue.
rowRange = cell2mat(results(2:end,1));
colRange = cell2mat(results(1,2:end));
results{    find(rowRange==rowValue)+1, ...
            find(colRange==colValue)+1 } = currentValue;
end

