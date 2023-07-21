xpcall(function ()
    for k, v in pairs(os.date("*t")) do print(k, v) end
end, print)