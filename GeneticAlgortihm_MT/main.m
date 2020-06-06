clear;
tic
pop = 40; units = 10; periods = 24; Pc = 0.9; Pm = 0.1; Er = 0.1;
maxGen = 200; mpc = testcase1;
[plan, Pgg, minCost] = GA(pop,units,periods,Pc,Pm,Er,maxGen,mpc);
toc
