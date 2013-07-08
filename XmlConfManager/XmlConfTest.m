classdef XmlConfTest < matlab.unittest.TestCase
    %XMLCONFTEST Test for managing configure by an xml file
    %   Test the function group of managing configure by an xml file
    %
    %
    %   Usage:
    %       clear;testCase=XmlConfTest;res = run(XmlConfTest)
    %
    properties
        xmlFileName
        matFileName
        objectFileName
    end
    methods(TestMethodSetup)
        function prepareValues(testCase)
            testCase.xmlFileName = 'config-right.xml';
            testCase.matFileName = 'config-right.mat';
            testCase.objectFileName = 'config-test.xml';
        end
        function checkFiles(testCase)
            if exist(testCase.xmlFileName,'file')
            else
                error('Cannot find the xml file!');
            end
            if exist(testCase.matFileName,'file')
            else
                error('Cannot find the mat file!');
            end
        end
    end
    methods(TestMethodTeardown)
        function deleteFiles(testCase)
            if exist(testCase.objectFileName, 'file')
                delete(testCase.objectFileName);
            end
        end
        function clearValues(testCase)
            clear('conf');
            clear('newconf');
        end
    end
    methods(Test)
        function testConfLoad(testCase)
            load(testCase.matFileName, 'conf');
            newConf.center.x    = str2double(XmlLoadAValueByLabel(...
                testCase.xmlFileName,    'x'));
            newConf.center.y    = str2double(XmlLoadAValueByLabel(...
                testCase.xmlFileName,    'y'));
            newConf.innerRadius = str2double(XmlLoadAValueByLabel(...
                testCase.xmlFileName,    'innerRadius'));
            newConf.outerRadius = str2double(XmlLoadAValueByLabel(...
                testCase.xmlFileName,    'outerRadius'));
            testCase.verifyEqual(newConf.center.x, newConf.center.x, ...
                'The value center.x is not loading right!');
            testCase.verifyEqual(newConf.center.y, newConf.center.y, ...
                'The value center.y is not loading right!');
            testCase.verifyEqual(newConf.innerRadius, ...
                newConf.innerRadius, ...
                'The value innerRadius is not loading right!');
            testCase.verifyEqual(newConf.outerRadius, ...
                newConf.outerRadius, ...
                'The value outerRadius is not loading right!');
        end
        function testConfSave(testCase)
            % load configure
            load(testCase.matFileName, 'conf');
            conf.comment='Test configure file saving.';
            % write configure to an xml file
            [ file, root ] = XmlInit('configure'); % init
            [ file, root, centerElement ] = ... % add a structure
                XmlAddANewNode( file, root, 'center' );
            [ file, centerElement ] = ...
                XmlAddANewNode( file, centerElement, 'x', ...
                sprintf('%d',conf.center.x) );
            [ file, centerElement ] = ... % add a comment
                XmlAddAComment( file, centerElement, conf.comment ); 
            [ file, centerElement ] = XmlAddANewNode( file, ...
                centerElement, 'y', sprintf('%d',conf.center.y) );
            file = XmlAddAComment( file, centerElement, conf.comment );
            [ file, root ] = XmlAddANewNode( file,root, 'innerRadius', ...
                sprintf('%d',conf.innerRadius) ); % add a value
            [ file, root ] = XmlAddANewNode( file,root, 'outerRadius', ...
                sprintf('%d',conf.outerRadius) );
            file = XmlAddAComment( file, root, conf.comment );            
            xmlwrite(testCase.objectFileName,file); % save to a xml file
            % verify
            fileID = fopen(testCase.xmlFileName);
            config_right = fscanf(fileID, '%s',[1 inf]);
            fclose(fileID);
            fileID = fopen(testCase.objectFileName);
            config = fscanf(fileID, '%s',[1 inf]);
            fclose(fileID);
            testCase.verifyEqual(config, config_right, ...
                'The config xml is not saved correctly');
        end
    end
end

