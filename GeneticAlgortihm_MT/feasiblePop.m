function newPopulation = feasiblePop(mpc,population)
% make the whole population fesible for both ED and MUT MDT
numPop = length(population.chromosomes);
for i = 1:1:numPop
    flag = 1; iter = 0;
    curGenes = population.chromosomes(i).genes;
    genes_copy = curGenes;
    while flag
        newGenes = minTimeFeasible(mpc,genes_copy);
        newGenes2 = EDFeasible(mpc,newGenes);
        genes_copy = newGenes2;
        iter = iter + 1;
        %disp(MinTimeVio(mpc,newGenes2));
        if (EDChecker(mpc,genes_copy) && MinTimeVio(mpc,genes_copy) < 40) ...
            || iter > 10
            goodGenes = genes_copy;
            flag = 0;
        end
    end
    population.chromosomes(i).genes = goodGenes;
end
newPopulation = population;
end

