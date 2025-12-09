function scores = fitness(x,nm,nj,p,s,d,a1,a2,a3,a4)
scores = zeros(size(x,1),1);
seq=x;
pr=0; %precedence restrictions
ta=0; %total tardiness
el=0; %total earliness
ntj=0; %number of tardy jobs
for k=1:length(seq)
j=seq(k);
for m= 1:nm
if m== 1
i(j,1)=0;
    if pr==0
    c(j,1)=p(j,1);
    else
    c(j,1)=c(pr,1)+s{1}(pr,j)+p(j,1);
    end
else
    if pr==0
        if i(j,m-1)<0
        i(j,m)=i(j,m-1)-p(j,m-1);
        else
        i(j,m)=-p(j,m-1);
        end
    else
        if i(j,m-1)<0
        i(j,m)=c(pr,m)-c(pr,m-1)+s{m}(pr,j)-s{m-1}(pr,j)-p(j,m-1)+i(j,m-1);
        else
        i(j,m)=c(pr,m)-c(pr,m-1)+s{m}(pr,j)-s{m-1}(pr,j)-p(j,m-1);
        end
    end
    if i(j,m)>=0
    c(j,m)=c(j,m-1)+p(j,m)+i(j,m);
    else
    c(j,m)=c(j,m-1)+p(j,m);
    end
end
end
if c(j,nm)>d(j)
    ntj=ntj+1;
    ta=ta+(c(j,nm)-d(j));
else
    ta=ta+0;
end
if d(j)>c(j,nm)
    el=el+(d(j)-c(j,nm));
else
    el=el+0;
end
pr=j;
end 
scores = a1*ta+a2*c(j,nm)+a3*el+a4*ntj
scores