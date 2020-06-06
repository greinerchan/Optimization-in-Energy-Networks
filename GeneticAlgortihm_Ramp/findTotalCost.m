function minCost = findTotalCost(mpc,genes)
% find the minCost for the result

fuelCost = findFuelCost(mpc,genes,1);
startUpCost = findStartCost(mpc,genes);
shutDownCost = findShutCost(mpc,genes);

minCost = fuelCost + startUpCost + shutDownCost;


end

