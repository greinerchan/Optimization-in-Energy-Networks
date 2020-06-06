function [Pg,costFuel] = findFuelCost(mpc, genes)

% econimic dispatach for each plan and calculate the cost of fuel
numGen = length(genes(:,1));
lb = mpc.generator(:,3).';
ub = mpc.generator(:,2).';
fixedCost = mpc.generator(:, 6).';
varCost = mpc.generator(:, 9).';
Pl = mpc.load;
%Pl = load;
periods = length(Pl);
onem=ones(1,numGen);
Aeq=ones(1,numGen);
K=zeros(1,numGen);
for i=1:1:periods
    curLB = lb .* genes(:,i).'; 
    curUB = ub .* genes(:,i).'; 
    LB((i-1)*numGen+1:i*numGen)=curLB;
    UB((i-1)*numGen+1:i*numGen)=curUB;
    %A1((i-1)*numGen+1:i*numGen)= [];
    f((i-1)*numGen+1:i*numGen)=varCost;
    Aeq(i,(i-1)*numGen+1:i*numGen)=onem;
end

% Rampup constraints 

A_rampup = zeros(numGen * periods,numGen * periods);
A_rampup(1,1) = -1; A_rampup(1,4) = 1; 
A_rampup(2,4) = -1; A_rampup(2,7) = 1;
A_rampup(3,1) = 1;
A_rampup(4,2) = -1; A_rampup(4,5) = 1;
A_rampup(5,5) = -1; A_rampup(5,8) = 1;
A_rampup(6,2) = 1;
A_rampup(7,3) = -1; A_rampup(7,6) = 1;
A_rampup(8,6) = -1; A_rampup(8,9) = 1;
A_rampup(9,3) = 1;


b_rampup = [200;200;200;100;100;100;100;100;100];

% rampdown constrains
A_rampdown = zeros(numGen * periods,numGen * periods);
A_rampdown(1,1) = 1; A_rampdown(1,4) = -1; 
A_rampdown(2,4) = 1; A_rampdown(2,7) = -1;
A_rampdown(3,1) = -1;
A_rampdown(4,2) = 1; A_rampdown(4,5) = -1;
A_rampdown(5,5) = 1; A_rampdown(5,8) = -1;
A_rampdown(6,2) = -1;
A_rampdown(7,3) = 1; A_rampdown(7,6) = -1;
A_rampdown(8,6) = 1; A_rampdown(8,9) = -1;
A_rampdown(9,3) = -1;

b_rampdown = [300;300;300;150;150;150;100;100;100];

A = [A_rampup;A_rampdown]; b = [b_rampup;b_rampdown];

options = optimset('Display', 'off');
x0 = [];
x = linprog(f,A,b,Aeq,Pl,LB,UB,x0,options);
if isempty(x)
    x = linprog(f,[],[],Aeq,Pl,LB,UB,x0,options);
end
for i=1:1:periods
    PP(i,:)=x((i-1)*numGen+1:i*numGen);
end
for i=1:periods*numGen
    C(i)= f(i)*x(i);
end
totalFixedCost = 0;
for i = 1:1:numGen
    totalFixedCost = totalFixedCost + sum(genes(i,:) * fixedCost(i));
end
costFuel=sum(C) + totalFixedCost;
Pg = x;
%{
verify with DCOPF without line constrains
clear;
mpc = case9;
mpc.branch(:,6) = 0;
numGen = length(mpc.gencost(:,1));
c = mpc.gencost(:, 5);
b = mpc.gencost(:, 6).';
a = mpc.gencost(:, 7).';
lb = mpc.gen(:,10).';
ub = mpc.gen(:,9).';
Pl = sum(mpc.bus(:,3));
periods = length(Pl);
A=ones(1,numGen);
Aeq=ones(1,numGen);
K=zeros(1,numGen);
for i=1:1:periods
    LB((i-1)*numGen+1:i*numGen)=lb;
    UB((i-1)*numGen+1:i*numGen)=ub;
    Aeq((i-1)*numGen+1:i*numGen)=K;
    A1((i-1)*numGen+1:i*numGen)=c;
    B1((i-1)*numGen+1:i*numGen)=b;
    CC(i,(i-1)*numGen+1:i*numGen)=A;
end
Beq = 0;
H=2*diag(A1);
P1=quadprog(H,B1,Aeq,Beq,CC,Pl,LB,UB);
for i=1:periods
    PP(i,:)=P1((i-1)*numGen+1:i*numGen);
end
for i=1:periods*numGen
       C(i)=A1(i)*P1(i)^2+B1(i)*P1(i);
end
costFuel=sum(C)+periods*sum(a);
dispatch=PP.';

mat = rundcopf(mpc);



% Rampup constraints 

A_rampup = zeros(numGen * periods,numGen * periods);
A_rampup(1,1) = -1; A_rampup(1,4) = 1; 
A_rampup(2,4) = -1; A_rampup(2,7) = 1;
A_rampup(3,1) = 1;
A_rampup(4,2) = -1; A_rampup(4,5) = 1;
A_rampup(5,5) = -1; A_rampup(5,8) = 1;
A_rampup(6,2) = 1;
A_rampup(7,3) = -1; A_rampup(7,6) = 1;
A_rampup(8,6) = -1; A_rampup(8,9) = 1;
A_rampup(9,3) = 1;


b_rampup = [200;200;200;100;100;100;100;100;100];

% rampdown constrains
A_rampdown = zeros(numGen * periods,numGen * periods);
A_rampdown(1,1) = 1; A_rampdown(1,4) = -1; 
A_rampdown(2,4) = 1; A_rampdown(2,7) = -1;
A_rampdown(3,1) = -1;
A_rampdown(4,2) = 1; A_rampdown(4,5) = -1;
A_rampdown(5,5) = 1; A_rampdown(5,8) = -1;
A_rampdown(6,2) = -1;
A_rampdown(7,3) = 1; A_rampdown(7,6) = -1;
A_rampdown(8,6) = 1; A_rampdown(8,9) = -1;
A_rampdown(9,3) = -1;

b_rampdown = [300;300;300;150;150;150;100;100;100];

A = [A_rampup;A_rampdown]; b = [b_rampup;b_rampdown];
%}
end


