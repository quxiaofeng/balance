function [ debug ] = CheckDebugStatus( debug )
%CHECKDEBUGSTATUS Check debug status
% debug = CheckDebugStatus(debug) translate a general debug description to
% a standard logical value.
% 
% It returns true if input is
%   1, true, 'debug', 'test'.
% It returns false if input is
%   0, false, 'release', 'run'.
% Default and blank input leads to false.
%
% After this, debug code can be simply surrounded by
%   if debug
%       ...
%   end

% debug
if nargin == 1
    switch debug
        case 1
            debug = true;
        case 0
            debug = false;
        case true
            debug = true;
        case false
            debug = false;
        case 'debug'
            debug = true;
        case 'release'
            debug = false;
        case 'test'
            debug = true;
        case 'run'
            debug = false;
        otherwise
            error(['wrong debugflag(' ...
                '1, true,  ''debug'',   ''test'', ' ...
                '0, false, ''release'', ''run''   ',...
                ')']);
    end
else
    debug = false;
end

end

