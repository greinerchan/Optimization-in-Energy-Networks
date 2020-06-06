function [TOF,cost] = Fitness(mpc, genes)
% calculate the objective value of the given chromosome

numPeriods = length(genes(1,:));
numGen = length(genes(:,1));
% W1 = ramp up violations, W2 = ramp down violations
W1 = 1; W2 = 1;

ramp_up = mpc.generator(:,4); ramp_down = mpc.generator(:,5);
[Pg,fuelCost] = findFuelCost(mpc,genes);

% formate Pg
Pgg = zeros(numGen,numPeriods);
ptr = 1;
for i = 1:1:numPeriods
    for j = 1:1:numGen
        Pgg(j,i) = Pg(ptr);
        ptr = ptr + 1;
    end
end
% find total ramp up violation
% add initial generation first
Pg2 = [mpc.initialGeneration,Pgg];
total_up_vio = 0; total_down_vio = 0;
for i = 1:1:numPeriods
    rampup = Pg2(:,i+1) - Pg2(:,i);
    diff = rampup - ramp_up;
    violation = diff(diff > 0);
    total_up_vio = total_up_vio + sum(violation);
end

for i = 1:1:numPeriods
    rampdown = Pg2(:,i) - Pg2(:,i+1);
    diff = rampdown - ramp_down;
    violation = diff(diff > 0);
    total_down_vio = total_down_vio + sum(violation);
end

startUpCost = findStartCost(mpc,genes);
shutDownCost = findShutCost(mpc,genes);

FT = fuelCost + startUpCost + shutDownCost + W1 * total_up_vio + W2 * total_down_vio;
cost = fuelCost + startUpCost + shutDownCost;

TOF = 1 /(1 + FT);

end

