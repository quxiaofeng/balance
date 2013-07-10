classdef ResumableExperimentTest < matlab.unittest.TestCase
    %RESUMABLEEXPERIMENTTEST Test for resumable experiment function group
    %   Test the function group of resumable experiment. The plan of
    %   this set function group is that:
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
    %     + Update
    %       + load existing progress_cache.mat
    %       + if yes, update the progress
    %       + if not, goto Start
    %       + check if finished.
    %       + if not finished, return another combination and 'continue'
    %       + if finished, delete progress_cache.mat and return last combination and 'finished'
    %   There two function:
    %      combinationList = {[1 2 3], [4 5 6], [7 8 9]};
    %      [combination,flag,percentage]=ResumableExperimentStart(combinationList);
    %      while(strcmp(flag,'finished'))
    %          experiment code
    %          [combination,flag,percentage]=ResumableExperimentUpdate(combinationList);
    %      end
    %
    %   Example:
    %       clear;testCase=SaveResultsTest;res = run(SaveResultsTest)
    %
    
    properties
        DELTA
    end
    
    methods(TestMethodSetup)
        function prepareValues(testCase)
        end
    end
    
    methods(TestMethodTeardown)
        function clearValues(testCase)
        end
    end
    
    methods(Test)
        function testExp(testCase)
            
            testCase.verifyEqual(1, 1, ...
                'The ''results'' cell is not initialed correctly');
        end
    end
end

