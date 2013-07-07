classdef SaveResultsTest < matlab.unittest.TestCase
    %SAVERESULTSTEST Test for saving results to an excel function group
    %   Test the function group of saving experiment results to an excel
    %   file.
    %
    %   Usage:
    %       clear;testCase=SaveResultsTest;res = run(SaveResultsTest)
    %
    properties
        DELTA
        DELTARANGE
        SIGMA
        SIGMARANGE
        currentValue
        xlsFileName
        firstItem
        rightInitResult
        rowIndex;
        colIndex;
    end
    methods(TestMethodSetup)
        function prepareValues(testCase)
            testCase.DELTA=3;
            testCase.DELTARANGE=1:10;
            testCase.SIGMA=12;
            testCase.SIGMARANGE=11:20;
            testCase.currentValue=23.3;
            testCase.xlsFileName='results.xls';
            testCase.firstItem='Delta/Sigma FilterSize 35';
            testCase.rightInitResult={testCase.firstItem};
            for i=1:length(testCase.SIGMARANGE)
                testCase.rightInitResult{1,i+1}=testCase.SIGMARANGE(i);
            end
            for i=1:length(testCase.DELTARANGE)
                testCase.rightInitResult{i+1,1}=testCase.DELTARANGE(i);
            end
            testCase.rowIndex=4;
            testCase.colIndex=3;
        end
    end
    methods(TestMethodTeardown)
        function removeXlsFile(testCase)
            if exist(testCase.xlsFileName,'file')
                delete(testCase.xlsFileName);
            end
        end
        function clearValues(testCase)
        end
    end
    methods(Test)
        function testInit(testCase)
            testresults=InitResultsForExcel(...
                testCase.firstItem,...
                testCase.DELTARANGE,...
                testCase.SIGMARANGE);
            testCase.verifyEqual(testresults, testCase.rightInitResult, ...
                'The ''results'' cell is not initialed correctly');
        end
        function testUpdate(testCase)
            testresults=SaveAValueToResults(testCase.rightInitResult, ...
                testCase.DELTA, testCase.SIGMA, testCase.currentValue);
            testCase.verifyEqual(...
                testresults{testCase.rowIndex,testCase.colIndex}, ...
                testCase.currentValue, ...
                'The value is not saved correctly');
        end
        function testSave(testCase)
            xlswrite(testCase.xlsFileName, testCase.rightInitResult);
            testCase.verifyEqual(exist(testCase.xlsFileName,'file'), 2, ...
                'The four Rois are not loaded correctly');
        end
    end
end

