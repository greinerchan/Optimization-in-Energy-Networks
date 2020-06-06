%{
 function not used any more
function totalFuelCost = findFuelCost(mpc,genes)
% find the total fuel cost for each chromosome
load = mpc.load(:,2);
numGen = size(genes(:,1),1);
periods = size(genes(1,:),2);
gen = mpc.generator;
totalFuelCost = 0;
for i = 1:1:periods
    % find generators that works
    workGen = find(genes(:,i) == 1);
    % map to the orginal mpc
    cur_mpc = gen(workGen,:);
    curFuel = ED(cur_mpc, load(i));
    %disp(totalFuelCost);
    totalFuelCost = totalFuelCost + curFuel;
end
end
}%
