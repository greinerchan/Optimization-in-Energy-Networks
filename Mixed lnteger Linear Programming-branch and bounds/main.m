clear;


f=[-6 -2 -3 -5];
A=[-3 5 -1 -6;2 1 1 -1;1 2 4 5];
b=[-4 3 10]';
Aeq = [1, 1, 3, -2];
beq = [3];
intcon=[1 2 3];
LB=zeros(4,1);
UB=[];


[x1,fval1,exitflag1] = milp(f,intcon,A,b,Aeq,beq,LB,UB);
[x2,fval2,exitflag2]=intlinprog(f,intcon,A,b,Aeq,beq,LB,UB);