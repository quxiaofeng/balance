function displaydebugstate(vars, debugState)
% DISPLAYDEBUGSTATE Shows how to use the **isdebugging** function.

% Example: 
%     displaydebugstate(1,'debug);
%
%     The result should be as this:
%
%
% result =
%
% debugging
%
%
%     This can be seen by 
%
% type('ref.txt');
%

debugState = isdebugging( debugState );

if debugState
    result = 'debugging';
else
    result = 'running';
end

display(result);

end