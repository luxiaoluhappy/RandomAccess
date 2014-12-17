NUM_SLOT=10000;
NUM_PRE=64;
total=zeros(1,37);
no_backlog=zeros(1,37);

for round=1:37
    lambda=NUM_PRE*0.01*round;
    NEW_ARR=poissrnd(lambda,1,NUM_SLOT);
    USERS=0;    
    v=0;
    lambda_est=0.5;
    
    for slot=1:NUM_SLOT
    
    if v==0 
        P_RA=1;
    else
        P_RA=min(NUM_PRE/v,1);
    end
    
    USERS=USERS+NEW_ARR(slot);
    total(round)=total(round)+USERS;
    
    %在总的用户数为0的情况下
    if USERS==0
        no_backlog(round)=no_backlog(round)+64;
        v=max(v-1,0);
        lambda_est=0.995*lambda_est;
    else     
        
    tmp=randsrc(1,USERS,[0 1;1-P_RA P_RA]);    
    INDEX=find(tmp==1);
    NUM_RA=length(INDEX);
    ALLO_CHANNEL=randi([1,NUM_PRE],1,NUM_RA);
     for i=1:NUM_PRE
        INDEX1=find(ALLO_CHANNEL==i);
        if length(INDEX1)==1        
            USERS=USERS-1;           
%             count=count+1;   
%             IND(count)=INDEX(INDEX1);       
        end
    end
    
    INDEX1=find(ALLO_CHANNEL==1);
    
    %发生碰撞
    if length(INDEX1)>1
        if v>=1
        v=v+1.39221;
        else v=2.39221;
        end
        lambda_est=0.995*lambda_est;
    %接入成功
    elseif length(INDEX1)==1
        last_no_backlog(round)=slot;
        no_backlog(round)=no_backlog(round)+1;
        v=max(v-1,0);
        lambda_est=0.995*lambda_est+0.005;
        USERS=USERS-1;
    %信道空余
    else 
        last_no_backlog(round)=slot;
        no_backlog(round)=no_backlog(round)+1;
        v=max(v-1,0);
        lambda_est=0.995*lambda_est;
    end
    
    end
    v=v+lambda_est*64;
    end
    total(round)=total(round)/NUM_SLOT;
    no_backlog(round)=no_backlog(round)/NUM_SLOT;
end