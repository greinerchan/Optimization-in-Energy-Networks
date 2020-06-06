function x_v = fixSmallViolation(x_v)
% set the senesitivity 1e-6, if in the bound e, the number will be rounded
e = 1e-6;
%disp(num2str(x_v));
for i = 1:1:length(x_v)
    x_low = floor(x_v(i)); x_high = ceil(x_v(i));
    if abs(x_v(i) - x_low) <= e || abs(x_v(i) - x_high) <= e
        x_v(i) = round(x_v(i));
    end
end
%disp(num2str(x_v));
end

