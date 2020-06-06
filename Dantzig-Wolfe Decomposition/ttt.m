clear;
% set up a initial condtion for the input
%-------------------------------------------------------------------------
A = [1,1;
    1,-1;
    -1,-1;
    -3,-1;
    1,0;
    0,1]
b=[9;4;-2;-3;5;5];
c=[2;1];
borderRow=[1,4;            
           5,5 
           6,6];
borderCol=[1,1;
           2,2];
k=2; numLinks=4;
%-------------------------------------------------------------------------
my_result=modified(A,b,c,numLinks,borderRow,borderCol,k);