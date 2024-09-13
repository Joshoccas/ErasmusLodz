clear;
R=[0,1;0,1];
net = newff(R,[2 1],{'logsig' 'logsig'},'trainlm','','mse');
init(net);

fid=fopen('P.txt');
n=4;
P=fscanf(fid,'%g',[2 n]);
fid=fopen('T.txt');
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