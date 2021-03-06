function [ave_waittime,throughput] = variableP(  )
    NUM_PRE=64;
    NUM_SLOT=1000; 
    MAX_RETRANS=250;
for round=1:20
    ARR_RATE=1*round; 
    NEW_ARR=poissrnd(ARR_RATE,1,NUM_SLOT);
    NUM_SUCCESS=0;
    NUM_DROP=0;
    USERS=0;
%     WAITTIME=zeros(1,20000);
% 
%     WAITTIME_LIST=zeros(1,20000);
for slot=1:NUM_SLOT
    %每个时隙，统计用户数和总的用户数

    WAITTIME(USERS+1:USERS+NEW_ARR(slot))=0;
    TIME_RETRANS(USERS+1:USERS+NEW_ARR(slot))=0;
    
    USERS=USERS+NEW_ARR(slot);
    %TOTAL_USERS=TOTAL_USERS+NEW_ARR(slot);
    %计算最佳接入概率
    P_RA=min(NUM_PRE/USERS,1);
    %决定每个用户要不要发起接入随机接入
    tmp=randsrc(1,USERS,[0 1;1-P_RA P_RA]);
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
            for k=1:length(INDEX1)
                if TIME_RETRANS(INDEX(INDEX1(k)))==MAX_RETRANS
                    NUM_DROP=NUM_DROP+1;
                    USERS=USERS-1;
                    
                    WAITTIME_LIST(NUM_SUCCESS)=WAITTIME(INDEX(INDEX1));
                    count=count+1;
                    IND(count)=INDEX(INDEX1(k));
            end
           
           % WAITTIME(INDEX(INDEX1))=[];
        end
    end
    
    IND=sort(IND,'descend');
    for j=1:count
       WAITTIME(IND(j))=[];
    end
    
    WAITTIME=WAITTIME+1;
    TIME_RETRANS=TIME_RETRANS+1;
end
ave_waittime(round)=(sum(WAITTIME)+sum(WAITTIME_LIST))/(NUM_SUCCESS+length(WAITTIME));
throughput(round)=NUM_SUCCESS/NUM_SLOT;
drop_rate(round)=NUM_DROP/NUM_SLOT;
end
end
x=0.05:0.05:1;
subplot(2,2,1);
plot(x,ave_waittime);
title('平均等待时间随到达率变化图');
xlabel('到达率');
ylabel('平均等待时间');

subplot(2,2,2);
plot(x,throughput);
title('吞吐率随到达率变化图');
xlabel('到达率');
ylabel('吞吐率');

subplot(2,2,3);
plot(x,drop_rate);
title('丢包率随到达率变化图');
xlabel('到达率');
ylabel('吞吐率');


