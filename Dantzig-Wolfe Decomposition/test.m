function [out] = test(A,b,c,borderCol,borderRow)
%TEST Summary of this function goes here
%   Detailed explanation goes here
   clear;
   A = [3,2,4;
       -1,0,0;
       1,0,0;
       0,-1,0;
       0,1,0;
       0,0,-1;
       0,0,1];
   b = [17;-1;2;-1;2;-1;2]; c= [-4;-1;-6];
   borderCol=[1,2,3];borderRow=[1,3,5,7];
   
   % initial the master parameter in matrix form
   L1 = A(1:1,1:1);
   L2 = A(1:1,2:2);
   L3 = A(1:1,3:3);
   b_master = b(1:1,:);
   % initial the subproblem 1 in matrix form
   A_sub1 = A(2:3,1:1);
   b_sub1 = b(2:3,:);
   c_sub1 = c(1:1,:);  
   % initial the subproblem 2 in matrix form
   A_sub2 = A(4:5,2:2);
   b_sub2 = b(4:5,:);
   c_sub2 = c(2:2,:);
   % initial the subproblem 3 in matrix form
   A_sub3 = A(6:7,3:3);
   b_sub3 = b(6:7,:);
   c_sub3 = c(3:3,:); 
   % initial the bounds
   U=[1,1];   LB=[0;0];
   %initialization
   % first point
   v=1;p=2; 
   c1=-1;c2=-1;c3=-1;
   X1 = linprog(c1,A_sub1,b_sub1,[],[],0,[]);
   X2 = linprog(c2,A_sub2,b_sub2,[],[],0,[]);
   X3 = linprog(c3,A_sub3,b_sub3,[],[],0,[]);
   z1 = [X1,X2,X3]*c; r1=[L1,L2,L3]*[X1,X2,X3].';
   X=[X1,X2,X3]; master_object=[];A_master=[];
   %second point
   c1=1;c2=1;c3=-1;
   X1 = linprog(c1,A_sub1,b_sub1,[],[],0,[]);
   X2 = linprog(c2,A_sub2,b_sub2,[],[],0,[]);
   X3 = linprog(c3,A_sub3,b_sub3,[],[],0,[]);
   X_temp = [X1,X2,X3]; X=[X;X_temp];
   z2 = X_temp*c; r2=[L1,L2,L3]*X_temp.';
   master_object=[z1,z2];A_master=[r1,r2];
while 1
   %step 1 master problem solution
   [u,FVAL,EXITFLAG,OUTPUT,LAMBDA] = linprog(master_object,A_master,b_master,U,1,LB,[]);
   lamda=-LAMBDA.ineqlin; sigma = -LAMBDA.eqlin;
   
   %step 2 relaxed problem solution
   %objective funtion for of the first subproblem
   v1=c_sub1-lamda*L1; v2=c_sub2-lamda*L2;v3=c_sub3-lamda*L3;
   X1 = linprog(v1,A_sub1,b_sub1,[],[],0,[]);
   X2 = linprog(v2,A_sub2,b_sub2,[],[],0,[]);
   X3 = linprog(v3,A_sub3,b_sub3,[],[],0,[]);
   X_temp=[X1,X2,X3];
   X=[X;X_temp];    v=[v1,v2,v3]*X_temp.'; 
   z=X_temp*c; r1=[L1,L2,L3]*X_temp.';
   %step 3 covergence checking
   if v<sigma
       master_object=[master_object,z];
       A_master=[A_master,r1];
       U = [U,1]; LB=[LB;0];
   else
       [row_u,col_u]=size(u);
       X_result=[0,0,0];
       for i=1:1:row_u
           X_result=X_result+u(i,1)*X(i,:);
       end
       out=X_result;
       return
   end
end
end

