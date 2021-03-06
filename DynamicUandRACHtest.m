% function [ave_waittime,throughput,drop_rate] = DynamicWindowsandRACH(  ) 

 NUM_SLOT=1000; 
 %WINDOW_SIZE=8;
 MAX_RETRANS=5;
 
% for round=1:20
    round=50;
    NUM_PRE=ones(1,NUM_SLOT+1);
    NUM_PRE(1)=64;
    NUM_PR=128;
    ARR_RATE=round; 
    NEW_ARR=poissrnd(ARR_RATE,1,NUM_SLOT);
    
    NUM_SUCCESS=0;
    NUM_DROP=0;
    
    USERS=0;
    %每个时隙用户到达率的估计值
    lambda_est=zeros(1,NUM_SLOT+1);
    lambda_est(1)=0;
    %每个时隙用户数的估计值
    B=zeros(1,NUM_SLOT+1);
    B(1)=0;
    %每个时隙窗口设置值
    U=zeros(1,NUM_SLOT+1);
    U(1)=20;
    %每个时隙的资源大小
    L=ones(1,NUM_SLOT+1);
    L(1)=6400;
    %系统的目标冲突概率
    P_TARGET=0.6;
%     WAITTIME=zeros(1,20000);
%     WINDOW=THRE_L*ones(1,20000);
%     WAITTIME_LIST=zeros(1,20000);
%     TIME_RETRANS=zeros(1,20000);
%     BACKOFF_LEN=zeros(1,20000);
    P_COLLISION=zeros(1,NUM_SLOT+1);
    for slot=1:NUM_SLOT       
        
        SUCCESS=0;
        COLLISION=0;
        HOLE=0;
        
        
    UNSUCCESS_RA_COUNTER=0;
    TOTAL_RA_COUNTER=0;
    
        %在这个时隙需要发起接入的老用户
        WAITTIME((USERS+1):(USERS+NEW_ARR(slot)))=0;
        BACKOFF_LEN((USERS+1):(USERS+NEW_ARR(slot)))=0;
%         WINDOW((USERS+1):(USERS+NEW_ARR(slot)))=THRE_L;
        TIME_RETRANS((USERS+1):(USERS+NEW_ARR(slot)))=0;
        COUNTER((USERS+1):(USERS+NEW_ARR(slot)))=0;
        
        USERS=USERS+NEW_ARR(slot);
        
        ALLOWED=zeros(1,1000);
        num=0;
        for n=1:USERS
            if BACKOFF_LEN(n)==COUNTER(n)
                num=num+1; 
                ALLOWED(num)=n;
            end
        end               
        
        ALLO_CHANNEL=zeros(1,num);
%         ALLO_CHANNEL=randi([1,NUM_PRE(slot)],1,num);
        ALLO_CHANNEL=randi([1,NUM_PR],1,num);
        
        count=0;
        IND=zeros(1,100);
%         for i=1:NUM_PRE(slot)
for i=1:NUM_PR
            INDEX=find(ALLO_CHANNEL==i);
            %在接入成功的情况下，取出等待时间，用户个数更新，成功个数更新
            if length(INDEX)==1
                NUM_SUCCESS=NUM_SUCCESS+1;
                SUCCESS=SUCCESS+1;
                USERS=USERS-1;
                WAITTIME_LIST(NUM_SUCCESS+NUM_DROP)=WAITTIME(ALLOWED(INDEX));
                count=count+1;
                IND(count)=ALLOWED(INDEX);
                
                UNSUCCESS_RA_COUNTER=UNSUCCESS_RA_COUNTER+TIME_RETRANS(ALLOWED(INDEX));
                TOTAL_RA_COUNTER=TOTAL_RA_COUNTER+TIME_RETRANS(ALLOWED(INDEX))+1;
                
            elseif length(INDEX)>1
                 COLLISION=COLLISION+1;
                for j=1:length(INDEX)
                        %如果达到最高传输次数，则丢弃
                        if TIME_RETRANS(ALLOWED(INDEX(j)))==MAX_RETRANS
                            NUM_DROP=NUM_DROP+1;
                            USERS=USERS-1;
                            count=count+1;
                            WAITTIME_LIST(NUM_SUCCESS+NUM_DROP)=WAITTIME(ALLOWED(INDEX(j)));
                            IND(count)=ALLOWED(INDEX(j));
                            
                            %如果没有达到最高传输次数，窗口扩大，重新选择退避时隙值，并记录重传次数
                        else
