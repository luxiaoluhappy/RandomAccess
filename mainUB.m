% [ave_waittime1,throughput1]=UB(10);
% [ave_waittime2,throughput2]=UB(20);
% [ave_waittime3,throughput3]=UB(30);
% [ave_waittime4,throughput4]=UB(40);
[ave_waittime5,throughput5,drop_rate5]=UB(20);
[ave_waittime6,throughput6,drop_rate6]=BEB;
[ave_waittime7,throughput7]=variableP_noDrop;
[ave_waittime8,throughput8,drop_rate8]=UBplusBayesian;


x=1:30;
subplot(2,2,1);
%plot(x,ave_waittime1,'r',x,ave_waittime2,'g',x,ave_waittime3,'y',x,ave_waittime4,'k');
%plot(x,ave_waittime1,'r',x,ave_waittime3,'g',x,ave_waittime4,'k');
% plot(x,ave_waittime1,'r',x,ave_waittime2,'g',x,ave_waittime3,'b',x,ave_waittime4,'m',x,ave_waittime5,'y',x,ave_waittime6,'k',x,ave_waittime7,'c');
plot(x,ave_waittime5,'r',x,ave_waittime6,'g',x,ave_waittime7,'k',x,ave_waittime8,'b');
title('delay vs lambda');
xlabel('lambda');
ylabel('delay');
legend('U=64','BEB','最优','DWA',2);

subplot(2,2,2);
%plot(x,throughput1,'r',x,throughput2,'g',x,throughput3,'y',x,throughput4,'k');
%plot(x,ave_waittime1,'r',x,ave_waittime3,'g',x,ave_waittime4,'k');
% plot(x,throughput1,'r',x,throughput2,'g',x,throughput3,'b',x,throughput4,'m',x,throughput5,'y',x,throughput6,'k',x,throughput7,'c');
plot(x,throughput5,'r',x,throughput6,'g',x,throughput7,'k',x,throughput8,'b');
title('throughput vs lambda');
xlabel('lambda');
ylabel('throughput');
legend('U=64','BEB','最优','DWA',1);

subplot(2,2,3);
%plot(x,throughput1,'r',x,throughput2,'g',x,throughput3,'y',x,throughput4,'k');
%plot(x,ave_waittime1,'r',x,ave_waittime3,'g',x,ave_waittime4,'k');
% plot(x,throughput1,'r',x,throughput2,'g',x,throughput3,'b',x,throughput4,'m',x,throughput5,'y',x,throughput6,'k',x,throughput7,'c');
plot(x,drop_rate5,'r',x,drop_rate6,'g',x,drop_rate8,'b');
title('drop_rate vs lambda');
xlabel('lambda');
ylabel('drop_rate');
legend('U=64','BEB','DWA',1);
