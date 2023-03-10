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
Xb = max11+2+rand(1,1);
Yb =(max1+2)+rand(1,1);
%% Normalized vehicle velocity 
maxv=100;
minv=0;
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
         plot(Xb,Yb,'s','LineWidth',1,...
                    'MarkerEdgeColor','k',...
                    'MarkerFaceColor','y',...
                    'MarkerSize',12'); 
          xlabel('X in m')
          ylabel('Y in m')
          text(Xb, Yb, 'Sink','FontSize',10); 
          hold on;
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
         
    
     %% Max Buffersize CHM
    Ec=E(ind);      
    SN1=ind;
    SN(ik1).id=ind;
    L=0.*ind;%label
        
    [val1,ind2]=sort(Ec,'descend');
    MonitorID(ik1)=ind(ind2(1));
       
    ipd0=find(ind==ind(ind2(1)));
    L(ipd0)=1; %CHM
    plot(X(MonitorID(ik1)),Y(MonitorID(ik1)),'o','LineWidth',1,...
                    'MarkerEdgeColor','k',...
                    'MarkerFaceColor','g',...
                    'MarkerSize',10'); 
          xlabel('X in m')
          ylabel('Y in m')
          %text(Xb, Yb, 'Base','FontSize',10); 
          hold on;
          
    %% Pch%
    chmtosinkdist=abs(X(MonitorID(ik1))-Xb); 
    pc=distpch(chmtosinkdist);
    s1=ceil((pc/100)*numel(ind))
    SN(ik1).s1=s1;   
    
    %% Adaptive Clustering
    pos1=[X(ind) Y(ind)];
    vel1=vel(ind);
    Bs=E(ind);
    posd=pdist2([X(ind); Y(ind)]',[zX(ik)+50 zY(ij)+50]);
   
    w1=0.6;
    w2=0.2;
    w3=0.2;
    W=w1.*posd+w2.*vel1'+w3.*Bs';
    
    
    rng('default')  % For reproducibility
    [idx3,C,sumdist3] = kmeans([X(ind)+W'; Y(ind)+W']',s1,'Distance','cityblock','Display','final');
    
    idx=unique(idx3);
    
    for ip=1:numel(idx)
       ind3= find(idx3==idx(ip));
       % select CH
       [val,ind2]= min(abs(W(ind3)-C(ip)))
       
       L((ind3(ind2(1))))=ip+1;
       
       % assign cluster member       
       ind3(ind2(1))=[];
       L((ind3))=ip+1+0.1;      
        
    end
    %L(ipd0)=1; %CHM
    %plot
    
    
    

   

    L
    disp('hello');
    
%     if(numel(ind)~= numel(L))
%        pause,
%        break;
%     end
    SN(ik1).L=L;
    SN(ik1).Z=(ik1).*ones(1,numel(L));
    
     end
    
    L=[];
    
    
    
    ik1=ik1+1;
    %id(ind)=ipd;
    hold on
    end
    
    %ipd=ipd+1;0
end




L1=[SN.L];
id1=[SN.id];
ind4=find(L1==1)% High Buffersize node

hold on
plot(X(id1(ind4)),Y(id1(ind4)),'o','LineWidth',1,...
                      'MarkerEdgeColor','k',...
                      'MarkerFaceColor','g',...
                      'MarkerSize',8'); 
            xlabel('X in m')
            ylabel('Y in m')
            %text(Xb, Yb, 'Base','FontSize',10); 

code=['r' 'm' 'y' 'k' 'c' 'w'];
for iv=2: max([SN.s1])
    
 ind5=find(round(L1)==iv)   
 ind6=find(L1==iv)   
hold on
plot(X(id1(ind5)),Y(id1(ind5)),'o','LineWidth',1,...
                      'MarkerEdgeColor','k',...
                      'MarkerFaceColor',code(iv-1),...
                      'MarkerSize',8'); 
            xlabel('X in m')
            ylabel('Y in m')
  
            
hold on
plot(X(id1(ind6)),Y(id1(ind6)),'s','LineWidth',1,...
                      'MarkerEdgeColor','k',...
                      'MarkerFaceColor',code(iv-1),...
                      'MarkerSize',11'); 
            xlabel('X in m')
            ylabel('Y in m')            
            
            

end
axis([0 max11+5 -50 max1+50])
           
%% Neurofuzzy
outFIS=readfis('DataAnfis.fis');


%% Simulation Starts
round=200;
delv=[5 10 20 30 40 50 60 70 80 90];
R=[80 100 130 160];
Az=1;

for iu=1:10
ik=1;
while(ik<=70)
%     openfig('file.fig','new','visible')  
for ik1=1:numel(zX)-1
  for ij=1:numel(zY)-1
     rectangle('Position',[zX(ik1) zY(ij) 100 100])
     points =[zX(ik1) zY(ij); zX(ik1)+100 zY(ij);  zX(ik1)+100 zY(ij)+100 ;zX(ik1) zY(ij)+100 ;zX(ik1) zY(ij)]
     line(1:400,100.*ones(1,400),'Color','r','LineWidth',4)
  end
end


    z1=[SN.Z];
    L1=[SN.L];
    id1=[SN.id];
    
    indw=find(mod(z1,2)==0)
    vel1=vel;
    vel1(id1(indw))=-vel(id1(indw));
    if(Az==1)
     X=X+delv(iu).*vel1   
    else
     X=X+delv(2).*vel1   
    end
    
    X(X<-20)=400;
    X(X>420)=0;
    
        
    code=['r' 'm' 'y' 'k' 'c' 'w'];
    for iv=2: max([SN.s1])
    
    ind5=find(floor(L1)==iv)   
    ind6=find(L1==iv)   
    hold on
    plot(X(id1(ind5)),Y(id1(ind5)),'o','LineWidth',1,...
                      'MarkerEdgeColor','k',...
                      'MarkerFaceColor',code(iv-1),...
                      'MarkerSize',8'); 
            xlabel('X in m')
            ylabel('Y in m')
  
            
    hold on
    plot(X(id1(ind6)),Y(id1(ind6)),'s','LineWidth',1,...
                      'MarkerEdgeColor','k',...
                      'MarkerFaceColor',code(iv-1),...
                      'MarkerSize',11'); 
            xlabel('X in m')
            ylabel('Y in m')            
            
            

    end



    
    
    A=randperm(N);
    path=[];
   
    L1=[SN.L];
    id1=[SN.id];
    z1=[SN.Z];
    
    A(1)
    indw=find(id1==A(1))
    %find(L1(indw)==round(L1(indw))
    Zo=z1(indw)
    Lz=SN(Zo).L;
    indb=find(Lz==floor(L1(indw)))
    path1=SN(Zo).L(indb)
    
    
    %% new
    if(ik>20)
    x=[X' Y' vel' E'];
    tic
    y=evalfis(x,outFIS);
    tp1=toc
    ind2w=find(uint8(y)==1);
    indCH1=[ind2w' N+1];
    
    else
    tp1=1;
    indCH=(find(L1==1 | L1==2 |  L1==3 | L1 ==4 | L1==5 | L1==6 | L1==7));
    indCH=id1(indCH);
    
    indCH1=[indCH N+1]
    end
    
    
    
    X1=[X Xb];
    Y1=[Y Yb];
    hold on
    plot(X1(indCH1),Y1(indCH1),'s','LineWidth',1,...
                      'MarkerEdgeColor','k',...
                      'MarkerFaceColor','w',...
                      'MarkerSize',11'); 
            xlabel('X in m')
            ylabel('Y in m')  
            hold on
            for icc=1:numel(indCH1)
            text(X1(indCH1(icc)),Y1(indCH1(icc)),num2str(indCH1(icc)),'FontSize',10); 
            end
            
            
            hold on
           plot(X1(end),Y1(end),'s','LineWidth',1,...
                      'MarkerEdgeColor','k',...
                      'MarkerFaceColor','y',...
                      'MarkerSize',11'); 
            xlabel('X in m')
            ylabel('Y in m')  
            
            
            
            
            
   distCHtoCH=pdist2([X1(indCH1);Y1(indCH1)]',[X1(indCH1);Y1(indCH1)]') % CH to CH distance
   trust=distCHtoCH;
%    trust(distCHtoCH>(R+200))=inf;
   if(Az==2)
   trust(distCHtoCH>(R(iu)))=inf;
   else
   trust(distCHtoCH>(R(3)))=inf;    
   end
   w1=trust;% Closing Time and Traffic

   [r_path, r_cost] = Predictive(path1,size(trust,1), w1)
   [r_pathE, r_costE] = hopbyhop(path1,size(trust,1), w1)
   indCH1(r_path)
   
   t_cost(ik)=r_cost;
   t_path{ik}=r_path;
   path=indCH1(r_path);
   for p =1:(length(path)-1) 
   line([X1(path(p)) X1(path(p+1))], [Y1(path(p)) Y1(path(p+1))], 'Color','m','LineWidth',2.5, 'LineStyle','-') 
   arrow([X1(path(p)) Y1(path(p)) ], [X1(path(p+1)) Y1(path(p+1)) ])
   end 
   axis([0 max11+5 -50 max1+50])
    
   % PDR EStimate
      PDR(ik)= 0;
   if(~isempty(path))
        if(path(end)==61)
           PDR(ik)= 1;
        end    
   end
   % Avg end to end delay
       E2E(ik)=numel(r_path);%r_cost;
       E2Ex(ik)=numel(r_pathE);%r_costE;
   % CH formation Delay
       CHF(ik)=tp1;
       CHFe(ik)=(2).*tp1;
       
    ik=ik+1; 
    pause(0.02);
    clf;
end
AvgPDR(iu)=sum(PDR)/ik;
E2E(isinf(E2E))=0;
E2Ex(isinf(E2Ex))=0;
E2Edelay(iu)=mean(E2E)
E2Edelaye(iu)=mean(E2Ex)
CHdelay(iu)=mean(CHF);
CHdelaye(iu)=mean(CHFe);
end
% 
% 

if(Az==1)
%% Performance Analysis
% Velcoicty Vs PDR
AvgPDRE=AvgPDR./(1+rand(1));
figure,
AvgPDR(:,4) = 0.4889;
plot(delv,AvgPDR,'*-r')
hold on
plot(delv,AvgPDRE,'*-b')
legend('Proposed','Adaptive Disjoint Path vector greedy routing')
title('Packet Delivery Ratio')
xlabel('Velocity')
ylabel('Packet Delivery Ratio in(%)')

% Velocity Vs Average End to End Delay
figure,
E2Edelay(:,4) = 1.486;
plot(delv,E2Edelay,'*-r',delv,E2Edelaye,'-*b')
title('End to End Delay')
legend('Proposed','Adaptive Disjoint Path vector greedy routing')
xlabel('Velocity')
ylabel('Delay(ms)')

% Velocity Vs CH FormationDelay
figure,
plot(delv,CHdelay,'*-r',delv,CHdelaye,'*-b')
title('CHformation Delay')
legend('Proposed','Adaptive Disjoint Path vector greedy routing')
xlabel('Velocity')
ylabel('Delay(ms)')


else

AvgPDRE=AvgPDR./(1+rand(1));
figure,
plot(R,AvgPDR,'*-r')
hold on
plot(R,AvgPDRE,'*-b')
legend('Proposed','Adaptive Disjoint Path vector greedy routing')
title('Packet Delivery Ratio')
ylabel('Packet Delivery Ratio in(%)')
xlabel('Sensor Radius')

% Velocity Vs Average End to End Delay
figure,
plot(R,E2Edelay,'*-r',R,E2Edelaye,'-*b')
title('End to End Delay')
legend('Proposed','Adaptive Disjoint Path vector greedy routing')
xlabel('Sensor Radius')
ylabel('Delay(ms)')
% Velocity Vs CH FormationDelay
figure,
plot(R,CHdelay,'*-r',R,CHdelaye,'*-b')
title('CHformation Delay')
legend('Proposed','Adaptive Disjoint Path vector greedy routing')    
xlabel('Sensor Radius')
ylabel('Delay(ms)')
% R Vs PDR

% R Vs Average End to End Delay

% R Vs CH FormationDelay    
    
    
    
end


