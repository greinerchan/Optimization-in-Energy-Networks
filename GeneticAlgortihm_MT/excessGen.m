function excessAmount = excessGen(mpc,genes)
% Pl = Pd + Spinning Reserve
% find how many excess power, which is PgMax - Pl
Pg_max = mpc.generator(:, 3).';
Pl = mpc.load(:,2);
[units, periods] = size(genes);
Pg_periods = [];
for i = 1:1:periods
    genOpen = genes(:,i);
    Pg = Pg_max * genOpen;
    Pg_periods = [Pg_periods;Pg];
end
P_excess = Pg_periods - Pl;
excessAmount = sum(P_excess);
end

