 NUM_PRE=64;
 NUM_SLOT=1000; 
 THRE_H=256;
 THRE_L=4;
 MAX_RETRANS=10;
 
for round=1:10
    ARR_RATE=2*round; 
    NEW_ARR=poissrnd(ARR_RATE,1,NUM_SLOT);
    
    NUM_SUCCESS=0;
    TOTAL_USERS=0;
    
    WAITTIME=zeros(1,20000);
    WINDOW=THRE_L*ones(1,20000);
    WAITTIME_LIST=zeros(1,20000);
    TIME_RETRANS=zeros(1,20000);
    for slot=1:NUM_SLOT
        
        WAITTIME(USERS+1:USERS+NEW_ARR(slot))=0;
        USERS=USERS+NEW_ARR(slot);
        
        tmp=randsrc(1,USERS,[0 1;1-P_RA P_RA]);
        INDEX=find(tmp==1);
        
        NUM_RA=length(INDEX);
        
        ALLO_CHANNEL=zeros(1,NUM_RA);
        ALLO_CHANNEL=randi([1,NUM_PRE],1,NUM_RA);
        
        count=0;
        IND=zeros(1,100);
        for i=1:NUM_PRE
            INDEX1=find(ALLO_CHANNEL==i)
            if length(INDEX1)==1
                NUM_SUCCESS=NUM_SUCCESS+1;
                WAITTIME_LIST=WAITTIME(INDEX(INDEX1));
                count=count+1;
                IND(count)=INDEX(INDEX1);
%                 WINDOW(INDEX(INDEX1))=THRE_L;
            else
                for ll=1:length(INDEX1)
                if TIMES_RETRANS(INDEX(INDEX1(ll)))==MAX_RETRANS
                    NUM_DROP=NUM_DROP+1;
                count=count+1;
                IND(count)=INDEX(INDEX1);
                else  WINDOW(INDEX(INDEX1))=min(2*WINDOW(INDEX(INDEX1)),THRE_H);
                end
                end
            end
        end
        IND=sort(IND,'descend');
        for j=1:count
        WAITTIME(IND(j))=[];
        end        
        WAITTIME=WAITTIME+1;        
    end
    
ave_waittime(round)=(sum(WAITTIME)+sum(WAITTIME_LIST))/(NUM_SUCCESS+length(WAITTIME));
throughput(round)=NUM_SUCCESS/NUM_SLOT;
end




