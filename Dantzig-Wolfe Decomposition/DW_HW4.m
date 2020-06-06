function [out] = DW_HW4(A,b,c,numLinks,borderRow,borderCol,k)
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
%   k is how many subproblem in the problem
%   numLinks is how many linking constrains we have in the problem
%
%   The borderRow is a matrix how we cut the rows for separating
%   matrix A for the linking constrain and subproblems
%   for example, borderRow=[1,1;
%                           2,3;
%                           4,5;
%                           6,7]; separates the row 1,2 to 3, 4 to 5 
%                                 6 to 7
%
%   The borderCol is a martrix how we cut the columns for separating
%   matrix A for the linking constrain and subproblems
%   for example, borderCol=[1,1;
%                           2,2;
%                           3,3]; separates the column 1, 2, 3 
% 
%   After cut the borderRows and borderCols. The whole A matrix can be
%   saprated in several blocks
%   
%   The numLinks is special for separating the linking constrains and the
%   linking constrains is always start at 1 
%  
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
%  In this case, borderRow is [1,2;3,4;5,6] since there are 
%  two linking constrains so the numLinks is 2
%  borderCol is the column we cut the original problem, in this 
%  case, the borderCol is [1,2;3,4], so the col 1 and col 2 are x1 and x2, 
%  col 3 and col 4 are y1 and y2. They seaparated the matrix as two 
%  subproblem

%{
   clear;
   A = [3,2,4;
       -1,0,0;
       1,0,0;
       0,-1,0;
       0,1,0;
       0,0,-1;
       0,0,1];
   b = [17;-1;2;-1;2;-1;2]; c= [-4;-1;-6];
   borderCol=[1,1;
              2,2;
              3,3];
          
   borderRow=[1,1;
              2,3;
              4,5;
              6,7];
   k=3; numLinks=1;
%}
   
   % initial the master parameter in matrix form
   [row_colCut,col_colCut]=size(borderCol);
   numVarT=borderCol(row_colCut,col_colCut); % number of variables we have
   A_linking=A(1:numLinks,:);% create linking constrains matrix
   b_master=b(1:numLinks,:); % create matrix for master problem b
   v=1; %initial num of iteration is 1
   p=2; %initial num of master variable is 2
   %initialization
   % get first feasible point
   c_random1=ones(numVarT,1); % use 1 for a cost object function 
   c_random2=zeros(numVarT,1)+(-1); % use -1 for a cost object function 
   X=[];% th x solution set 
   X1=[]; % the feasible solution X1
   X2=[]; % the feasible solution X2
   
   % find a feasible solution from random cost function 
   for i=2:1:k+1
       c1=c_random1(borderCol(i-1,1):borderCol(i-1,2),1);
       numVar=borderCol(:,2)-borderCol(:,1)+1;
       LB=zeros(numVar(i-1,1),1);
       X_init1=linprog(c1,A(borderRow(i,1):borderRow(i,2),...
           borderCol(i-1,1):borderCol(i-1,2)),...
           b(borderRow(i,1):borderRow(i,2),1),[],[],LB,[]);
       X1=[X1,X_init1.'];
   end
     
   % find another feasible solution from another random cost function 
   for i=2:1:k+1
       c1=c_random2(borderCol(i-1,1):borderCol(i-1,2),1);
       numVar=borderCol(:,2)-borderCol(:,1)+1;
       LB=zeros(numVar(i-1,1),1);
       X_init2=linprog(c1,A(borderRow(i,1):borderRow(i,2),...
           borderCol(i-1,1):borderCol(i-1,2)),...
           b(borderRow(i,1):borderRow(i,2),1),[],[],LB,[]);
       X2=[X2,X_init2.'];
   end
   X=[X1;X2]; % two initial feasible solution
   % find the initial master problem
   r1=A_linking*X1.'; z1 = X1*c;
   r2=A_linking*X2.'; z2 = X2*c; 
   master_object=[];A_master=[];
   master_object=[z1,z2];A_master=[r1,r2];
while 1
   %step 1 master problem solution
   [master_row,master_col]=size(master_object);U=ones(1,master_col);
   LB=zeros(master_col,1);
   [u,FVAL,EXITFLAG,OUTPUT,LAMBDA] = linprog(master_object,A_master,b_master,U,1,LB,[]);
   lamda=-LAMBDA.ineqlin; sigma = -LAMBDA.eqlin;
   %step 2 relaxed problem solution
   %objective funtion for of subproblems
   v=[];
   for i=1:1:k
       v_x=c(borderCol(i,1):borderCol(i,2),1).'-(lamda.')*A_linking(:,...
           borderCol(i,1):borderCol(i,2));
       [row_v,col_v]=size(v_x);
       v_x(row_v,numVarT)=0;
       v=[v;v_x];
   end
   % find the solution for each subproblem, and combine them for 
   % the feasible solution
   X_sub=[];
   for i=2:1:k+1
     numVar=borderCol(:,2)-borderCol(:,1)+1;
     LB=zeros(numVar(i-1,1),1);
     X_s = linprog(v(i-1,1:numVar(i-1,1)),A(borderRow(i,1):borderRow(i,2),...
           borderCol(i-1,1):borderCol(i-1,2)), b(borderRow(i,1):...
           borderRow(i,2),1),[],[],LB,[]);
     X_sub=[X_sub,X_s.'];
   end
   % find r1 and z for the new feasible solution
   X=[X;X_sub]; r1=A_linking*X_sub.'; z = X_sub*c;
   [row_vv,col_vv]=size(v); v_t=[];
   for i=1:1:row_vv
        v_t=[v_t,v(i,1:numVar(i,1))]; 
   end
   % objective function value of the current relaxed problem
   v_t_val=v_t*X_sub.';  
   %step 3 covergence checking
   if v_t_val<sigma %if v< sigma
       master_object=[master_object,z]; % update the master function
       A_master=[A_master,r1]; % update the master constrain
       U = [U,1]; LB=[LB;0]; % add a new u and lower bound 
       v=v+1; p=p+1;     % iteration+1, new constrains+1
   else
       [row_u,col_u]=size(u);
       X_result=zeros(1,col_u);
       for i=1:1:row_u
           X_result=X_result+u(i,1)*X(i,:); % get the result
       end
       out=X_result.'; % output the result
       return
   end
end
end
