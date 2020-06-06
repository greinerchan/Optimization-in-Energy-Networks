function SUC = findStartCost_trash(mpc,genes)
% find start up time for when the generator starts
% since the start up temperature will influence the price 
% the equation can be wrote ? + ?[1 - e(-Toff/?)]
alpha = mpc.generator(:,11);
delta = mpc.generator(:,12);
tau = mpc.generator(:,13);
IS = mpc.generator(:,7);
[units, periods] = size(genes);
startCost = 0;

for i = 1:1:units
    % if initial status is open, we just need to find all 0 sequaence 
    % for each unit in periods to find out the money cost
    initStatus = IS(i,1);
    if initStatus >= 0
       [zeroSeq, oneSeq] = findSeq(genes(i,:));
       for k = 1:1:length(zeroSeq)
           Toff = zeroSeq(k);
           startCost = startCost + alpha(i) + delta(i)*(1 - exp(-Toff/tau(i)));
       end
    else
        % if the initial is negative, which means the generator has already
        % turn down for several hour
        % when we open it at first, the Toff will be the initial down time
        % and then Toff will as usual
        if genes(i,1) == 1
           Toff = abs(initStatus(i));
           startCost_init = alpha(i) + delta(i)*(1 - exp(-Toff/tau(i)));
           [zeroSeq, oneSeq] = findSeq(genes(i,:));
           % ignore the last 0 sequenece since we need to determine it next
           % periods
           zeroSeq = zeroSeq(1,1:end-1);
           for k = 1:1:length(zeroSeq)
               Toff = zeroSeq(k);
               startCost = startCost + alpha(i) + delta(i)*(1 - exp(-Toff/tau(i)));
           end
           startCost = startCost_init + startCost;
        else
            % if we still keep banking it at beginning, the first start 
            % cost Toff will be Toff = abs(initialStatus) + number of 0s 
            % at beginning
            [zeroSeq, oneSeq] = findSeq(genes(i,:));
            Toff = abs(initStatus(i)) + zeroSeq(1,1);
            startCost_init = alpha(i) + delta(i)*(1 - exp(-Toff/tau(i)));
            % the rest are as usual, but we not count first one since we
            % already count it
            zeroSeq = zeroSeq(1,2:end)
            for k = 1:1:length(zeroSeq)
                Toff = zeroSeq(k);
                startCost = startCost + alpha(i) + delta(i)*(1 - exp(-Toff/tau(i)));
            end
            startCost = startCost_init + startCost;
        end
    end       
end
SUC = startCost;
end

