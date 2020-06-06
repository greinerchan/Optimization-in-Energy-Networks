function startCost = findStartCost(mpc,genes)
% find the start up cost
numGen = length(genes(:,1));
numPeriod = length(genes(1,:));
starCostVar = mpc.generator(:,7);
IS = mpc.initialStatus;
% if the bit from 0 to 1 it will have start cost

% add the initial status, which is close for all generator
genes = [IS,genes];
startCost = 0;
for i = 1:1:numGen
    for j = 1:1:numPeriod
        if genes(i,j+1) - genes(i,j) == 1
            startCost = startCost + starCostVar(i);
        end
    end
end
end

