%Small test problem, optimal solution should be -21
f=[-6 -2 -3 -5];
A=[-3 5 -1 -6;2 1 1 -1;1 2 4 5];
b=[-4 3 10]';
Aeq = [2, 1, 3, -2];
beq = [2];

LB=zeros(4,1);
UB=[];
yidx = [true; true; true; false];
miprog(f,A,b,Aeq,beq,LB,UB,yidx);


