function [ timeString ] = Seconds2String( seconds )
%SECONDS2STRING Summary of this function goes here
%   Detailed explanation goes here

seconds = double(seconds);
if seconds <= 0
    timeString = '';
    return;
end

SECONDS_PER_MONTH  = 2592000;
SECONDS_PER_WEEK   = 604800;
SECONDS_PER_DAY    = 86400;
SECONDS_PER_HOUR   = 3600;
SECONDS_PER_MINUTE = 60;

timeString = '';
if seconds > SECONDS_PER_MONTH % How many monthes
    tMonthes = floor(seconds/SECONDS_PER_MONTH);
    seconds = mod(seconds, SECONDS_PER_MONTH);
    if isempty(timeString)
        timeString = sprintf('%.0f Month',tMonthes);
    else
        timeString = strjoin({timeString sprintf('%.0f Month',tMonthes)});
    end
end
if seconds > SECONDS_PER_WEEK % How many weeks
    tWeeks = floor(seconds/SECONDS_PER_WEEK);
    seconds = mod(seconds, SECONDS_PER_WEEK);
    if isempty(timeString)
        timeString = sprintf('%.0f Week',tWeeks);
    else
        timeString = strjoin({timeString sprintf('%.0f Week',tWeeks)});
    end
end
if seconds > SECONDS_PER_DAY % How many days
    tDays = floor(seconds/SECONDS_PER_DAY);
    seconds = mod(seconds, SECONDS_PER_DAY);
    if isempty(timeString)
        timeString = sprintf('%.0f Day',tDays);
    else
        timeString = strjoin({timeString sprintf('%.0f Day',tDays)});
    end
end
if seconds > SECONDS_PER_HOUR % How many hours
    tHours = floor(seconds/SECONDS_PER_HOUR);
    seconds = mod(seconds, SECONDS_PER_HOUR);
    if isempty(timeString)
        timeString = sprintf('%.0f Hour',tHours);
    else
        timeString = strjoin({timeString sprintf('%.0f Hour',tHours)});
    end
end
if seconds > SECONDS_PER_MINUTE % How many minutes
    tMinutes = floor(seconds/SECONDS_PER_MINUTE);
    seconds = mod(seconds, SECONDS_PER_MINUTE);
    if isempty(timeString)
        timeString = sprintf('%.0f Minute',tMinutes);
    else
        timeString = strjoin({timeString sprintf('%.0f Minute',tMinutes)});
    end
end
if seconds > eps % How many seconds
    if isempty(timeString)
        timeString = sprintf('%.2f Second',seconds);
    else
        timeString = strjoin({timeString sprintf('%.2f Second',seconds)});
    end
end

end

