function Tanner(H)
clf; close all;
figure('Name','Tanner Graph','NumberTitle','off');
check = zeros(1,size(H,1));
node = zeros(1,size(H,2));
for i=2:size(check,2)
    if mod(size(check,2),2) == 0
        check(1,1) = -floor(size(check,2)/2)*2+0.5;
    else
        check(1,1) = -floor(size(check,2)/2)*2;
    end
    check(1,i) = check(1,i-1) + 2;
end
for i=2:size(node,2)
     if mod(size(node,2),2) == 0
        node(1,1) = -floor(size(node,2)/2)*2+1;
    else
        node(1,1) = -floor(size(node,2)/2)*2;
    end
    node(1,i) = node(1,i-1) + 2;
end
for i=1:size(check,2)
    plot(check(1,i),3,'Marker','s','MarkerFacecolor','r','MarkerEdgeColor','r','MarkerSize',14);
    hold on;
end
for i=1:size(node,2)
    plot(node(1,i),-3,'Marker','s','MarkerFacecolor','b','MarkerEdgeColor','b','MarkerSize',14);
    hold on;
end
for i=1:size(H,2)
    for j=1:size(H,1)
        if (H(j,i) == 1)
            a = 6/(check(1,j)-node(1,i));
            b = 3 - a*check(1,j);
            fplot(@(x) a*x+b,[min(check(1,j),node(1,i)) max(check(1,j),node(1,i))],'k');
            hold on;
        end
    end
end
axis([-max(size(check,2),size(node,2)) max(size(check,2),size(node,2)) -5 5]);
txt='CHECK NODES';
text(-2,4,txt,'FontSize',15);
txt='BIT NODES';
text(-1.5,-4,txt,'FontSize',15);
end