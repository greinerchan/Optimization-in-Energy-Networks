function shutDownCost = findShutCost(mpc,genes)
% find the shut down cost
numGen = length(genes(:,1));
numPeriod = length(genes(1,:));
shutCostVar = mpc.generator(:,10);
IS = mpc.generator(:,7);

IS_M = zeros(numGen,1);

for i = 1:1:length(IS)
    if IS(i) > 0
        IS_M(i) = 1;
    else
        IS_M(i) = 0;
    end
end
% if the bit from 1 to 0 it will have shut down cost

% add the initial status, which is close for all generator
genes = [IS_M,genes];
shutDownCost = 0;
for i = 1:1:numGen
    for j = 1:1:numPeriod
        if genes(i,j+1) - genes(i,j) == -1
            shutDownCost = shutDownCost + shutCostVar(i);
        end
    end
end
end

