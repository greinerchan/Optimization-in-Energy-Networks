function condition = findCondition(x,fval,bound,intcon,exitflag)
%FINDCONDITION Summary of this function goes here
%   Detailed explanation goes here

% condition 1, the subproblem does not have any feasble solution, so stop
if (exitflag ~= 1 && exitflag ~= 3)
    condition = 1;
    return
end

% condition 2, the subproblem find feasble and better solution with integer 
if abs(sum(x(intcon) - floor(x(intcon)))) <= 1e-12 && fval < bound ... 
        && (exitflag == 1 || exitflag == 3)
    condition = 2;
    return
end

% condition 3, the solution of subproblem is not better than last one
if fval >= bound && (exitflag == 1 || exitflag == 3)
    condition = 3;
    return
end

% condition 4, the solution of subproblem is not feasible, which means some
% of the integer constrains not fulfil, but potentially has better solution,
% we will relaxation it
if abs(sum(x(intcon) - floor(x(intcon)))) > 1e-12 ... 
        && (exitflag == 1 || exitflag == 3) && fval < bound
    condition = 4;
    return
end
end

