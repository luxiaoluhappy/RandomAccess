m=64;

 for i=1:100
     NUM_SUCCESS=0;
     for loop=1:100
    ALLO_CHANNEL=randi([1,64],1,i);
    for j=1:64       
        INDEX1=find(ALLO_CHANNEL==j);
        if length(INDEX1)==1
            NUM_SUCCESS=NUM_SUCCESS+1;
         % WAITTIME(INDEX(INDEX1))=[];
        end
    end
     end
    throughput(i)=NUM_SUCCESS/100/64;
 end
 x=1:100;
 plot(x,throughput);