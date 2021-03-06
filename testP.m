
 NUM_PRE=64;
 NUM_SLOT=1000; 
% for round=1:10
   % ARR_RATE=2*round; 
   ARR_RATE=2;
    NEW_ARR=poissrnd(ARR_RATE,1,NUM_SLOT);
    NUM_SUCCESS=0;
    TOTAL_USERS=0;
    USERS=0;
%     WAITTIME=zeros(1,20000);
% 
%     WAITTIME_LIST=zeros(1,20000);
for slot=1:NUM_SLOT
    %每个时隙，统计用户数和总的用户数

    WAITTIME(USERS+1:USERS+NEW_ARR(slot))=0;
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
           
           % WAITTIME(INDEX(INDEX1))=[];
        end
    end
    
    IND=sort(IND,'descend');
    for j=1:count
       WAITTIME(IND(j))=[];
    end
    
    WAITTIME=WAITTIME+1; 
end
% ave_waittime(round)=(sum(WAITTIME)+sum(WAITTIME_LIST))/(NUM_SUCCESS+length(WAITTIME));
% throughput(round)=NUM_SUCCESS/NUM_SLOT;

ave_waittime=(sum(WAITTIME)+sum(WAITTIME_LIST))/(NUM_SUCCESS+length(WAITTIME));
throughput=NUM_SUCCESS/NUM_SLOT;
% end

% x=2:2:20;
% subplot(1,2,1);
% plot(x,ave_waittime);
% title('平均等待时间随到达率变化图');
% xlabel('到达率');
% ylabel('平均等待时间');
% 
% subplot(1,2,2);
% plot(x,throughput);
% title('吞吐率随到达率变化图');
% xlabel('到达率');
% ylabel('吞吐率');
% 

