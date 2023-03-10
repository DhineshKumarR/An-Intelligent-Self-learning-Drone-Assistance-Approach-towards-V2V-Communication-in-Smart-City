% clc;
% clear all;
% close all;

A=readfis('fuzzyref.fis');
figure,
plotfis(A)

figure,
plotmf(A,'input',1)

figure,
plotmf(A,'input',2)

figure,
plotmf(A,'input',3)

figure,
plotmf(A,'output',1)

%% Design NeuroFuzzy

x=[X' Y' vel' E'];
% x=rand(100,3);
% y=evalfis(x,A);
L2=L1;
L2(L2==1)=0.5;
L2(L2==2)=1;
L2(L2==3)=1;
L2(L2==4)=1;
L2(L2==5)=1;
L2(L2==6)=1;
L2(L2==7)=1;
L2(L2==8)=1;
L2(~(L2==1 | L2==0.5))=0;


%y=rand(100,1);
in_fis  = genfis1([x L2'],3,'gbellmf');
[outFIS,ERROR]  = anfis([x L2'],in_fis,40);
%%
figure,
plot(x,L2,'b*',x,evalfis(x,outFIS),'r*')
legend('Training Data','ANFIS Output')

figure,
plotfis(outFIS)

%save('DataAnfis.mat','outFIS');
%%
writefis(outFIS,'DataAnfis.fis')

