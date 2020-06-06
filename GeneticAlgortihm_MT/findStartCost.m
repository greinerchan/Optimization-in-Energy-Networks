function startCost = findStartCost(mpc,genes)
% find the start up cost
numGen = length(genes(:,1));
numPeriod = length(genes(1,:));
startCostVar = mpc.generator(:,6);
IS = mpc.generator(:,7);

IS_M = zeros(numGen,1);

for i = 1:1:length(IS)
    if IS(i) > 0
        IS_M(i) = 1;
    else
        IS_M(i) = 0;
    end
end
% if the bit from 0 to 1 it will have start cost

% add the initial status, which is close for all generator
genes = [IS_M,genes];
startCost = 0;
for i = 1:1:numGen
    for j = 1:1:numPeriod
        if genes(i,j+1) - genes(i,j) == 1
            startCost = startCost + startCostVar(i);
        end
    end
end
end

