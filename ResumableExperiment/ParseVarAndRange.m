function [combinations, excelNameStrings, excelIndex, ...
    excelNameStringForEachCombination] = ParseVarAndRange(...
    varNameList, varRangeList)
%PARSEVARANDRANGE Summary of this function goes here
%   Detailed explanation goes here
%
%   Input
%       varNameList - String cell of var names
%
%       Example:
%           varNameList = {'DELTA','SIGMA','FILTERSIZE','BLOCK'};
%
%       varRangeList - Double array cell of vars' range
%
%       Example:
%           varRangeList = {0.1:0.1:0.2, 1:1:2, [10 20], [100 200]};
%
%   Output
%       combinations - the struct array of all vars
%
%       Example:
%           combinations(1).FILTERSIZE = 10;
%
%       excelNameStrings - the excel string for each result
%
%       Example:
%           >> disp(excelNameStrings)
%           Result FILTERSIZE 10 BLOCK 100.xls
%           Result FILTERSIZE 20 BLOCK 100.xls
%           Result FILTERSIZE 10 BLOCK 200.xls
%           Result FILTERSIZE 20 BLOCK 200.xls
%
%       excelIndex - the index of result of excel file name
%
%       Example:
%             excelIndex =
%                  1
%                  1
%                  1
%                  1
%                  2
%                  2
%                  2
%                  2
%                  3
%                  3
%                  3
%                  3
%                  4
%                  4
%                  4
%                  4
%

% Parse value matrix from var value ranges
for iCombination=1:length(varRangeList)
    currentRange = cell2mat(varRangeList(iCombination));
    currentRange = currentRange(:);
    if iCombination == 1
        valueMatrix = currentRange;
    else
        newColumnOfValue = repmat(currentRange',[size(valueMatrix,1), 1]);
        newColumnOfValue = newColumnOfValue(:);
        oldValueMatrix = repmat(valueMatrix, [length(currentRange), 1]);
        valueMatrix = [oldValueMatrix, newColumnOfValue];
    end
end

valueCells = num2cell(valueMatrix);

% Parse struct from matrix for return
combinations = cell2struct(valueCells', varNameList, 1);

% Parse Excel File Name String
leadingString = 'Result ';
if length(varRangeList) == 2
    excelNameStrings = leadingString;
elseif length(varRangeList) > 2
    % Parse values to string
    for iCombination=3:length(varRangeList)
        currentRange = cell2mat(varRangeList(iCombination));
        currentRange = currentRange(:);
        if iCombination == 3
            currentRange = num2str(currentRange);
            currentRangeWithName = [...
                repmat([cell2mat(varNameList(iCombination)) ' '], ...
                [size(currentRange,1) 1]) currentRange];
            excelNameStrings = [repmat([leadingString], ...
                [size(currentRangeWithName,1), 1]) currentRangeWithName];
        else
            newColumnOfValue = repmat(currentRange', ...
                [size(excelNameStrings,1), 1]);
            newColumnOfValue = num2str(newColumnOfValue(:));
            newColumnVarName = repmat(...
                [' ' cell2mat(varNameList(iCombination)) ' '], ...
                [size(newColumnOfValue, 1), 1]);
            oldValueMatrix = repmat(excelNameStrings, ...
                [length(currentRange), 1]);
            excelFileExt = repmat('.xls', ...
                [size(oldValueMatrix,1), 1]);
            excelNameStrings = [oldValueMatrix, ...
                newColumnVarName, newColumnOfValue, excelFileExt];
        end
    end
end

% Parse the excel index
first2Size = length(cell2mat(varRangeList(1))) ...
    * length(cell2mat(varRangeList(2)));
excelIndex = [];
excelNameStringForEachCombination = [];
for iCombination=1:size(excelNameStrings,1),
    excelIndex = [excelIndex; ones(first2Size,1) * iCombination];
    excelNameStringForEachCombination = ...
        [excelNameStringForEachCombination; ...
        repmat(excelNameStrings(iCombination,:), [first2Size, 1])];
end

end

