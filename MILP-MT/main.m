clear;
timer = 0;
for i = 1:10
    tic
    case1 = testcase1;
    [plan1,Pg1,minCost1] = UC(case1);
   timer = timer + toc;
end

avgT = timer / 10;


