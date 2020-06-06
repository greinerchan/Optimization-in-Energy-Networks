function [plan, Pgg, minCost] = GA(pop,units,periods,Pc,Pm,Er,maxGen,mpc)
% this is main genetic algorithm to find the bestfit individual
%%
% PartI, initial set up, random generation the initial generation
curPopulation = InitPop(pop,units,periods);

%generation = 1;
%%
for generation = 2:1:maxGen
disp(['Generation #', num2str(generation)]);
% PartII, bit change operation, ELD and minimum time check operation 
%   and mutation to abtain the feasible solution and evaluate them
    curPopulation = feasiblePop(mpc,curPopulation);
    for i = 1:1:pop
        [fitness, cost] = Fitness(mpc,curPopulation.chromosomes(i).genes);
        curPopulation.chromosomes(i).fitness = fitness;
        curPopulation.chromosomes(i).cost = cost;
    end
    % % PartIII, elitism the good genes
    if generation == maxGen
        finalPop = elitism(prevPopulation, curPopulation, Er);
        break
    end
    if generation > 2
        curPopulation = elitism(prevPopulation, curPopulation, Er);
    end
    %% plot
    allFit = [curPopulation.chromosomes(:).fitness];
    if generation == 2
        fit_P1 = max(allFit);
        TOF_P1 = 1/fit_P1 - 1;
        TOF = TOF_P1;
    end
    fit = max(allFit);
    TOF2 = 1/fit - 1;
    TOF = [TOF,TOF2];
    %%
    prevPopulation = curPopulation;
% PartIV, genetic procedures
    %1 selection
    for j = 1:2:pop
        [p1,p2] = Selection(curPopulation);
        %2 crossover
        [c1, c2] = crossover(p1, p2, Pc);
        %3 mutation
        c1 = mutation(c1, Pm);
        c2 = mutation(c2, Pm);
        curPopulation.chromosomes(j).genes = c1.genes;
        curPopulation.chromosomes(j+1).genes = c2.genes;
    end
end
%%
for m = 1:1:pop
        [fitness, cost] = Fitness(mpc,finalPop.chromosomes(i).genes);
        finalPop.chromosomes(i).fitness = fitness;
        finalPop.chromosomes(i).cost = cost;
end

[rankedFit, rankedID] = sort([finalPop.chromosomes(:).fitness], 'descend');

plan = finalPop.chromosomes(rankedID(1)).genes;
Pg = findFuelCost(mpc, plan);
Pgg = zeros(units,periods);
ptr = 1;
for i = 1:1:periods
    for j = 1:1:units
        Pgg(j,i) = Pg(ptr);
        ptr = ptr + 1;
    end
end

minCost = finalPop.chromosomes(rankedID(1)).cost;
allFit = [finalPop.chromosomes(:).fitness];
bestFit = max(allFit);
TOF2 = 1/bestFit - 1;
TOF = [TOF,TOF2];

figure;
x = 1:maxGen;
y = TOF;

plot(x,y);
xlabel('Generation')
ylabel('TOF')
end
%{
    %population2 = BitOperator(population);
    %curPopulation = BitOperator(curPopulation);
    %curPopulation = EDFeasible(curPopulation,mpc);
    [rankedFit, rankedID2] = sort([newPop.chromosomes(:).fitness], 'descend');
    curFit = newPop.chromosomes(rankedID2(1)).genes;
    curFit2 = newPop.chromosomes(rankedID2(15)).genes;
    minCost1 = findFuelCost(mpc,curFit); 
    minCost2 = minCost1 + findStartCost(mpc,curFit);
    minCost3 = findFuelCost(mpc,curFit) + findStartCost(mpc,curFit);
%}