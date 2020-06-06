function [B_inv,b] = swapVars(A, row, column)
% swap row and column variable, A(row,column) is pivot value 
[row2, col2] = size(A);
A_rs = A(row, column);
J = [1:(column-1), (column+1):col2]; I = [1:(row-1), (row+1):row2];
B(row,column) = 1/A_rs; B(row,J) = A(row,J)/A(row,column);
B(I,column) = -A(I,column)/A(row,column);
B(I,J) = A(I,J)+B(I,column)*A(row,J);
B(:,col2) = [];
[row3, col3] = size(B);
B_inv = B(:,1:(col3-1));  b = B(:,col3);
end
