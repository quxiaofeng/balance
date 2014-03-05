function [ debug_state ] = CheckDebugStatus( debug_state )
%CHECKDEBUGSTATUS Check debug status
%    debug_state = CheckDebugStatus(debug_state) parse a general debug
%    description to a standard logical value.
%
%
%    It returns true (in a debugging state) if input is
%       1, true, 'debug', 'test'.
%    It returns false (in a non-debugging state) if input is
%       0, false, 'release', 'run'.
%    Default (blank) input leads to false. (Not debugging)
%
%
%    After using this function, debug related code in scripts and functions
%    can be simply surrounded by
%
%        if debug_state
%            ...
%        end
%
%
%    In addition, the function using CheckDebugStatus can be formatted as
%
%       function [ result ] = Test(vars, debug)
% 
%           debug = CheckDebugStatus( debug );
% 
%           if debug
%               display 'debugging';
%               result = 'debugging';
%           else
%               result = 'running';
%           end
%           display(result);
%       end
%
%    For more information, see <a href="matlab:
%    web('https://github.com/quxiaofeng/balance')">balance</a>.


if nargin == 1
    switch debug_state
        case 1
            debug_state = true;
        case 0
            debug_state = false;
        case true
            debug_state = true;
        case false
            debug_state = false;
        case 'debug'
            debug_state = true;
        case 'release'
            debug_state = false;
        case 'test'
            debug_state = true;
        case 'run'
            debug_state = false;
        otherwise
            display(['wrong debugflag(' ...
                '1, true,  ''debug'',   ''test'', ' ...
                '0, false, ''release'', ''run''   ',...
                ')']);
            debug_state = false;
    end
else
    debug_state = false;
end

end

