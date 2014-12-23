% [ave_waittime1,throughput1]=UB(10);
% [ave_waittime2,throughput2]=UB(20);
% [ave_waittime3,throughput3]=UB(30);
% [ave_waittime4,throughput4]=UB(40);
[ave_waittime5,throughput5,drop_rate5]=UB(10);
[ave_waittime6,throughput6,drop_rate6]=UBplusBayesian;
[ave_waittime7,throughput7,drop_rate7]=DynamicWindowsandRACH;
[ave_waittime8,throughput8]=variableP_noDrop;


x=1:1:20;
figure(1);
%plot(x,ave_waittime1,'r',x,ave_waittime2,'g',x,ave_waittime3,'y',x,ave_waittime4,'k');
%plot(x,ave_waittime1,'r',x,ave_waittime3,'g',x,ave_waittime4,'k');
% plot(x,ave_waittime1,'r',x,ave_waittime2,'g',x,ave_waittime3,'b',x,ave_waittime4,'m',x,ave_waittime5,'y',x,ave_waittime6,'k',x,ave_waittime7,'c');
plot(x,ave_waittime5,'r',x,ave_waittime6,'g',x,ave_waittime7,'b',x,ave_waittime8,'k');
title('delay vs lambda');
xlabel('lambda');
ylabel('delay');
legend('UB(10)','DWA','DWA+SOOC','最优控制',2);

figure(2);
%plot(x,throughput1,'r',x,throughput2,'g',x,throughput3,'y',x,throughput4,'k');
%plot(x,ave_waittime1,'r',x,ave_waittime3,'g',x,ave_waittime4,'k');
% plot(x,throughput1,'r',x,throughput2,'g',x,throughput3,'b',x,throughput4,'m',x,throughput5,'y',x,throughput6,'k',x,throughput7,'c');
plot(x,throughput5,'r',x,throughput6,'g',x,throughput7,'b',x,throughput8,'k');
title('throughput vs lambda');
xlabel('lambda');
ylabel('throughput');
legend('UB(10)','DWA','DWA+SOOC','最优控制',2);

figure(3);
%plot(x,throughput1,'r',x,throughput2,'g',x,throughput3,'y',x,throughput4,'k');
%plot(x,ave_waittime1,'r',x,ave_waittime3,'g',x,ave_waittime4,'k');
% plot(x,throughput1,'r',x,throughput2,'g',x,throughput3,'b',x,throughput4,'m',x,throughput5,'y',x,throughput6,'k',x,throughput7,'c');
plot(x,drop_rate5,'r',x,drop_rate6,'g',x,drop_rate7,'b');
title('drop_rate vs lambda');
xlabel('lambda');
ylabel('drop_rate');
legend('UB(10)','DWA','DWA+SOOC',2);
