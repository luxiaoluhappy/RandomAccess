 % function [ave_waittime,throughput] = MultiBayesianCheck(  ) 
NUM_SLOT=1000;
NUM_PRE=64;
% 
% for round=1:32
    lambda=24;
   % lambda=2*round;
    NEW_ARR=poissrnd(lambda,1,NUM_SLOT);
    USERS=zeros(1,NUM_SLOT+1);
    USERS(1)=0;    
    
    NUM_SUCCESS=0;
    v=zeros(1,NUM_SLOT+1);
    v(1)=0;
    
    COLLISION=zeros(1,NUM_SLOT);
    SUCCESS=zeros(1,NUM_SLOT);
    for slot=1:NUM_SLOT
    HOLE=0;
   if NEW_ARR(slot)>0 
    WAITTIME(USERS(slot)+1:USERS(slot)+NEW_ARR(slot))=0;
    USERS(slot)=USERS(slot)+NEW_ARR(slot);
   end
    %���ݵ�ǰʱ϶�û�����������ѽ������
    if v(slot)==0 
        P_RA=1;
    else
        P_RA=min(NUM_PRE/v(slot),1);
    end
    
    %���ܵ��û���Ϊ0�������
   
    if USERS(slot)==0    
        COLLISION(slot)=0;
        SUCCESS(slot)=0;
%         ave_COLLISION=sum(COLLISION(max(1,slot-99):slot))/min(slot,100);
%         v(slot+1)=max(v(slot)-NUM_PRE,0);
%         lambda_est=ave_COLLISION/2.718;            
%         v(slot+1)=max(v(slot+1)+lambda_est,NUM_PRE);
     lambda_est=SUCCESS(slot);
     v(slot+1)=max(0,v(slot)+COLLISION(slot)/0.718-(NUM_PRE-COLLISION(slot)))+lambda_est;
    else     
    %�ܵ��û�����Ϊ0ʱ   
    %�Ը���P_RA�������
    tmp=randsrc(1,USERS(slot),[0 1;1-P_RA P_RA]);    
    %���������û�
    INDEX=find(tmp==1);
    NUM_RA=length(INDEX);
    %��ÿ���û������ŵ�
    ALLO_CHANNEL=randi([1,NUM_PRE],1,NUM_RA);
    count=0;
    IND=zeros(1,1000);
    USERS(slot+1)=USERS(slot);
     for i=1:NUM_PRE
        INDEX1=find(ALLO_CHANNEL==i);
        %���ڽ���ɹ����û���ȡ����ȴ�ʱ�䣻�ɹ�����1��ɾ����ȴ�ʱ��
        if length(INDEX1)==1    
            NUM_SUCCESS=NUM_SUCCESS+1;
            SUCCESS(slot)=SUCCESS(slot)+1;
            USERS(slot+1)=USERS(slot+1)-1; 
            WAITTIME_LIST(NUM_SUCCESS)=WAITTIME(INDEX(INDEX1));
             count=count+1;   
             IND(count)=INDEX(INDEX1);  
        elseif length(INDEX1)>1
            COLLISION(slot)=COLLISION(slot)+1;
        else
            HOLE=HOLE+1;
        end
     end
%      if COLLISION(slot)==0
%          lambda_est=NUM_PRE/2.718;
%      else lambda_est=0.9*lambda_est+0.1*SUCCESS;
%      end
%  ave_COLLISION=sum(COLLISION(max(1,slot-99):slot))/min(slot,100);
      lambda_est=SUCCESS(slot);
     v(slot+1)=max(0,v(slot)+COLLISION(slot)/0.718-(NUM_PRE-COLLISION(slot)))+lambda_est;
% ave_COLLISION=sum(COLLISION(max(1,slot-9):slot))/min(slot,10);
% lambda_est=ave_COLLISION/2.718;
% v(slot+1)=v(slot)+ave_COLLISION/0.718-(NUM_PRE-ave_COLLISION);
% v(slot+1)=max(v(slot+1)+lambda_est,NUM_PRE);

    IND=sort(IND,'descend');
    for j=1:count
    WAITTIME(IND(j))=[];
    end
    WAITTIME=WAITTIME+1; 
    end
    %ÿ��ʱ϶�����󣬵ȴ�ʱ��Ҫ+1
    end
x=1:NUM_SLOT+1;
plot(x,v,'r',x,USERS,'g');
xlabel('ʱ϶');
ylabel('�û�������');
%    ave_waittime(round)=(sum(WAITTIME)+sum(WAITTIME_LIST))/(NUM_SUCCESS+length(WAITTIME));
%    throughput(round)=NUM_SUCCESS/NUM_SLOT;
% end





