function boolean = EDChecker(mpc,genes)
% check if the population all meet the economic dispatch
genMax = mpc.generator(:,3);
load = mpc.load;
% get information of population
boolean_init = [];

gen_output = (genMax.' * genes).';
boolMatrix = gen_output >= load;
result = find(boolMatrix == 0, 1);
if ~isempty(result)
    a = 0;
else
    a = 1;
end
boolean_init = [boolean_init;a];

violations = find(boolean_init == 0, 1);
if isempty(violations)
    boolean = 1;
end
if ~isempty(violations)
    boolean = 0;
end

end

