function [lamda] = DW(A,c,b,numRowLink,numRowSub1,borderCol)
% Dantzig-Wolfe Decomposition method to solve a linear programming like
% and the number of subproblem is 2
%                   minimize c.'*x 
%             subject to  A*x <= b
%                           x >= 0
%   The A matrix has the special "block-angular" structure:
%    _____________________________________________________________________
%                   L1 L2 ...... LN
%                   A1
%               A =    A2
%                         .
%                           .
%                             .
%                                AN
%   ______________________________________________________________________      
%   
%   The numRowLink is how many rows are linking constrains
%   The border is the column cut the subproblem half, for example        
%   given minimize     -x1-2x2-4y1-3y2
%   subject to         |x1+x2|+2y1   |    <= 4
%                   L1 |   x2|+ y1+y2| L2 <= 3
%                      -----------------------
%                      2x1+x2|            <= 4
%                       x1+x2| sub 1 A1   <= 2
%                      -----------------------
%                            | y1+ y2 <= 2
%                   sub 2 A2 |3y1+2y2 <= 5
%                      -----------------------
%                           x,y >= 0
%             
%  In this case, numRowLink is 2 since there are two linking constrains 
%  the numRowSub1 is how many contrains the subproblem 1 has, in this case
%  is 2. The rest rows are constrains of the subproblem 2.
%  borderCol is the column we cut the original problem to halfs, in this 
%  case, the borderCol is 2, so the col 1 and col 2 are x1 and x2, col 3
%  and col 4 are y1 and y2. Col 2 seperate the original problem to two
%  subproblems
%  input: A,c,b,numRowLink,numRowSub1,borderCol

   [rowA, colA] = size(A); 
   % initial the master parameter in matrix form
   L1 = A(1:numRowLink,1:borderCol);
   L2 = A(1:numRowLink,borderCol+1:colA);
   b_master = b(1:numRowLink,:);
   % initial the subproblem 1 in matrix form
   A_sub1 = A(numRowLink+1:numRowLink+numRowSub1,1:borderCol);
   b_sub1 = b(numRowLink+1:numRowLink+numRowSub1,:);
   c_sub1 = c(1:borderCol,:);  
   % initial the subproblem 2 in matrix form
   A_sub2 = A(numRowLink+numRowSub1+1:rowA,borderCol+1:colA);
   b_sub2 = b(numRowLink+numRowSub1+1:rowA,:);
   c_sub2 = c(borderCol+1:colA,:);
   
   % initial tableau for the master problem
   B_inverse_initial = eye(numRowLink+2); s_initial = [b_master;1;1];
   B_lamda=[0,0,0,0]; lamda = [0;0;0;0].'; 
   % initial linprog condition for subproblem 1
   sub1_object = c_sub1; sub1_A = A_sub1; sub1_b = b_sub1;
   sub2_object = c_sub2; sub2_A = A_sub2; sub2_b = b_sub2;
   s = s_initial; B_inverse = B_inverse_initial;
   [rowB,colB] = size(B_inverse); mark = zeros(rowB,1);
   iteration = 1; v_sub1 = [];  v_sub2 = []; 
   rStar_min = -1;
   while rStar_min < 0
        sub1_x = linprog(sub1_object,sub1_A,sub1_b,[],[],[0;0],[]);
        v_sub1 = cat(2, v_sub1, sub1_x); 
        rStar_sub1 = (sub1_object.'-lamda(1,1:numRowLink)*L1)*sub1_x-lamda(numRowLink+1);
        r1 = sub1_x.'*sub1_object;
        sub2_x = linprog(sub2_object,sub2_A,sub2_b,[],[],[0;0],[]);
        v_sub2 = cat(2, v_sub2, sub2_x); 
        rStar_sub2 = (sub2_object.'-lamda(1,1:numRowLink)*L2)*sub2_x-lamda(numRowLink+2);
        r2 = sub2_x.'*sub2_object;
        rStar_min = min(rStar_sub1,rStar_sub2); 
       if rStar_sub1>rStar_sub2 && rStar_min < 0
           col_enter = [L2*sub2_x;0;1];
           %find_ratio = s./col_enter;
           %row_min = find(find_ratio==min(min(find_ratio)));
           s = round(s,6);
           row_min = smallRatio(s,col_enter);
           B_inverse = [B_inverse,s,col_enter];
           [B_inverse,b_value] = swapVars(B_inverse,row_min,6);
           B_inverse = smallToZero(B_inverse);
           mark(row_min,1) = 2*1000+iteration;
           B_lamda(1,row_min) = r2;
           lamda = B_lamda*B_inverse;
           sub1_object = c_sub1.'-lamda(1,1:numRowLink)*L1;
           sub2_object = c_sub2.'-lamda(1,1:numRowLink)*L2;
           sub1_object = sub1_object.';
           sub2_object = sub2_object.';
           s = b_value;
           s = round(s,6);
       end 
       if rStar_sub1<=rStar_sub2 && rStar_min < 0
           col_enter = [L1*sub1_x;1;0];
           %find_ratio = s./col_enter;
           %row_min = find(find_ratio==min(min(find_ratio)));
           s = round(s,6);
           row_min = smallRatio(s,col_enter);
           B_inverse = [B_inverse,s,col_enter];
           [B_inverse,b_value] = swapVars(B_inverse,row_min,6);
           B_inverse = smallToZero(B_inverse);
           mark(row_min,1) = 1*1000+iteration;
           B_lamda(1,row_min) = r1;
           lamda = B_lamda*B_inverse;
           sub1_object = c_sub1.'-lamda(1,1:numRowLink)*L1;
           sub2_object = c_sub2.'-lamda(1,1:numRowLink)*L2;
           sub1_object = sub1_object.';
           sub2_object = sub2_object.';
           s = b_value;
           s = round(s,6);
       end       
       iteration = iteration + 1;
   end
   assignin('base','lamda',lamda);
end

