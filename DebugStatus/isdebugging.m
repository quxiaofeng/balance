function [ debug_state ] = isdebugging( debug_state )
% isdebugging Check debug status to determine if it is debugging.
%    debug_state = isdebugging(debug_state) parse a general debug
%    description (a number, text, or a logical values) to a 
%    standard logical value.
% 
% 
%    It returns true (in a debugging state) if the input is
%       1, true, 'debug', 'test'.
%    It returns false (in a non-debugging state) if the input is
%       0, false, 'release', 'run'.
%    Default (blank) input leads to false. (Not debugging)
% 
% 
%    After using this function, debug related code in scripts and functions
%    can be simply surrounded by
% 
%        if debugState
%            ...
%        end
% 
% 
%    In addition, the function using isdebugging can be formatted as
% 
%       function [ result ] = Test(vars, debugState)
% 
%           debugState = isdebugging( debugState );
% 
%           if debugState
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

