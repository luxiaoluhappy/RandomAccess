NUM_SLOT=25000;

backlog=zeros(1,37);
no_backlog=zeros(1,37);
last_no_backlog=zeros(1,37);
for round=1:37
    lambda=0.01*round;
    NEW_ARR=poissrnd(lambda,1,NUM_SLOT);
    USERS=0;
    
    v=0;
    lambda_est=0.5;
    
    for slot=1:NUM_SLOT
    
    if v==0 
        P_RA=1;
    else
        P_RA=min(1/v,1);
    end
    
    USERS=USERS+NEW_ARR(slot);
    backlog(round)=backlog(round)+USERS;
    
    %在总的用户数为0的情况下
    if USERS==0
        no_backlog(round)=no_backlog(round)+1;
        last_no_backlog(round)=slot;
        v=max(v-1,0);
        lambda_est=0.995*lambda_est;
    else     
        
    tmp=randsrc(1,USERS,[0 1;1-P_RA P_RA]);    
    INDEX=find(tmp==1);
    
    %发生碰撞
    if length(INDEX)>1
        if v>=1
        v=v+1.39221;
        else v=2.39221;
        end
        lambda_est=0.995*lambda_est;
%         backlog(round)=backlog(round)+length(INDEX);
    %接入成功
    elseif length(INDEX)==1
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
    v=v+lambda_est;
    end
    backlog(round)=backlog(round)/NUM_SLOT;
%     no_backlog(round)=no_backlog(round)/NUM_SLOT;
end