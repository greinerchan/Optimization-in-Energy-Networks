function newChromosome = mutation(chromosome,Pm)
% choose some places to mutation, flip the bits in those place
[rows, cols] = size(chromosome.genes);

for i = 1:1:rows
    for j = 1:1:cols
        mul = rand();
        if mul < Pm
            chromosome.genes(i,j) = 0;
        end
    end
end
newChromosome = chromosome;
end
