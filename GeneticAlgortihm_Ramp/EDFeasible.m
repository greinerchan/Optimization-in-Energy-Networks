function newGenes= EDFeasible(mpc,genes)
% check new population to fit the economic dispatch
genMax = mpc.generator(:,2);
genMin = mpc.generator(:,3);
load = mpc.load;
reserves = mpc.reserves;
gen_output = (genMax.' * genes).';
gen_output_min = (genMin.' * genes).';

% initial the flag
flag1 = 0; flag2 = 0;
for j = 1:1:length(gen_output)
    % all Pmin > demand
    if gen_output_min(j,1) > load(j)
        flag1 = 1; 
    end
    if gen_output_min(j,1) < load(j)
        flag1 = 0;
    end
    % all Pmax < demand + reserve
    if gen_output(j,1) < load(j) + reserves(j)
        flag2 = 1;
    end
    if gen_output(j,1) > load(j) + reserves(j) 
        flag2 = 0;
    end
    while flag1 || flag2
        % if the generator minimum is more than load, close a random generator to fit
        % until the total minimum output is less than the demand
        % all Pmin > demand
        if flag1 == 1
            % find current generators which are close
            curGen = genes;
            % in which hour has trouble
            noGoodGene = curGen(:,j);
            % randomly choose a generator to close
            genOpen = find(noGoodGene == 1);         
            NoUnits = genOpen(randi(length(genOpen)));
            % mutation the gene (close a generator randomly)
            noGoodGene(NoUnits,1) = 0;
            % calculate the load again to see if it meet
            genes(:,j) = noGoodGene;
            % calclate the generation again to check if it is meet
            gen_output_min = (genMin.' * genes).';
            gen_output = (genMax.' * genes).';
            if gen_output_min(j,1) > load(j)
                flag1 = 1; 
            end
            if gen_output_min(j,1) < load(j)
                flag1 = 0;
            end
            if gen_output(j,1) < load(j) + reserves(j)
                flag2 = 1;
            end
            if gen_output(j,1) > load(j) + reserves(j) 
                flag2 = 0;
            end
        end
        % if the generator is not enough, open a random generator to fit
        % until the load meeting
        % all Pmax < demand + reserve
        if flag2 == 1
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
            gen_output_min = (genMin.' * genes).';
            if gen_output_min(j,1) > load(j)
                flag1 = 1;
            end
            if gen_output_min(j,1) < load(j)
                flag1 = 0;
            end
            if gen_output(j,1) < load(j) + reserves(j)
                flag2 = 1;
            end
            if gen_output(j,1) > load(j) + reserves(j) 
                flag2 = 0;
            end
        end
    end
end

newGenes = genes;
end



