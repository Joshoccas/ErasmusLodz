clear;
R=[0,90];
net = newff(R,[2 1],{'logsig' 'logsig'},'trainlm','','mse');
%net = newff(R,[2 1],{'logsig' 'logsig'},'traingd','','mse');
init(net);

fid=fopen('P_tank.txt');
n=91;
P=fscanf(fid,'%g',[1 n]);
fid=fopen('T_tank.txt');
T=fscanf(fid,'%g',[1 n]);

Y1=sim(net,P);
e1=mean(abs(T-Y1));

net.trainParam.epochs = 10000;   % liczba epok uczacych
net.trainParam.show = 500;       % wyniki prezentowane na wykresie co ile epok
net.trainParam.goal = 1e-10;     % blad uczenia ponizej którego przerywa sie proces
net.trainParam.min_grad = 1e-20; % minimalny gradient
net=train(net,P,T);
grid;

%sprawdzenie
Y=sim(net,P);
er=mean(abs(T-Y));
e=mean(er);

plot(P,Y1,P,Y,P,T)
title('Ballistic curve for initial velocity 30')
xlabel('distance')
ylabel('shooting angle')
legend('output from the network before the learning procedure','output from the network after the learning procedure','targets')