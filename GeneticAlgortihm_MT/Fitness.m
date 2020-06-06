function [FT, totalCost] = Fitness(mpc, genes)
% calculate the objective value of the given chromosome
% W1 and W2 are weight coefficent
W1 = 100; 
W2 = 10;

[~,fuelCost] = findFuelCost(mpc,genes);
startUpCost = findStartCost(mpc,genes);
shutDownCost = findShutCost(mpc,genes);
excess = excessGen(mpc,genes);
totalViolation = MinTimeVio(mpc,genes);

totalCost = fuelCost + startUpCost + shutDownCost;
tof = fuelCost + startUpCost + shutDownCost + W1*totalViolation + W2*excess;

FT = 1/(1+tof);

end

