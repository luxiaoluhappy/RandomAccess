function [ave_waittime,throughput,drop_rate] = ZWF_RA_test( WINDOW_SIZE,MAX_RETRANS ) 
 NUM_PRE=64;
 NUM_SLOT=1000; 
% MAX_RETRANS=5;
%WINDOW_SIZE=8;
for round=1:30
    ARR_RATE=1*round; 
    NEW_ARR=poissrnd(ARR_RATE,1,NUM_SLOT);
    
    NUM_SUCCESS=0;
    NUM_DROP=0;
    TOTAL_USERS=0;
    USERS=0;
    
%     WAITTIME=zeros(1,20000);
%     WINDOW=THRE_L*ones(1,20000);
%     WAITTIME_LIST=zeros(1,20000);
%     TIME_RETRANS=zeros(1,20000);
%     BACKOFF_LEN=zeros(1,20000);
    
    for slot=1:NUM_SLOT       
        %�����ʱ϶��Ҫ�����������û�
        WAITTIME((USERS+1):(USERS+NEW_ARR(slot)))=0;
        BACKOFF_LEN((USERS+1):(USERS+NEW_ARR(slot)))=0;
%         WINDOW((USERS+1):(USERS+NEW_ARR(slot)))=THRE_L;
        TIME_RETRANS((USERS+1):(USERS+NEW_ARR(slot)))=0;
        COUNTER((USERS+1):(USERS+NEW_ARR(slot)))=0;
        
        USERS=USERS+NEW_ARR(slot);
        
        ALLOWED=[];
        num=0;
        for n=1:USERS
            if BACKOFF_LEN(n)==COUNTER(n)
                num=num+1; 
                ALLOWED(num)=n;
            end
        end               
        
        P_RA=min(NUM_PRE/num,1);
        tmp=randsrc(1,num,[0 1;1-P_RA P_RA]);
        INDEX=find(tmp==1);
        NUM_RA=length(INDEX);
        INDEXX=find(tmp==0);
        COUNTER(ALLOWED(INDEXX))=COUNTER(ALLOWED(INDEXX))-1;
        ALLO_CHANNEL=zeros(1,NUM_RA);
        ALLO_CHANNEL=randi([1,NUM_PRE],1,NUM_RA);
        
        count=0;
        IND=zeros(1,100);
        for i=1:NUM_PRE
            INDEX1=find(ALLO_CHANNEL==i);
            %�ڽ���ɹ�������£�ȡ���ȴ�ʱ�䣬�û��������£��ɹ���������
            if length(INDEX1)==1
                NUM_SUCCESS=NUM_SUCCESS+1;
                USERS=USERS-1;
                WAITTIME_LIST(NUM_SUCCESS+NUM_DROP)=WAITTIME(ALLOWED(INDEX(INDEX1)));
                count=count+1;
                IND(count)=ALLOWED(INDEX(INDEX1));
%                 WINDOW(INDEX(INDEX1))=THRE_L;
            else
                %�ڽ���ʧ�ܵ�����£�������ͻ��
                if length(INDEX1)>1
                    for j=1:length(INDEX1)
                        %����ﵽ��ߴ������������
                        if TIME_RETRANS(ALLOWED(INDEX(INDEX1(j))))==MAX_RETRANS
                            NUM_DROP=NUM_DROP+1;
                            USERS=USERS-1;
                            count=count+1;
                            WAITTIME_LIST(NUM_SUCCESS+NUM_DROP)=WAITTIME(ALLOWED(INDEX(INDEX1(j))));
                            IND(count)=ALLOWED(INDEX(INDEX1(j)));
                            
                            %���û�дﵽ��ߴ��������������������ѡ���˱�ʱ϶ֵ������¼�ش�����
                        else
%                             WINDOW(ALLOWED(INDEX(j)))=min(2*WINDOW(ALLOWED(INDEX(j))),THRE_H);                    
                            BACKOFF_LEN(ALLOWED(INDEX(INDEX1(j))))=randi([1,WINDOW_SIZE],1);
%                             TIME_RETRANS(ALLOWED(INDEX(j)))=TIME_RETRANS(ALLOWED(INDEX(j)))+1;
                            TIME_RETRANS(ALLOWED(INDEX(INDEX1(j))))=TIME_RETRANS(ALLOWED(INDEX(INDEX1(j))))+1;
                            COUNTER(ALLOWED(INDEX(INDEX1)))=0;
                            
                        end
                     end
                end
            end
        end
        IND=sort(IND,'descend');
        
        for k=1:count
        WAITTIME(IND(k))=[];
%         WINDOW(IND(k))=[];
        BACKOFF_LEN(IND(k))=[];
        TIME_RETRANS(IND(k))=[];
        COUNTER(IND(k))=[];
        end        
        
        WAITTIME(1:USERS)=WAITTIME(1:USERS)+1;   
        COUNTER(1:USERS)=COUNTER(1:USERS)+1;
        
    end

ave_waittime(round)=(sum(WAITTIME)+sum(WAITTIME_LIST))/(NUM_SUCCESS+USERS+NUM_DROP);
throughput(round)=NUM_SUCCESS/NUM_SLOT;
drop_rate(round)=NUM_DROP/NUM_SLOT;

% ave_waittime=(sum(WAITTIME)+sum(WAITTIME_LIST))/(NUM_SUCCESS+USERS+NUM_DROP);
% throughput=NUM_SUCCESS/NUM_SLOT;
end
% x=1:30;
% subplot(2,2,1);
% plot(x,ave_waittime);
% title('ƽ���ȴ�ʱ���浽���ʱ仯ͼ');
% xlabel('������');
% ylabel('ƽ���ȴ�ʱ��');
% 
% subplot(2,2,2);
% plot(x,throughput);
% title('�������浽���ʱ仯ͼ');
% xlabel('������');
% ylabel('������');
% 
% subplot(2,2,3);
% plot(x,drop_rate);
% title('�������浽���ʱ仯ͼ');
% xlabel('������');
% ylabel('������');

