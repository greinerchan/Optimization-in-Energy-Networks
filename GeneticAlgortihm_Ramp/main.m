clear;

tic
pop = 6; units = 3; periods = 3; Pc = 0.9; Pm = 0.1; Er = 0.2;
maxGen = 25; mpc = data;
[bestFit, Pg, minCost] = GA(pop,units,periods,Pc,Pm,Er,maxGen,mpc);
toc
