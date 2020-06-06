function idx = findDecimals(x)
% find the index of decimals in the x vector
idx = [];
for i = 1:1:length(x)
    if x(i) ~= floor(x(i))
        idx = [idx,i];
    end
end
end

