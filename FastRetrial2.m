NUM_PRE=64;
NUM_SLOT=1000;
ARR_RATE=;
NEW_ARR=poissrnd(ARR_RATE,1,NUM_SLOT);
L=10;

Fsta=zeros(1,NUM_SLOT);
alpha = zeros(1,NUM_SLOT);

SUC_ACCESS=zeros(1,NUM_SLOT);
UNUSED_CHANNEL = zeros(1,NUM_SLOT);
NO_COLLISION = zeros(1,NUM_SLOT);
P_SUC_ACCESS = zeros(1,NUM_SLOT);
P_UNUSED_CHANNEL = zeros(1,NUM_SLOT);
P_NO_COLLISION = zeros(1,NUM_SLOT);

NUM_SUCCESS=0;
USERS=0;

for slot=1:NUM_SLOT
    
     WAITTIME(USERS+1:USERS+NEW_ARR(slot))=0;
     USERS=USERS+NEW_ARR(slot);
     
    %如何判定当前时隙是否为稳定状态，根据第k-1到k-L个时隙pnc与最佳吞吐量对应pnc的关系来判定
    S_MaxThp=1/log(N/(N-1));
    pnc_expect =(1+S_MaxThp/(N-1))/2.72;
    ave_pnc=sum(NO_COLLISION(max(slot-L,1):slot-1))/NUM_PRE/L;
    
     if ave_pnc<pnc_expect
         Fsta(slot)=0;
     else
         Fsta(slot)=1;
     end
     
     %如何得到M
     pnc=NO_COLLISION(slot)/NUM_PRE;
     S = pnc_func(pnc);
     M(slot)=S-NO_COLLISION(slot);
     
     %如何得到lambda 
     if Fsta(slot-1)==1
         lianxu = lianxu01(Fsta,slot-1,1);
         len = min(lianxu, L);
         lamba = sum(SUC_ACCESS(slot-len:slot-1))/len;
     else
         lianxu = lianxu01(Fsta,slot-1,0);
         len=min(L,lianxu);
         ave_puu=sum(UNUSED_CHANNEL(slot-len:slot-1))/len;
         ave_M=sum(M(slot-len:slot-1))/len;
         ave_alpha=sum(alpha(slot-len:slot-1))/len;
         
         lamda(slot)=-NUM_PRE*log(ave_puu*(N/(N-1)^ave_M))/ave_alpha;
     end
   
     
     %得到combined arrival rate
     if Fsta(slot)==1
     combined_lambda=combined_lambda*(1-alpha(slot-1))+lambda;
     else
     combined_lambda=lambda;     
     end
     
     alpha(slot)=max(0,min((NUM_PRE-M-1)*N/(N-1)/combined_lambda,1));
     
    tmp=randsrc(1,USERS,[0 1;1-alpha(slot) alpha(slot)]);
    ll=length(tmp);
    %找到那些需要发起随机接入的用户的序列号
    INDEX=find(tmp==1);
     %统计共有多少个发起随即介入过程的用户：NUM_RA
    NUM_RA=length(INDEX);
    %给每一个发起随机接入的用户分配前导
    ALLO_CHANNEL=zeros(1,NUM_RA);
    ALLO_CHANNEL=randi([1,NUM_PRE],1,NUM_RA);
    %统计每个前导被占用情况
    count=0;
    IND=zeros(1,100);
    for i=1:NUM_PRE
        INDEX1=find(ALLO_CHANNEL==i);
        if length(INDEX1)==1
            NUM_SUCCESS=NUM_SUCCESS+1;
            USERS=USERS-1;
            WAITTIME_LIST(NUM_SUCCESS)=WAITTIME(INDEX(INDEX1));
            %清空该用户的相关信息   
            count=count+1;   
            IND(count)=INDEX(INDEX1);
            
        elseif length(INDEX1)>1
            NUM_COLLISION=NUM_COLLISION+1;
            
        else NUM_UNUSED=NUM_UNUSED+1;
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