%                             WINDOW(ALLOWED(INDEX(j)))=min(2*WINDOW(ALLOWED(INDEX(j))),THRE_H);                    
%                             BACKOFF_LEN(ALLOWED(INDEX(j)))=randi([1,WINDOW_SIZE],1);
                              BACKOFF_LEN(ALLOWED(INDEX(j)))=randi([1,U(slot)],1);
%                             TIME_RETRANS(ALLOWED(INDEX(j)))=TIME_RETRANS(ALLOWED(INDEX(j)))+1;
                            TIME_RETRANS(ALLOWED(INDEX(j)))=TIME_RETRANS(ALLOWED(INDEX(j)))+1;
                            COUNTER(ALLOWED(INDEX(j)))=0;
                            
                        end
                end
            else 
                HOLE=HOLE+1;
                    end
            
        end
        %根据这个slot的情况，动态调整物理资源
        P_COLLISION(slot)=UNSUCCESS_RA_COUNTER/TOTAL_RA_COUNTER;
         P_C=sum(P_COLLISION(max(1,slot-20):slot))/min(slot,20);
        if P_C<P_TARGET
            NUM_PR=NUM_PR;
        else
%               RA_ATTEMPTS(slot)=-log(1-P_COLLISION(slot))*L(slot);
%               L(slot+1)=min(-RA_ATTEMPTS(slot)/log(1-P_TARGET),12800);
%               NUM_PRE(slot+1)=max(ceil(L(slot+1)/100),64);
        P_COLLISION=zeros(1,NUM_SLOT+1);
        NUM_PR=2*NUM_PR;
        end
         %根据这个slot的情况，估计用户数并动态调整窗口大小     
        if HOLE+SUCCESS==0
%             lambda_est(slot+1)=NUM_PRE(slot)/2.718;
            lambda_est(slot+1)=NUM_PR/2.718;
        else
            lambda_est(slot+1)=0.9*lambda_est(slot)+0.1*SUCCESS;
        end
        B(slot+1)=max(0,B(slot)+COLLISION/0.718-(HOLE+SUCCESS))+lambda_est(slot+1);
%         U(slot+1)=ceil(0.2*U(slot)+0.8*B(slot+1)/NUM_PRE(slot));
        U(slot+1)=ceil(0.2*U(slot)+0.8*B(slot+1)/NUM_PR);
        %将这个slot中成功的用户提出列表
        IND=sort(IND,'descend');    
        for k=1:count
        WAITTIME(IND(k))=[];
%         WINDOW(IND(k))=[];
        BACKOFF_LEN(IND(k))=[];
        TIME_RETRANS(IND(k))=[];
        COUNTER(IND(k))=[];
        end        
        %余下用户的等待时间和计时器+1
        WAITTIME(1:USERS)=WAITTIME(1:USERS)+1;   
        COUNTER(1:USERS)=COUNTER(1:USERS)+1;
 
        end
        
% ave_waittime(round)=(sum(WAITTIME)+sum(WAITTIME_LIST))/(NUM_SUCCESS+USERS+NUM_DROP);
% throughput(round)=NUM_SUCCESS/NUM_SLOT;
% drop_rate(round)=NUM_DROP/NUM_SLOT;
ave_waittime=(sum(WAITTIME)+sum(WAITTIME_LIST))/(NUM_SUCCESS+USERS+NUM_DROP);
throughput=NUM_SUCCESS/NUM_SLOT;
drop_rate=NUM_DROP/NUM_SLOT;
% end
% x=1:20;
% subplot(2,2,1);
% plot(x,ave_waittime);
% title('平均等待时间随到达率变化图');
% xlabel('到达率');
% ylabel('平均等待时间');
% 
% subplot(2,2,2);
% plot(x,throughput);
% title('吞吐率随到达率变化图');
% xlabel('到达率');
% ylabel('吞吐率');
% 
% subplot(2,2,3);
% plot(x,drop_rate);
% title('丢包率随到达率变化图');
% xlabel('到达率');
% ylabel('丢包率');


