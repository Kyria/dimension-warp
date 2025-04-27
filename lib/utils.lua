utils = {} or utils


function utils.format_time(sec)
    local seconds = sec % 60
    local minutes = math.floor((sec / 60) % 60)
    local hours = math.floor(sec / 3600)
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end
