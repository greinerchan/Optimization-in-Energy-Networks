function [numZeroV, numOneV] = findSeq(genPeriods)
% find how the down time for each generators, so we can check if they 
% fufill the down time
% the idea to implement: given [0 0 0 0 1 1 0 1 0 1], if we cumsum this 
% we get [0 0 0 0 1 2 2 3 3 4], we find if continous 0, the value will keep
% as previous, so we can just find the frequency of the each cumsum value
% and then freq - 1 to find the continous number of 0
% for contiounous 1, same way, we just need to flip the orginal and then 
% use the same way

% example: numZeroV = [1,2,4], means current unis turn down for 1 hour, 
% 2 hours and 4 hours in given period

%genPeriods = [1 0 0 0 1 1 0 1 0 1 0 1 1 1 1 0 0 0 0];

% add a zero in the head to avoid 0 apear at first and we will count 1 less
genPeriods = [0,genPeriods];

findZeroV = genPeriods;
sumV = cumsum(findZeroV);
f = tabulate(sumV).';
numZeroV = f(2,:) - 1;
numZeroV = numZeroV(numZeroV ~= 0);

len = length(genPeriods);
oneV = ones(1,len);
findOneV = oneV - genPeriods;
sumV2 = cumsum(findOneV);
f2 = tabulate(sumV2).';
numOneV = f2(2,:) - 1;
numOneV = numOneV(numOneV ~= 0);

end

