function [z,fix] = BitFlipDecode(channel,y,sll,H)
E = zeros(size(H,1),size(H,2));
if (channel == 2)
    for i=1:size(y,2)
        if (y(1,i) < 0)
            y(1,i) = 1;
        else 
            y(1,i) = 0;
        end
    end
end
M = y;
for lap=1:sll
    for j=1:size(H,1)
        for i=1:size(H,2)
            if H(j,i) == 1
                sum = 0;
                for k =1 :size(M,2)
                    if (H(j,k) == 1) && (k~=i)
                        sum = sum + M(1,k);
                    end
                end
                E(j,i) = mod(sum,2);
            end
        end
    end
    
    for i=1:size(M,2)
            count1=0;
            count0=0;
            for k = 1: size(H,1)
                if (H(k,i) == 1)
                    if (E(k,i) == 1)
                        count1 = count1 + 1;
                    else 
                        count0 = count0 +1;
                    end
                end
            end 
        if count1 > count0
            M(1,i) = 1;
        else
            if (count0 > count1)
                M(1,i) = 0;
            end
        end
    end
    check = mod(M*H',2);
    if not(nnz(check))
        fix = 1;
        break
    else
        fix = 0;
    end
end
z=M;
end