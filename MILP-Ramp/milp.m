function [x,fval,exitflag] = milp(f,intcon,A,b,Aeq,beq,LB,UB)
%INTLINPROG Summary of this function goes here
%   Detailed explanation goes here

% initial the problem
% set the bound and value to infinite, relaxation subproblem 
% could update them during iterations
bound = inf;
% initial the node array, the maximum node is 50000
numSpace = 50000;
for i = 1:1:numSpace
    % record fval for each node/problem
    tree.node(i).fval = nan;
    % record current solution
    tree.node(i).x = nan;
    % recotd current exitflag
    tree.node(i).exitflag = nan;
    % record which node is parent for curent node
    tree.node(i).parent = nan;
    % record A matrix for current problem
    tree.node(i).A = nan; 
    % record b matrix for current problem
    tree.node(i).b = nan;
end
% record the node need to visit next as queue, first we need to visit the 
% initial node, breadth first
toVist = [1];
% find how many column for the original problem
if ~isempty(A)
    [col] = size(A,2); 
else
    [col] = size(Aeq,2);
end

% enter the information for the first node
tree.node(1).A = A;
tree.node(1).b = b;

numNode = 1; x = inf;
% start looping
% while loop should continue when still has nodes to visit and the current 
% bound is not equal to ceil of the fval of the first node and the first
% node is solvable
while ~isempty(toVist) && bound ~= tree.node(1).fval && tree.node(1).fval ~= inf
    options = optimset('linprog');
    options.Display = 'off';
    curNode = toVist(1);
    toVist(1) = [];
    % find the current node
    [x_cur,fval_cur,exitflag_cur] = linprog(f,tree.node(curNode).A,tree.node(curNode).b,Aeq,beq,...
        LB,UB,options);
    x_cur = fixSmallViolation(x_cur);
    if (isempty(x_cur) && numNode == 1)
        disp('infeasible problem, please enter again');
        x = []; fval = []; exitflag = -2;        
    end
    condition = findCondition(x_cur,fval_cur,bound,intcon,exitflag_cur);
    switch condition
        case 1
            % the problem not feasible, so give inf to this problem
            tree.node(curNode).fval = inf;
            tree.node(curNode).exitflag = exitflag_cur;
            tree.node(curNode).x = [];
        case 2
            % the problem is feasible and better, update the value
            tree.node(curNode).x = fixSmallViolation(x_cur); 
            tree.node(curNode).fval = fval_cur; 
            tree.node(curNode).exitflag = exitflag_cur; bound = fval_cur;
            x = fixSmallViolation(x_cur); fval = fval_cur; 
            exitflag = exitflag_cur;
        case 3
            % base case 3, no need to contnue for next level.just record
            % current information
            tree.node(curNode).x = fixSmallViolation(x_cur); 
            tree.node(curNode).fval = fval_cur; 
            tree.node(curNode).exitflag = exitflag_cur;
        case 4
            % upadte the current node
            x_cur = fixSmallViolation(x_cur);
            tree.node(curNode).x = x_cur; 
            tree.node(curNode).fval = fval_cur; 
            tree.node(curNode).exitflag = exitflag_cur;
            x_integer = x_cur(intcon);
            idx = findDecimals(x_integer);
            idx_pick = intcon(idx(1));
            x_vio = x_cur(idx_pick);
            x_lower = floor(x_vio); x_upper = ceil(x_vio);
            % A1 is new constrain for the floor and A2 is for the ceil
            A1 = zeros(1,col); A2 = zeros(1,col);
            A1(1,idx_pick) = 1; b1 = x_lower;
            A2(1,idx_pick) = -1; b2 = -x_upper;
            % add the constrains for the new problem
            A_parent = tree.node(curNode).A;
            b_parent = tree.node(curNode).b;
            A_child1 = [A_parent;A1]; A_child2 = [A_parent;A2];
            b_child1 = [b_parent;b1]; b_child2 = [b_parent;b2];
            % update for child node
            tree.node(numNode+1).A = A_child1;
            tree.node(numNode+2).A = A_child2;
            tree.node(numNode+1).b = b_child1;
            tree.node(numNode+2).b = b_child2;
            tree.node(numNode+1).parent = curNode;
            tree.node(numNode+2).parent = curNode;
            
            % update the queue, first in first out, breadth first
            toVist = [toVist, numNode+1, numNode+2];
            numNode = numNode + 2;
        otherwise
            disp('the result does not meet any conditions')
    end
end
% take care of infeasible problem
if x == inf
    disp('infeasible problem, please enter again');
    x = []; fval = []; exitflag = -2;
end
end

