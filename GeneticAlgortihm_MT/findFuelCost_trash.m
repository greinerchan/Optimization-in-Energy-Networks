function costFuel = findFuelCost(mpc, genes)

% econimic dispatach for each plan and calculate the cost of fuel
numGen = length(genes(:,1));
B = mpc.generator(:, 5).';
A = mpc.generator(:, 4).';
lb = mpc.generator(:,2).';
ub = mpc.generator(:,3).';
Pl = mpc.load(:,2);
%Pl = load;
periods = length(Pl);
A=ones(1,numGen);
Aeq=ones(1,numGen);
K=zeros(1,numGen);
for i=1:1:periods
    curLB = lb .* genes(:,i).'; 
    curUB = ub .* genes(:,i).'; 
    LB((i-1)*numGen+1:i*numGen)=curLB;
    UB((i-1)*numGen+1:i*numGen)=curUB;
    Aeq((i-1)*numGen+1:i*numGen)=K;
    A1((i-1)*numGen+1:i*numGen)=c;
    B1((i-1)*numGen+1:i*numGen)=b;
    CC(i,(i-1)*numGen+1:i*numGen)=A;
end
Beq = 0;
H=2*diag(A1);
options = optimset('Display', 'off');
x0 = [];
x = quadprog(H,B1,Aeq,Beq,CC,Pl,LB,UB,x0,options);
for i=1:1:periods
    PP(i,:)=x((i-1)*numGen+1:i*numGen);
end
for i=1:periods*numGen
       C(i)=A1(i)*x(i)^2+B1(i)*x(i);
end
costFuel=sum(C)+periods*sum(a);
%dispatch=PP.';

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
%}
end


