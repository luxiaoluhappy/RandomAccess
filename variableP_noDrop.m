function [ave_waittime,throughput] = variableP(  )
    NUM_PRE=64;
    NUM_SLOT=1000; 
for round=1:30
    ARR_RATE=1*round; 
    NEW_ARR=poissrnd(ARR_RATE,1,NUM_SLOT);
    NUM_SUCCESS=0;
    USERS=0;
%     WAITTIME=zeros(1,20000);
% 
%     WAITTIME_LIST=zeros(1,20000);
for slot=1:NUM_SLOT
    %ÿ��ʱ϶��ͳ���û������ܵ��û���

    WAITTIME(USERS+1:USERS+NEW_ARR(slot))=0;
    TIME_RETRANS(USERS+1:USERS+NEW_ARR(slot))=0;
    
    USERS=USERS+NEW_ARR(slot);
    %TOTAL_USERS=TOTAL_USERS+NEW_ARR(slot);
    %������ѽ������
    P_RA=min(NUM_PRE/USERS,1);
    %����ÿ���û�Ҫ��Ҫ��������������
    tmp=randsrc(1,USERS,[0 1;1-P_RA P_RA]);
    ll=length(tmp);
    %�ҵ���Щ��Ҫ�������������û������к�
    INDEX=find(tmp==1);
     %ͳ�ƹ��ж��ٸ������漴������̵��û���NUM_RA
    NUM_RA=length(INDEX);
    %��ÿһ���������������û�����ǰ��
    ALLO_CHANNEL=zeros(1,NUM_RA);
    ALLO_CHANNEL=randi([1,NUM_PRE],1,NUM_RA);
    %ͳ��ÿ��ǰ����ռ�����
    count=0;
    IND=zeros(1,100);
    for i=1:NUM_PRE
        INDEX1=find(ALLO_CHANNEL==i);
        if length(INDEX1)==1
            NUM_SUCCESS=NUM_SUCCESS+1;
            USERS=USERS-1;
            WAITTIME_LIST(NUM_SUCCESS)=WAITTIME(INDEX(INDEX1));
            %��ո��û��������Ϣ   
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
ave_waittime(round)=(sum(WAITTIME)+sum(WAITTIME_LIST))/(NUM_SUCCESS+length(WAITTIME));
throughput(round)=NUM_SUCCESS/NUM_SLOT;

end
% x=2:2:64;
% subplot(1,2,1);
% plot(x,ave_waittime);
% title('ƽ���ȴ�ʱ���浽���ʱ仯ͼ');
% xlabel('������');
% ylabel('ƽ���ȴ�ʱ��');
% 
% subplot(1,2,2);
% plot(x,throughput);
% title('�������浽���ʱ仯ͼ');
% xlabel('������');
% ylabel('������');


