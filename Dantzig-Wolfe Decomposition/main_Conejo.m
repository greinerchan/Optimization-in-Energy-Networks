clear;
% set up a initial condtion for the input
%-------------------------------------------------------------------------
A=[2,3,4,2,7,6,8,9;
  2,4,5,3,4,2,1,4;
  1,2,0,0,0,0,0,0;
  2,1,0,0,0,0,0,0;
  0,0,3,4,2,0,0,0;
  0,0,0,0,0,4,2,0;
  0,0,0,0,0,2,2,0;
  0,0,0,0,0,0,0,3;
  0,0,0,0,0,0,0,3];
b=[26;22;12;14;17;15;16;10;11];
c=[1;-4;2;-7;6;5;-3;2];
borderRow=[1,2;            
           3,4;
           5,5;
           6,7;
           8,9];
borderCol=[
           1,2;
           3,5;
           6,7;
           8,8];
k=4; numLinks=2;
%-------------------------------------------------------------------------

% get my result
my_result=DW_HW4(A,b,c,numLinks,borderRow,borderCol,k);

% get the linprog result
lb=zeros(8,1);
X_linP=linprog(c,A,b,[],[],lb,[]);

% comparing the X_linP with my_result, they are the same