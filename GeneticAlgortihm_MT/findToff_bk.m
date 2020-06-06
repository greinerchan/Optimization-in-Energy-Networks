function Toff = findToff(No_Unit,curPeriod,genes)
% find how long the generator is on
count = 0;
if genes(No_Unit,curPeriod) == 1
    Toff = 0;
else
    flag = 1;
    while flag
        curNum = genes(No_Unit, curPeriod);
        if curNum == 0
            flag = 1;         
            count = count + 1;
            if curPeriod ~= 1
                curPeriod = curPeriod - 1;
            else
                Toff = count;
                return
            end
        else
            flag = 0;
        end
    end
end
Toff = count;
end

