function [ debug_state ] = CheckDebugStatus( debug_state )
% CheckDebugStatus, This function is deprecated, change to isdebugging.

debug_state = isdebugging( debug_state );

end