function [f,intcon,A,b,Aeq,beq,LB,UB] = findMilp(mpc)
% find the parameter for the mixed integer linear programming
%clear;
%mpc = data;
numGen = size(mpc.generator,1); numPeriod = length(mpc.load);
gen_lb = mpc.generator(:,3); gen_ub = mpc.generator(:,2); 
fixedCost = mpc.generator(:,6); startCost = mpc.generator(:,7);
shutCost = mpc.generator(:,8);  varCost = mpc.generator(:,9);

% variable arrange [P;v;z;y]
% step 1, find the cost coefficient for the objective function
f = zeros((numPeriod + 1) * numGen * 4, 1); numGenVar = numPeriod + 1;
for i = 1:1:numPeriod
    for j = 1:1:numGen
        for k = 1:1:numGenVar
            f((j - 1) * numGenVar + k) = varCost(j);
            f(numGen * numGenVar + (j - 1) * numGenVar + k) = fixedCost(j);
            f(2 * numGen * numGenVar + (j - 1) * numGenVar + k) = shutCost(j);
            f(3 * numGen * numGenVar + (j - 1) * numGenVar + k) = startCost(j);
        end
    end
end

% step 2, find the equality constrains
% 1. demand equality
Aeq_demand = zeros(3,numGen * numGenVar * 4);
Aeq_demand(1,2) = 1; Aeq_demand(1,6) = 1; Aeq_demand(1,10) = 1; 
Aeq_demand(2,3) = 1; Aeq_demand(2,7) = 1; Aeq_demand(2,11) = 1; 
Aeq_demand(3,4) = 1; Aeq_demand(3,8) = 1; Aeq_demand(3,12) = 1; 

% 2. any unit that is online can be shut down but not started up or vice versa

% period 1
Aeq_status = zeros(9,numGen * numGenVar * 4);
Aeq_status(1,13) = 1; Aeq_status(1,14) = -1; Aeq_status(1,26) = -1; 
Aeq_status(1,38) = 1;

Aeq_status(2,17) = 1; Aeq_status(2,18) = -1; Aeq_status(2,30) = -1; 
Aeq_status(2,42) = 1;

Aeq_status(3,21) = 1; Aeq_status(3,22) = -1; Aeq_status(3,34) = -1; 
Aeq_status(3,46) = 1;

% period 2
Aeq_status(4,14) = 1; Aeq_status(4,15) = -1; Aeq_status(4,27) = -1; 
Aeq_status(4,39) = 1;

Aeq_status(5,18) = 1; Aeq_status(5,19) = -1; Aeq_status(5,31) = -1; 
Aeq_status(5,43) = 1;

Aeq_status(6,22) = 1; Aeq_status(6,23) = -1; Aeq_status(6,35) = -1; 
Aeq_status(6,47) = 1;

% period 3
Aeq_status(7,15) = 1; Aeq_status(7,16) = -1; Aeq_status(7,28) = -1; 
Aeq_status(7,40) = 1;

Aeq_status(8,19) = 1; Aeq_status(8,20) = -1; Aeq_status(8,32) = -1; 
Aeq_status(8,44) = 1;

Aeq_status(9,23) = 1; Aeq_status(9,24) = -1; Aeq_status(9,36) = -1; 
Aeq_status(9,48) = 1;

Aeq = [Aeq_demand;Aeq_status]; 
% find beq
load = mpc.load; beq_status = zeros(numGen * numPeriod, 1);
beq = [load; beq_status];
% step 3, find the inequality constrains

% Any unit at any time should operate above its minimum output power 
% and below its maximum output power
A_genlimits = zeros(6, numGenVar * numGen * 4);
% period 1
A_genlimits(1,2) = 1; A_genlimits(1,14) = -gen_ub(1); 
A_genlimits(2,2) = -1; A_genlimits(2,14) = gen_lb(1); 
A_genlimits(3,6) = 1; A_genlimits(3,18) = -gen_ub(2); 
A_genlimits(4,6) = -1; A_genlimits(4,18) = gen_lb(2); 
A_genlimits(5,10) = 1; A_genlimits(5,22) = -gen_ub(3); 
A_genlimits(6,10) = -1; A_genlimits(6,22) = gen_lb(3); 

