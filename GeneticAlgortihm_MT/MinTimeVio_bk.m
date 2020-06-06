function totalViolation = MinTimeVio_trash(mpc,genes)
% find how much current plan violation the minimum down/up time
MUT = mpc.generator(:,8);
MDT = mpc.generator(:,9);
IS = mpc.generator(:,7);
totalViolation = 0;

[units, periods] = size(genes);
for i = 1:1:units
    [numZeroV, numOneV] = findSeq(genes(i,:));
    % find MUT violation
    if IS(i) >= 0 && genes(i,1) == 1
        % if period 1 is 1, which means it keep open
        % add initial status to first period to make it continous
        numOneV(1,1) = numOneV(1,1) + IS(i);
        vioVector = numOneV.' - MUT(i);
        % only count negative number
        for j = 1:1:length(vioVector)
            if vioVector(j) < 0
                totalViolation = totalViolation + abs(vioVector(j));
            end
        end
    else
        % the generator close at period 1 or before period 1, 
        % so we ignore the initial status since it close at beginning
        vioVector = numOneV.' - MUT(i);
        for j = 1:1:length(vioVector)
            if vioVector(j) < 0
                totalViolation = totalViolation + abs(vioVector(j));
            end
        end
    end
    % find minimum down violation
    if IS(i) <= 0 && genes(i,1) == 0
        % if period 1 is 0, which means it keep close
        % add initial status to first period to make it continous
        numZeroV(1,1) = numZeroV(1,1) + abs(IS(i));
        vioVector = numZeroV.' - MDT(i);
        % only count negative number
        for j = 1:1:length(vioVector)
            if vioVector(j) < 0
                totalViolation = totalViolation + abs(vioVector(j));
            end
        end
    else
        % the generator open at period 1 or before period 1, 
        % so we ignore the initial status since it open at beginning
        vioVector = numZeroV.' - MDT(i);
        for j = 1:1:length(vioVector)
            if vioVector(j) < 0
                totalViolation = totalViolation + abs(vioVector(j));
            end
        end
    end
end
end

