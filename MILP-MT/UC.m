function  [plan,Pg,minCost] = UC(mpc)
% perform unit commitment with MUT/MDT constrains

generator = mpc.generator;
demand = mpc.load(:,2);
J = length(generator(:,1)); T = length(demand);

% the spinning reserve is 5% of load 
sp = 0.05;
sp_resv = sp * demand;

% equals 1 if unit j is on in time period t
v = optimvar('v', J, T,'Type','integer','LowerBound',0,'UpperBound',1);
% equals 1 if unit j starts up at the beginning of time period t, 
% and 0 otherwise;
y = optimvar('y', J, T,'Type','integer','LowerBound',0,'UpperBound',1);
% equals 1 if unit j shuts down at the beginning of time period
% t, and 0 otherwise.
z = optimvar('z', J, T,'Type','integer','LowerBound',0,'UpperBound',1);

% objective function
Pgg = optimvar('Pg', J, T);
problem = optimproblem('Objective', sum(generator(:,4)' * v) ...
    + sum(generator(:,5)' * Pgg) + sum(generator(:,6)' * y) ...
    + sum((generator(:,10)' * z)));

% 1. equality constrains

% generation for each period == demand for each period
problem.Constraints.Pg_eq = sum(Pgg,1) == demand.';

% any unit that is online can be shut down but not started up or vice versa
gen_status = optimconstr(J,T-1);
for j=2:T
    gen_status(:,j-1) = y(:, j) - z(:, j) == v(:,j) - v(:, j-1);
end

problem.Constraints.gen_status = gen_status;
problem.Constraints.yz_status = y + z <= 1;

% 2. inequality constrains
% Spinning reserve constraint
%problem.Constraints.sp = sum(v .* (repmat(generator(:,3),1,T))) ... 
%    >= sum(Pgg,1) + sp_resv.';

problem.Constraints.res = sum(v.*(repmat(generator(:,3),1,T))-Pgg,1) >= sp_resv.';


% generator ouput constrains
problem.Constraints.P_min = Pgg >= repmat(generator(:,2),1,T) .* v;
problem.Constraints.P_max = Pgg <= repmat(generator(:,3),1,T) .* v;

% Uptime and Downtime Constraints

% These constraints account for the fact that a unit cannot be turned on or 
% off arbitrarily. If unit j starts up in time period t then it has to run 
% for at least TjU time periods before it can be shut down. Similarly, if 
% it is shut down at t then it has to remain off for at least TjD periods.

IS = generator(:,7);
up = IS > 0;
down = IS < 0;
MUT = generator(:, 8);
MDT = generator(:, 9);

% where Lj = min{|T |, Uj } and Uj is the number of time periods that j is 
% required to be on at the start of the planning horizon.
U = (MUT - IS) .* up;
L = min(T, U);

problem.Constraints.MUT1 = optimconstr(J);
problem.Constraints.MUT2 = optimconstr(J,T);

for i=1:1:J
    if L(i) > 0
        problem.Constraints.MUT1(i) = sum(1 - v(i,1:L(i)) ) == 0;
    end
    
    for k = (L(i)+1):(T-MUT(i)+1)
        problem.Constraints.MUT2(i,k) = sum(v(i,k:k+MUT(i)-1)) >= MUT(i) * y(i,k);
    end
    
    for k = (T-MUT(i)+2):T
        problem.Constraints.MUT2(i,k) = sum(v(i,k:T)-y(i,k:T)) >= 0;
    end
end

% where Fj = min{|T|,Dj} and Dj is the number of time periods that unit j 
% is required to remain off at the start of the planning horizon.
D = (MDT + IS) .* down;
F = min(T, D);

problem.Constraints.MDT1 = optimconstr(J);
problem.Constraints.MDT2 = optimconstr(J,T);

for i = 1:1:J
    if F(i) > 0
        problem.Constraints.MDT1(i) = sum(v(i,1:F(i))) == 0;
    end
    
    for k = (F(i)+1):(T-MDT(i)+1)
        problem.Constraints.MDT2(i,k) = sum(1 - v(i,k:k+MDT(i)-1)) >= ...
            MDT(i) * z(i,k);
    end
    
    for k = (T - MDT(i) + 2):T
        problem.Constraints.MDT2(i,k) = sum(1 - v(i,k:T)-z(i,k:T)) >= 0;
    end
end

problem = prob2struct(problem);
[x,fval,~,~] = intlinprog(problem);

plan = round(reshape(x(241:480), 10, 24));
Pg = round(reshape(x(1:240), 10, 24));
minCost = fval;

end

