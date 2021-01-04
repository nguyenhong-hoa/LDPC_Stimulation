function [c,H] = RAcode(mes,n)
k = size(mes,2);
m = n-k;
%--------------------------------------------------
%STEP 1:
%--------------------------------------------------
disp('    *With Rate = a/(a+q)');
while (1)
a = input('   Nhap trong so hang: a = ');
q = a*m/k;
if (rem(a*m,k)== 0)
    break;
else 
    fprintf('\b');
    disp(' ----> KHONG HOP LE, NHAP LAI');
end
end
text=['   Trong so cot la: q = ',num2str(q)];
disp(text);
check=0;
while (check==0)
pi = randperm(q*k);
pitest = ceil(pi/q);
for i=1:a:q*k-a+1
    if a ~= size(unique(pitest(1,i:i+a-1)),2)
        check = 0;
        break;
    else
        check = 1;
    end
end
break;
end

H1=zeros(m,k);
for i=1:k*q
    H1(ceil(i/a),ceil(pi(1,i)/q))=1;
end
H2=eye(m);
for i=1:(m-1)
    H2(i+1,i)=1;
end
H=[H1,H2];
%--------------------------------------------------
%STEP 2:
%--------------------------------------------------
b=zeros(1,q*k);
for i=1:q*k
    b(1,i) = mes(1,ceil(i/q));
end
d=b(:,pi);
r=zeros(1,m);
for i=1:m
    for j=(i-1)*a+1:i*a
        r(1,i) = mod(r(1,i) + d(1,j),2);
    end
end
p=zeros(1,m);
p(1,1)=r(1,1);
for i=2:m
    p(1,i) = mod(p(1,i-1)+r(1,i),2);
end
c=[mes p];
end