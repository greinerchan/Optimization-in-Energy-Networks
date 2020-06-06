function newPop = elitism(prevPop,curPop,Er)
% some best genes must remain
numPop = length(curPop.chromosomes);
elites = round(Er * numPop);
[rankedFit, rankedID] = sort([prevPop.chromosomes(:).fitness], 'descend');
% copy and paste elites to our new population
for i = 1:1:elites
    newPop.chromosomes(i).genes = prevPop.chromosomes(rankedID(i)).genes;
    newPop.chromosomes(i).fitness = prevPop.chromosomes(rankedID(i)).fitness;
    newPop.chromosomes(i).cost = prevPop.chromosomes(rankedID(i)).cost;
end
% copy and paste the rest population to our new population
for j = (elites+1):1:numPop
    newPop.chromosomes(j).genes = curPop.chromosomes(j).genes;
    newPop.chromosomes(j).fitness = curPop.chromosomes(j).fitness;
    newPop.chromosomes(j).cost = curPop.chromosomes(j).cost;
end
end

