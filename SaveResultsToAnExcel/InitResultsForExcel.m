function [ results ] = InitResultsForExcel( firstItem, rowRange, colRange )
%INITRESULTSFOREXCEL Init results for excel saving purpose
%   The results cell array is initialated here. After initialed, the
%   results can be accessed to save values and be saved to excel file.
%   Input:
%       firstItem:  The lefttop item of the table
%                       Could be the label of the row and the col
%                       Could be other infos about the results
%       rowRange:   The values of the row labels
%       colRange:   The values of the column labels
%   Output:
%       results:    The initialed result cell array
%   Usage:
%       results=InitResultsForExcel('Delta\Sigma FilterSize 35',...
%               DELTARANGE,SIGMARANGE);
results{1,                      1} = firstItem;
results(2:length(rowRange)+1,   1) = num2cell(rowRange);
results(1,   2:length(colRange)+1) = num2cell(colRange);
end

