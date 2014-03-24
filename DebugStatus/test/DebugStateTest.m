classdef DebugStateTest < matlab.unittest.TestCase
    % DebugStateTest tests results returned by isdebugging

    properties
        TestData
    end
 
    methods(TestClassSetup)
        function setup(testCase)
            testCase.TestData.RefOutputFilename = 'ref.txt';
            testCase.TestData.OutputFilename = 'output.txt';
            testCase.TestData.ExampleCommand = ...
                            'run ..\example\displaydebugstate(1,''debug'')';
        end
    end
 
    methods(TestClassTeardown)
        function teardown(testCase)
            delete(testCase.TestData.OutputFilename);
        end
    end
    
    methods (Test)
        function testExample(testCase) % the example function
            % the expected output is 'ref.txt'
            expOutputText = fileread(testCase.TestData.RefOutputFilename);
            fileID = fopen(testCase.TestData.OutputFilename,'w');
            nbytes = fprintf(fileID,'%s', ...
                evalc(testCase.TestData.ExampleCommand));
            fclose(fileID);
            outputText = fileread(testCase.TestData.OutputFilename);
            verifyEqual(testCase,outputText,expOutputText);
        end

        function testNumberOne(testCase) % 1
            debugState = isdebugging(1);
            expDebugState = true;
            verifyEqual(testCase,debugState,expDebugState);
        end

        function testNumberZero(testCase) % 0
            debugState = isdebugging(0);
            expDebugState = false;
            verifyEqual(testCase,debugState,expDebugState);
        end

        function testLogicTrue(testCase) % true
            debugState = isdebugging(true);
            expDebugState = true;
            verifyEqual(testCase,debugState,expDebugState);
        end

        function testLogicFalse(testCase) % false
            debugState = isdebugging(false);
            expDebugState = false;
            verifyEqual(testCase,debugState,expDebugState);
        end

        function testTextDebug(testCase) % 'debug'
            debugState = isdebugging('debug');
            expDebugState = true;
            verifyEqual(testCase,debugState,expDebugState);
        end

        function testTextRelease(testCase) % 'release'
            debugState = isdebugging('release');
            expDebugState = false;
            verifyEqual(testCase,debugState,expDebugState);
        end

        function testTextTest(testCase) % 'test'
            debugState = isdebugging('test');
            expDebugState = true;
            verifyEqual(testCase,debugState,expDebugState);
        end

        function testTextRun(testCase) % 'run'
            debugState = isdebugging('run');
            expDebugState = false;
            verifyEqual(testCase,debugState,expDebugState);
        end

        function testTextHello(testCase) % 'hello', not included
            debugState = isdebugging('hello');
            expDebugState = false;
            verifyEqual(testCase,debugState,expDebugState);
        end

        % backward compatibility

        function testBackwardCompatibilityNumberOne(testCase) % 1
            debugState = CheckDebugStatus(1);
            expDebugState = true;
            verifyEqual(testCase,debugState,expDebugState);
        end

        function testBackwardCompatibilityNumberZero(testCase) % 0
            debugState = CheckDebugStatus(0);
            expDebugState = false;
            verifyEqual(testCase,debugState,expDebugState);
        end

        function testBackwardCompatibilityLogicTrue(testCase) % true
            debugState = CheckDebugStatus(true);
            expDebugState = true;
            verifyEqual(testCase,debugState,expDebugState);
        end

        function testBackwardCompatibilityLogicFalse(testCase) % false
            debugState = CheckDebugStatus(false);
            expDebugState = false;
            verifyEqual(testCase,debugState,expDebugState);
        end

        function testBackwardCompatibilityTextDebug(testCase) % 'debug'
            debugState = CheckDebugStatus('debug');
            expDebugState = true;
            verifyEqual(testCase,debugState,expDebugState);
        end

        function testBackwardCompatibilityTextRelease(testCase) % 'release'
            debugState = CheckDebugStatus('release');
            expDebugState = false;
            verifyEqual(testCase,debugState,expDebugState);
        end

        function testBackwardCompatibilityTextTest(testCase) % 'test'
            debugState = CheckDebugStatus('test');
            expDebugState = true;
            verifyEqual(testCase,debugState,expDebugState);
        end

        function testBackwardCompatibilityTextRun(testCase) % 'run'
            debugState = CheckDebugStatus('run');
            expDebugState = false;
            verifyEqual(testCase,debugState,expDebugState);
        end

        function testBackwardCompatibilityTextHello(testCase) % 'hello', not included
            debugState = CheckDebugStatus('hello');
            expDebugState = false;
            verifyEqual(testCase,debugState,expDebugState);
        end
    end    
end