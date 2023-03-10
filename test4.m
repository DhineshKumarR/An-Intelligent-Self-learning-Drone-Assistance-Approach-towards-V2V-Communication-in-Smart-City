clc;
clear all;
close all;
warning off all;

restoredefaultpath;
addpath(genpath(pwd));
global N X Y Xb Yb E zX zY max1


rand('seed',1)
N=60;% Total No. of Nodes
RSU=[];%[250];
min1=0;
max11=400;
max1=200;

X = min1+(max11-min1)*rand(1,N);
Y = min1+(max1-min1)*rand(1,N);
R=100; %sensor field Radius
%co-ordinates of base station

%% Normalized vehicle velocity 
maxv=50;
minv=10;
vel=rand(1,N);

%% Node Buffersize
E=rand(1,N);%1.*ones(1,N); % intialize node Buffersize
minTh=E/2;     %% minTh for buffer
%%
figure,
for i2 = 1:N 
          plot(X(i2),Y(i2),'o','LineWidth',1,...
                    'MarkerEdgeColor','k',...
                    'MarkerFaceColor','b',...
                    'MarkerSize',8'); 
          xlabel('X in m')
          ylabel('Y in m')
          text(X(i2), Y(i2), num2str(i2),'FontSize',10); 
          hold on;
end
hold on

        Xb = 340;
        Yb = 160;
         plot(Xb,Yb,'s','LineWidth',1,...
                    'MarkerEdgeColor','k',...
                    'MarkerFaceColor','y',...
                    'MarkerSize',12'); 
          xlabel('X in m')
          ylabel('Y in m')
          text(Xb, Yb, 'RSU','FontSize',15); 
          hold on;
hold on
        Xb = [100,100,340];
        Yb = [160,50,50];
for j = 1:3
         plot(Xb(j),Yb(j),'s','LineWidth',1,...
                    'MarkerEdgeColor','k',...
                    'MarkerFaceColor','g',...
                    'MarkerSize',12'); 
          xlabel('X in m')
          ylabel('Y in m')
          text(Xb(j), Yb(j), 'DRSU','FontSize',15); 
          hold on;
end
%% Equal-zone division
zX=0:100:max11;
zY=0:100:max1;
id=zeros(1,N);
%ipd=1;
ik1=1;
for ik=1:numel(zX)-1
    for ij=1:numel(zY)-1
    rectangle('Position',[zX(ik) zY(ij) 100 100])
    points =[zX(ik) zY(ij); zX(ik)+100 zY(ij);  zX(ik)+100 zY(ij)+100 ;zX(ik) zY(ij)+100 ;zX(ik) zY(ij)]
    
    line(1:400,100.*ones(1,400),'Color','r','LineWidth',4)
    
    if(~isempty(RSU))
        
        plot(RSU(1),100,'^','LineWidth',1,...
                    'MarkerEdgeColor','k',...
                    'MarkerFaceColor','g',...
                    'MarkerSize',11'); 
          xlabel('X in m')
          ylabel('Y in m')
          %text(Xb, Yb, 'Base','FontSize',10); 
          hold on;
    end
    
    %figure(2)
    %plot(points(:,1),points(:,2),'-*r')
    [in,on]=inpolygon(X,Y,points(:,1),points(:,2))
    
    ind=find(in==1);
     
     if(~isempty(RSU))
         if(RSU(1)>zX(ik) && RSU(1)<zX(ik+1))
         ind=[];
         end
     else
         
    
%      %% Max Buffersize CHM
%     Ec=E(ind);      
%     SN1=ind;
%     SN(ik1).id=ind;
%     L=0.*ind;%label
%         
%     [val1,ind2]=sort(Ec,'descend');
%     MonitorID(ik1)=ind(ind2(1));
%        
%     ipd0=find(ind==ind(ind2(1)));
%     L(ipd0)=1; %CHM
%     plot(X(MonitorID(ik1)),Y(MonitorID(ik1)),'o','LineWidth',1,...
%                     'MarkerEdgeColor','k',...
%                     'MarkerFaceColor','g',...
%                     'MarkerSize',10'); 
%           xlabel('X in m')
%           ylabel('Y in m')
%           %text(Xb, Yb, 'Base','FontSize',10); 
%           hold on;
     end
    end
end