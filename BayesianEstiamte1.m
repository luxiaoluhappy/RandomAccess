function [ave_waittime,throughput] = BayesianEstiamte1(  )
NUM_SLOT=10000;

for round=1:20
    lambda=0.02*round;
    NEW_ARR=poissrnd(lambda,1,NUM_SLOT);
    USERS=0; 
    NUM_SUCCESS=0;
    v=0;
    lambda_est=0.5;
    
    for slot=1:NUM_SLOT 
 
   if NEW_ARR(slot)>0 
    WAITTIME(USERS+1:USERS+NEW_ARR(slot))=0;
    USERS=USERS+NEW_ARR(slot);
   end
    if v==0 
        P_RA=1;
    else
        P_RA=min(1/v,1);
    end
    
    %在总的用户数为0的情况下
    if USERS==0
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
        v=max(v-1,0);
        lambda_est=0.995*lambda_est+0.005;
        USERS=USERS-1;
        NUM_SUCCESS=NUM_SUCCESS+1;
        WAITTIME_LIST(NUM_SUCCESS)=WAITTIME(INDEX);
        WAITTIME(INDEX)=[];
    %信道空余
    else 
        v=max(v-1,0);
        lambda_est=0.995*lambda_est;
    end
    WAITTIME=WAITTIME+1;
    end
    v=v+lambda_est;
    
    end
  ave_waittime(round)=(sum(WAITTIME)+sum(WAITTIME_LIST))/(NUM_SUCCESS+length(WAITTIME));
   throughput(round)=NUM_SUCCESS/NUM_SLOT;
end

% x=0.01:0.01:0.45;
% subplot(1,2,1);
% plot(x,ave_waittime);
% title('delay vs lambda');
% xlabel('lambda');
% ylabel('delay');
% subplot(1,2,2);
% plot(x,throughput);
% title('throughput vs lambda');
% xlabel('lambda');
% ylabel('throughput');