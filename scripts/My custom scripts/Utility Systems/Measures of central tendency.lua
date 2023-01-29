if Debug then Debug.beginFile("Measures of central tendency") end
OnInit("MCT", function ()
    Require "Maths"

    ---@class MCT
    ---@field mean fun(data: number[], weights?: number[]): number Returns the mean of the given data, add weights if is a weighted mean (use a copy of the data if you wanna use it again).
    ---@field mode fun(data: number[], forGroupedData?: boolean): number Returns the mode of the given data, you can set if is for grouped data (use a copy of the data if you wanna use it again).
    ---@field median fun(data: number[], forGroupedData?: boolean): number Returns the median of the given data, you can set if is for grouped data (use a copy of the data if you wanna use it again).
    local MCT = {}

    function MCT.mean(data, weights)
        local n = #data
        if n == 0 then
            return 0
        end

        local mean = 0
        if weights then
            local totalWeight = 0
            for i = 1, n do
                totalWeight = totalWeight + weights[i]
            end

            for i = 1, n do
                mean = mean + data[i] * weights[i]
            end

            mean = mean / totalWeight
        else
            for i = 1, n do
                mean = mean + data[i]
            end

            mean = mean / #data
        end
        return mean
    end

    function MCT.mode(data, forGroupedData)
        local n = #data
        if n == 0 then
            return 0
        end
        if forGroupedData then
            local intervalNumber = math.round(1 + 3.322 * math.log(n))

            table.sort(data)

            local minVal = data[1]
            local range = math.abs(minVal - data[n])
            local amplitude = range / intervalNumber

            local l = __jarray(0) ---@type number[] lower limit
            local L = __jarray(0) ---@type number[] upper limit
            for i = 1, intervalNumber do
                l[i] = minVal + (i-1)*amplitude
                L[i] = minVal + i*amplitude
            end

            local f = __jarray(0) ---@type integer[] frequencies
            for i = intervalNumber, 1, -1 do
                for j = #data, 1, -1 do
                    local x = data[j]
                    if x.isBetween(l[i], L[i]) then
                        f[i] = f[i] + 1
                        table.remove(data, j)
                    end
                end
            end

            local maxNumber = -math.Inf
            local maxF = 0
            for i = 1, intervalNumber do
                if f[i] > maxNumber then
                    maxNumber = f[i]
                    maxF = i
                end
            end

            return l[maxF] + ((f[maxF] - f[maxF-1])/((f[maxF] - f[maxF-1]) + (f[maxF] - f[maxF+1]))) * amplitude
        else
            local f = __jarray(0) ---@type table<number, integer> frequencies

            for i = 1, n do
                f[data[i]] = f[data[i]] + 1
            end

            local maxNumber = -math.Inf
            for _, v in pairs(f) do
                if v > maxNumber then
                    maxNumber = v
                end
            end

            return maxNumber
        end
    end

    function MCT.median(data, forGroupedData)
        local n = #data
        if forGroupedData then
            local intervalNumber = math.round(1 + 3.322 * math.log(n))

            table.sort(data)

            local minVal = data[1]
            local range = math.abs(minVal - data[n])
            local amplitude = range / intervalNumber

            local l = __jarray(0) ---@type number[] lower limit
            local L = __jarray(0) ---@type number[] upper limit
            for i = 1, intervalNumber do
                l[i] = minVal + (i-1)*amplitude
                L[i] = minVal + i*amplitude
            end

            local f = __jarray(0) ---@type integer[] frequencies
            for i = intervalNumber, 1, -1 do
                for j = #data, 1, -1 do
                    local x = data[j]
                    if x.isBetween(l[i], L[i]) then
                        f[i] = f[i] + 1
                        table.remove(data, j)
                    end
                end
            end

            local F = __jarray(0) ---@type integer[] acumulated frequencies
            for i = 1, intervalNumber do
                F[i] = F[i-1] + f[i]
            end
            local N = F[#F] // 2

            local I = 0 -- median class
            for i = 1, intervalNumber do
                I = I + 1
                if F[i] > N then
                    break
                end
            end

            return L[I] + ((N - F[I-1]) / f[I]) * amplitude
        else
            local half = n // 2

            table.sort(data)

            if half == 0 then
                return (data[half] + data[half+1]) / 2
            else
                return (data[(n+1)//2])
            end
        end
    end

    return MCT
end)
if Debug then Debug.endFile() end