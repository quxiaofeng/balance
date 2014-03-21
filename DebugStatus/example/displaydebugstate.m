function displaydebugstate(vars, debugState)

debugState = isdebugging( debugState );

if debugState
    display 'debugging';
    result = 'debugging';
else
    result = 'running';
end

display(result);

end