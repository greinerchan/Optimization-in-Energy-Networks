clear;
% test case 1

f=[-5 -8];
A=[1 1;5 9];
b=[6;45];
Aeq = [];
beq = [];
LB=zeros(2,1);
UB = [];
intcon=[1 2];


% test case 2
%{
f = [-2; -1; 1];
A = [1 4 -1; 2 -2 1];
b = [4; 12];
Aeq = [1 1 2];
beq = 2;
LB = zeros(3,1);
UB = ones(3,1);
intcon =[1;2;3];
%}

% test case 3
%{
f = -[8 11 6 4];
A = [5 7 4 3];
b = 14;
Aeq = [];
beq = [];
LB = [0 0 0 0]';
UB = [1 1 1 1]';
intcon = ones(4,1);
%}

% test case 4
%{
f=[-6 -2 -3 -5];
A=[-3 5 -1 -6;2 1 1 -1;1 2 4 5];
b=[-4 3 10]';
Aeq = [2, 1, 3, -2];
beq = [2];
intcon=[1 2 3];
LB=zeros(4,1);
UB=[];
%}

[x1,fval1,exitflag1] = milp(f,intcon,A,b,Aeq,beq,LB,UB);
[x2,fval2,exitflag2]=intlinprog(f,intcon,A,b,Aeq,beq,LB,UB);