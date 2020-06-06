function newGenes = minTimeFeasible(mpc,genes)
%MINTIMEFEASIBLE Summary of this function goes here
%   Detailed explanation goes here
flag = 1; iter = 0;
while flag
    ngenes = BitOperator(genes);
    iter = iter + 1;
    %disp(MinTimeVio(mpc,newGenes));
    if MinTimeVio(mpc,ngenes) < 40 || iter > 10
        flag = 0;
        newGenes = ngenes;
    end
end
end