% period 2
A_genlimits(7,3) = 1; A_genlimits(7,15) = -gen_ub(1); 
A_genlimits(8,3) = -1; A_genlimits(8,15) = gen_lb(1); 
A_genlimits(9,7) = 1; A_genlimits(9,19) = -gen_ub(2); 
A_genlimits(10,7) = -1; A_genlimits(10,19) = gen_lb(2); 
A_genlimits(11,11) = 1; A_genlimits(11,23) = -gen_ub(3); 
A_genlimits(12,11) = -1; A_genlimits(12,23) = gen_lb(3); 

% period 3
A_genlimits(13,4) = 1; A_genlimits(13,16) = -gen_ub(1); 
A_genlimits(14,4) = -1; A_genlimits(14,16) = gen_lb(1); 
A_genlimits(15,8) = 1; A_genlimits(15,20) = -gen_ub(2); 
A_genlimits(16,8) = -1; A_genlimits(16,20) = gen_lb(2); 
A_genlimits(17,12) = 1; A_genlimits(17,24) = -gen_ub(3); 
A_genlimits(18,12) = -1; A_genlimits(18,24) = gen_lb(3); 

b_gen = zeros(18,1);

% Rampup constraints 

A_rampup = zeros(9,numGenVar * numGen * 4);
A_rampup(1,1) = -1; A_rampup(1,2) = 1; 
A_rampup(2,2) = -1; A_rampup(2,3) = 1;
A_rampup(3,3) = -1; A_rampup(3,4) = 1;
A_rampup(4,5) = -1; A_rampup(4,6) = 1;
A_rampup(5,6) = -1; A_rampup(5,7) = 1;
A_rampup(6,7) = -1; A_rampup(6,8) = 1;
A_rampup(7,9) = -1; A_rampup(7,10) = 1;
A_rampup(8,10) = -1; A_rampup(8,11) = 1;
A_rampup(9,11) = -1; A_rampup(9,12) = 1;

b_rampup = [200;200;200;100;100;100;100;100;100];

% rampdown constrains
A_rampdown = zeros(9,numGenVar * numGen * 4);
A_rampdown(1,1) = 1; A_rampdown(1,2) = -1; 
A_rampdown(2,2) = 1; A_rampdown(2,3) = -1;
A_rampdown(3,3) = 1; A_rampdown(3,4) = -1;
A_rampdown(4,5) = 1; A_rampdown(4,6) = -1;
A_rampdown(5,6) = 1; A_rampdown(5,7) = -1;
A_rampdown(6,7) = 1; A_rampdown(6,8) = -1;
A_rampdown(7,9) = 1; A_rampdown(7,10) = -1;
A_rampdown(8,10) = 1; A_rampdown(8,11) = -1;
A_rampdown(9,11) = 1; A_rampdown(9,12) = -1;

b_rampdown = [300;300;300;150;150;150;100;100;100];

% security constraints should be satisfied in all periods of the 
% planning horizon
% period 1
A_security = zeros(3,numGenVar * numGen * 4);
A_security(1,14) = gen_ub(1); A_security(1,18) = gen_ub(2);
A_security(1,22) = gen_ub(3);
% period 2
A_security(2,15) = gen_ub(1); A_security(2,19) = gen_ub(2);
A_security(2,23) = gen_ub(3);
% period 3
A_security(3,16) = gen_ub(1); A_security(3,20) = gen_ub(2);
A_security(3,24) = gen_ub(3);

b_security = [150+15;500+50;400+40];

% sum up the inequality constrains
A = [A_genlimits;A_rampup;A_rampdown;-A_security];
b = [b_gen;b_rampup;b_rampdown;-b_security];

lb_gen = zeros(12,1);
ub_gen = inf(12,1);

lb_binary = zeros(36,1); ub_binary = ones(36,1);
LB = [lb_gen;lb_binary]; UB = [ub_gen;ub_binary];
% set initial generator status to 0
LB(13,1) = 0; LB(17,1) = 0; LB(21,1) = 0; 
UB(13,1) = 0; UB(17,1) = 0; UB(21,1) = 0;
LB(25,1) = 0; LB(29,1) = 0; LB(33,1) = 0; 
UB(25,1) = 0; UB(29,1) = 0; UB(33,1) = 0; 
LB(37,1) = 0; LB(41,1) = 0; LB(45,1) = 0; 
UB(37,1) = 0; UB(41,1) = 0; UB(45,1) = 0; 
intcon = 13:48;

end

