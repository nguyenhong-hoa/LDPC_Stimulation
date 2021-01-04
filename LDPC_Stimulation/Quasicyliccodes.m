function [c,H] = Quasicyliccodes(mes,n)
syms x;
k = size(mes,2);
v = n-k;
if mod(n,v)~=0
    disp('   ----> NHAP SAI');
    return
end
L=n/v;
H=[];
for i=1:(n/v)
    text = ['   Nhap chuoi da thuc thu ',num2str(i),':'];
    disp(text);
    fprintf('\b');
    a= input(' ');
    a= coeffs(a,'All');
    if (size(a,2)<v)
        a = [zeros(1,v-size(a,2)) a];
    end
    a= fliplr(a);
    H1=zeros(v);
    for j=1:v
        H1(j,:) = a;
        a = circshift(a,1);
    end
    H=[H H1];
end
for w=1:v:n-v+1
    HL = H(:,w:w+v-1);
    HL = [eye(v) HL];
    for i=(v+1):2*v
    for j = (i-v):v
        if (HL(i-v,i) == 1)
            break
        else
        if (HL(j,i)==1)
            c = HL(j,:);
            HL(j,:) = HL(i-v,:);
            HL(i-v,:) = c;
        end
        end
    end
    for  j=(i-v+1):v
        if  HL(j,i) == 1
            HL(j,:) = mod(HL(j,:) + HL(i-v,:),2);
        end
    end
    end
    for i=2*v:-1:v+2
        for j = i-v-1:-1:1
            if HL(j,i) == 1
               HL(j,:) = mod(HL(j,:) + HL(i-v,:),2);
            end
        end
    end
    check = HL(:,v+1:2*v);
    if (isequal(check,eye(v)))
        inv = HL(:,1:v);
        H = [H H(:,w:w+v-1)];
        H(:,w:w+v-1)=[];
        break
    end
end
HL = mod(inv,2);
G = [];

for i=1:v:size(H,2)-2*v+1
    H2 =(HL*H(:,i:i+v-1))';
    H2 = mod(H2,2);
    G = [G;H2];
end
G=[eye(v*(L-1)) G];
c=mod(mes*G,2);
end