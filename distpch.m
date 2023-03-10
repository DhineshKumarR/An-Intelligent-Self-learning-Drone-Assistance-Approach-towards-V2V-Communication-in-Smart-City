function pc=distpch2(dist) 

if(dist<=100)
    pc=30;
elseif(dist>100 && dist<=200)    
    pc=10;
elseif(dist>200 && dist<=300)
    pc=5;
elseif(dist>300 && dist<=400)
    pc=3;
% elseif(dist>400 && dist<=250)
%     pc=5;
end

end