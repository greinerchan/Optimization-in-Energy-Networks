function population = InitPop(pop,units,periods)

% create initial population in binary form, with random 0 or 1
for i = 1:1:pop
    population.chromosomes(i).genes = round(rand(units,periods));
    % set flag to show the value is change, otherwise no need to calculate
    % again, save time
    population.chromosomes(i).flag = 1;
end

end

