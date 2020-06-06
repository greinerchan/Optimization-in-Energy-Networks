function [c1,c2] = crossover(p1,p2,Pc)
% use double point cross over here
% p1 = parent1, p2 = parent2, c1 = child1, c2 = child2, clear
numGenes = size(p1.genes,2);
%numGenes = 24;
ub = numGenes - 1;
lb = 1;
% find two different crossover points in the genes
crossP = round((ub-lb)*rand(2,1) + lb);
crossP1 = crossP(1); crossP2 = crossP(2);
flag = 1;
while flag
    %disp(crossP1);
    %disp(crossP2);
    crossP = round((ub-lb)*rand(2,1) + lb);
    crossP1 = crossP(1); crossP2 = crossP(2);
    if crossP1 ~= crossP2
        flag = 0;
    end
end

% get first point and second point
crossP1 = min(crossP);
crossP2 = max(crossP);

segment1 = p1.genes(:,1:crossP1);
segment2 = p2.genes(:,(crossP1+1):crossP2);
segment3 = p1.genes(:,(crossP2+1):end);

c1.genes = [segment1,segment2,segment3];

segment4 = p2.genes(:,1:crossP1);
segment5 = p1.genes(:,(crossP1+1):crossP2);
segment6 = p2.genes(:,(crossP2+1):end);

c2.genes = [segment4,segment5,segment6];

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

