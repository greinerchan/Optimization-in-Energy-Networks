function totalViolation = MinTimeVio(mpc,genes)

MUT = mpc.generator(:,8);
MDT = mpc.generator(:,9);
T = length(genes(:,1));
MUT_vio = 0; MDT_vio = 0;
for i = 1:1:T
    cur_MUT = MUT(i); cur_MDT = MDT(i);
    [numZeroV, numOneV] = findSeq(genes(i,:));
    up_diff = numOneV - cur_MUT;
    down_diff = numZeroV - cur_MDT;
    MUT_vio = MUT_vio + sum(abs(up_diff(up_diff < 0)));
    MDT_vio = MDT_vio + sum(abs(down_diff(down_diff < 0)));
end

totalViolation = MUT_vio + MDT_vio;
end