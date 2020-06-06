function newGenes= EDFeasible2(genes,mpc)
% check new population to fit the economic dispatch
genMax = mpc.generator(:,3);
load = mpc.load(:,2);

gen_output = (genMax.' * genes).';
for j = 1:1:length(gen_output)
    % if the generator is not enough, open a random generator to fit
    % until the load meeting
    if gen_output(j,1) < load(j,1)
        flag = 1;
    else 
        flag = 0;
    end
    while flag
        % find current generators which are close
        curGen = genes;
        % in which hour has trouble
        noGoodGene = curGen(:,j);
        % randomly choose a generator to open
        genClose = find(noGoodGene == 0);         
        NoUnits = genClose(randi(length(genClose)));
        % mutation the gene (open a generator randomly)
        noGoodGene(NoUnits,1) = 1;
        % calculate the load again to see if it meet
        genes(:,j) = noGoodGene;
        % calclate the generation again to check if it is meet
        gen_output = (genMax.' * genes).';
        if gen_output(j,1) < load(j,1)
            flag = 1;
        else 
            flag = 0;
        end
    end
end
newGenes = genes;
end



