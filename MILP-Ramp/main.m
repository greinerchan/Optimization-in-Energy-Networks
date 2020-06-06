clear;
mpc = data;
[f,intcon,A,b,Aeq,beq,LB,UB] = findMilp(mpc);


[x2,FVAL2,exitflag2] = milp(f,intcon,A,b,Aeq,beq,LB,UB);
timer = 0;
for i = 1:10
    tic
    [x1,FVAL1,exitflag1] = intlinprog(f,intcon,A,b,Aeq,beq,LB,UB);
    timer = timer + toc;
end

avgT = timer / 10;