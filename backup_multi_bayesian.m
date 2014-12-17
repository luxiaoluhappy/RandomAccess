NUM_SLOT=1000;
NUM_PRE=64;

for round=1:45
    lambda=NUM_PRE*0.01*round;
    NEW_ARR=poissrnd(lambda,1,NUM_SLOT);
    USERS=0;    
    NUM_SUCCESS=0;
    COLLISION=0;
    HOLE=0;
    v=NUM_PRE;
    lambda_est=0.5;
 
    for slot=1:NUM_SLOT
        
   if NEW_ARR(slot)>0 
    WAITTIME(USERS+1:USERS+NEW_ARR(slot))=0;
    USERS=USERS+NEW_ARR(slot);
   end
    %根据当前时隙用户数，计算最佳接入概率
    if v==0 
        P_RA=1;
    else
        P_RA=min(NUM_PRE/v,1);
    end
    
    %在总的用户数为0的情况下
    if USERS==0    
        v=max(v-1,0);
        lambda_est=0.995*lambda_est;
    else     
    %总的用户数不为0时   
    %以概率P_RA发起接入
    tmp=randsrc(1,USERS,[0 1;1-P_RA P_RA]);    
    %发起接入的用户
    INDEX=find(tmp==1);
    NUM_RA=length(INDEX);
    %给每个用户分配信道
    ALLO_CHANNEL=randi([1,NUM_PRE],1,NUM_RA);
    count=0;
    IND=zeros(1,1000);
     for i=1:NUM_PRE
        INDEX1=find(ALLO_CHANNEL==i);
        %对于接入成功的用户，取出其等待时间；成功数加1；删除其等待时间
        if length(INDEX1)==1    
            NUM_SUCCESS=NUM_SUCCESS+1;
            USERS=USERS-1; 
            WAITTIME_LIST(NUM_SUCCESS)=WAITTIME(INDEX(INDEX1));
             count=count+1;   
             IND(count)=INDEX(INDEX1);  
        elseif length(INDEX1)>1
            COLLISION=COLLISION+1;
        else
            HOLE=HOLE+1;
        end
     end
    
    INDEX2=find(ALLO_CHANNEL==1);   
    %发生碰撞
    if length(INDEX2)>1
        if v>=1
        v=v+1.39221;
        else v=2.39221;
        end
        lambda_est=0.995*lambda_est;
    %接入成功
    elseif length(INDEX2)==1    
        v=max(v-1,0);
        lambda_est=0.995*lambda_est+0.005;
    %信道空余
    else 
      
        v=max(v-1,0);
        lambda_est=0.995*lambda_est;
    end
    
    IND=sort(IND,'descend');
    for j=1:count
    WAITTIME(IND(j))=[];
    end
    WAITTIME=WAITTIME+1; 
    end
    v=v+lambda_est*NUM_PRE;
    %每个时隙结束后，等待时间要+1
    end
   ave_waittime(round)=(sum(WAITTIME)+sum(WAITTIME_LIST))/(NUM_SUCCESS+length(WAITTIME));
   throughput(round)=NUM_SUCCESS/NUM_SLOT;
end

x=0.64:0.64:0.64*45;
subplot(1,2,1);
plot(x,ave_waittime);
title('delay vs lambda');
xlabel('lambda');
ylabel('delay');
subplot(1,2,2);
plot(x,throughput);
title('throughput vs lambda');
xlabel('lambda');
ylabel('throughput');


