function [c1,c2] = crossover(p1,p2,Pc)
% use double point cross over here
% p1 = parent1, p2 = parent2, c1 = child1, c2 = child2, clear
numGenes = size(p1.genes,2);
%numGenes = 24;
ub = numGenes - 1;
lb = 1;

% find two different crossover points in the genes
crossP = round((ub-lb)*rand() + lb);


segment1 = p1.genes(:,1:crossP);
segment2 = p2.genes(:,(crossP+1):numGenes);


c1.genes = [segment1,segment2];

segment3 = p2.genes(:,1:crossP);
segment4 = p1.genes(:,(crossP+1):numGenes);


c2.genes = [segment3,segment4];

cross = rand(2,1);

if cross(1) <= Pc
    c1 = c1;
else
    c1 = p1;
end

if cross(2) <= Pc
    c2 = c2;
else
    c2 = p2;
end
end

