function xc=arr_change(xc)
[y,x]=size(xc);
p=randperm(x);

temp=xc(p(1));
xc(p(1))=xc(p(2));

xc(p(2))=temp;


end

