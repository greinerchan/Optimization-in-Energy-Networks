function mpc = data
% #Gen| Gen_max | Gen_min | Rampup | Rampdown | Fixed cost | Startup | Shutdown | Variable Cost | 
mpc.generator = [
          1 350   50	200   300   5   20  0.5 0.1
          2 200   80    100   150   7   18  0.3 0.125
          3 140   40    100   100   6    5  1.0 0.150
          ];
% variable load      
mpc.load =[150;500;400];
mpc.reserves = [15;50;40];
mpc.initialStatus = [0;0;0];
mpc.initialGeneration = [0;0;0];
end