function LDPCproperties(p,H)
p0=p;
wc = nnz(H(:,1));
wr = nnz(H(1,:));
for i=2:size(H,2)
    if wc ~= nnz(H(:,i))
        reg = 0;
        break
    end
    reg=1;
end
for i=2:size(H,1)
    if wr ~= nnz(H(i,:))
        reg = 0;
        break
    end
    reg=1;
end
count = 0;
pi = p0;
if reg == 1
    figure('Name','LDPC Properties','NumberTitle','off');
    plot(count,pi,'o','Color','b');
    hold on;
end
while (1)
if (reg == 1)
    pi=p0*((1-(1-pi)^(wr-1))^(wc-1));
    count = count +1;
    plot(count,pi,'o','Color','b');
    hold on;
    a=p0*((1-(1-pi)^(wr-1))^(wc-1));
    if (round(a,7) == 0)
        break;
    else
        if round(a,5) == round(pi,5)
            break;
        end
    end
else 
    break
end
end
axis([0 count 0 p0+0.01]);
xlabel('Ilteration number');
ylabel('Erasure Probability');
text=['p0 = ',num2str(p0)];
legend(text);
end
