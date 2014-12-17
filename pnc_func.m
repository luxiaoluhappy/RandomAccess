function num_access =  pnc_func( pnc )

for i=1:10000
    pnc1(i)=((NUM_PRE-1)/NUM_PRE)^i+i*((N-1)/N)^(i-1)/N;
end

num_access=find(abs(pnc1-pnc)==min(abs(pnc1-pnc)));