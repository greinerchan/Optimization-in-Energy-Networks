function [B] = smallToZero(A)
% change very small number to zero in a matrix
[row,col] = size(A);
for i=1:1:row
    for j=1:1:col
        if abs(A(i,j)) <= 1e-6
            A(i,j) = 0;
        end
    end
end
A=round(A,6);
B=A;
end

