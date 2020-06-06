function [newGenes] = BitOperator(genes)
%The bit operator changes the bit positions to that of a more regular form
%i.e. change bit 010 to 000 or 101 to 111, with a certain amount of 
%probability. For instance, bits 011 can be changed to bits 000 
%(probability of 25%) or 111 (probability of 75%) and similarly bits 100 
%to 000 (probability of 75%) or 111 (probability of 25%).
[units, periods] = size(genes);

% change the bits pattern for genes
tempGenes = genes;
for j = 1:1:units
    for k = 1:3:periods
        curVector = tempGenes(j,k:k+2);
        newVector = BitOperatorHelper(curVector);
        tempGenes(j,k:k+2) = newVector;
    end
end
newGenes = tempGenes;
end

