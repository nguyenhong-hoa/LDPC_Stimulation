function [z,fix] = SumproductDecode(channel,p,y,sll,H)
done = 0;
r=zeros(1,size(y,2));
if channel == 1
    for i=1:size(y,2)
        if (y(1,i) == 1)
            r(1,i) = log(p/(1-p));
        else 
            r(1,i) = log((1-p)/p);
        end
    end
else
    for i=1:size(y,2)
        r(1,i)=4*y(1,i)*p;
    end
end
E = zeros(size(H,1),size(H,2));
L = zeros(1,size(y,2));
for lap=1:sll
M = zeros(size(H,1),size(H,2));
    for i=1:size(H,2)
        for j = 1:size(H,1)
            if H(j,i) == 1
            for k=1:size(H,1)
                if (j ~= k) && (H(k,i) == 1)
                    M(j,i) = M(j,i) + E(k,i);
                end
            end
            M(j,i) = M(j,i) + r(1,i);
            end
        end
    end
    for j=1:size(H,1)
        for i = 1:size(H,2)
            temp=1;
            if H(j,i) == 1
            for k=1:size(H,2)
                if (i ~= k) && (H(j,k) == 1)
                    temp = temp*tanh(M(j,k)/2);
                end
            end
            E(j,i)=2*atanh(temp);
            end
        end
    end
    for i=1:size(L,2)
        temp=0;
        for j=1:size(H,1)
            if H(j,i) ==1
                temp = temp + E(j,i);
            end
        end
        L(1,i) = r(1,i) + temp;
    end
    for i=1:size(L,2)
        if L(1,i) > 0
            L(1,i) = 0;
        else 
            L(1,i) = 1;
        end
    end
    if not(nnz(mod(L*H',2)))
        done = 1;
        break
    end
end
if (done == 1)
    z = L;
    fix = 1;
else
    z = L;
    fix = 0;
end