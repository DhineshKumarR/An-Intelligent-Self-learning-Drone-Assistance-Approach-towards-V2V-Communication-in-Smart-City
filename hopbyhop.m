function [path,cost]=hopbyhop(start,stop,admatrix) 
%This function performs hop-by-hop routing by selecting the next hop with 
 
%initialisation 
noOfNodes = size(admatrix, 1); 
rpath=[]; 
rpath(1)=start; 
pathS=start; 
parent=pathS; 
cosy = 0; 
[route]=hopsdij(pathS,stop,admatrix);%checking if path exists between source and destination node 
if (pathS~=stop && route ==1)%main loop 
    k=1;%counter for neighbours 
    i=2;%path counter 
    while(pathS~=stop) 
        B=[];%vector of neighbours and trust values 
        jj=1; 
        for j= 1:noOfNodes 
                
            if admatrix(pathS, j)~=inf  
                B(jj,1)=j; 
                B(jj,2)=admatrix(pathS,j); 
                jj=jj+1; 
            end
              
        end 
  B =sortrows(B,-2); 
  p1=size(B);
  if p1(1)>=k
  nexthop = B(k,1);%nexthop with the highest trust value 
  else
      
 break;
  end
  chk = searchp(rpath,nexthop); 
  if chk==1 
   
 [route]=hopsdij(nexthop,stop,admatrix); 
       if(route==0) 
          k=k+1; 
       else 
           rpath(i)=nexthop; 
           pathS=nexthop; 
           k =1; 
           i=i+1; 
          
       end 
    else 
      k = k+1; 
  end 
    end 
else 
    disp('source =dest or cannot reach destination') 
end 
path =rpath;%selected path 
cost=0; 
for d=2:length(path) 
        cost= cost+admatrix(path(d-1),path(d)); 
end 
cost=cost/length(path);%average cost of the path 
  
%searching for visited nodes 
function c =searchp(rp,np) 
counter =0; 
for z=1:length(rp) 
    if np==rp(z) 
        counter=counter+1; 
    end 
end 
if counter>0 
    c = 0; 
else 
    c = 1; 
end 
 
function [route]=hopsdij(pathS,stop,admatrix)
if admatrix(pathS,stop)~=0 || admatrix(pathS,stop)~=inf
    route=1;
else
    route=0;
end


return 