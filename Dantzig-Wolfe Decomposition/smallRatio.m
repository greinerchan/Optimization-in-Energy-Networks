function [row_min] = smallRatio(s,col_enter)
%SMALLRATIO Summary of this function goes here
%   choose smallest ratio, if has same, choose smaller col_enter
% s = [1;1/2;1/2;1];
%col_enter = [2;0;1;0]
[row2,col2] = size(s);
ratio = s./col_enter;
min=inf; minRatioIndex = [];
for i=1:1:row2
    cur = ratio(i,col2);
    if cur < min
        min = cur;
    end
end
for i=1:1:row2
    if ratio(i) == min
        minRatioIndex(i) = i;
    end
end
len = length(minRatioIndex);
min2 = inf;
for i=1:1:len
    if minRatioIndex(i) ~= 0
        cur = col_enter(minRatioIndex(i));
        if cur < min2 
            min2 = cur;
            row_min = i;
        end
    end
end
end

