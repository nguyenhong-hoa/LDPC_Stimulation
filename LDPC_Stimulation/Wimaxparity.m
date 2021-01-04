function [c,HW] = Wimaxparity(mes,n)
z = input('      Nhap he so z = ');
B = input('      Nhap ma tran B = ');
row = [];
HW = [];
for i=1:((n-size(mes,2))/z)
    for j = 1: n/z
        if (B(i,j) == -1)
            row = [row zeros(z)];
        else
            row = [row circshift(eye(z),B(i,j))];
        end
    end 
    HW=[HW;row];
    row =[];
end
    H = HW;
    
% %THEO CHUAN WIMAX Z = 96, N = 2304; IEEE802.16e
    m = 12*96;
    k = 12*96;
    g = 1*96;
    A = H(1:(m-g),1:k);
    B = H(1:(m-g),(k+1):(k+g));
    T = H(1:(m-g),(k+g+1):size(H,2));
    C = H((m-g+1):size(H,1),1:k);
    D = H((m-g+1):size(H,1),(k+1):(k+g));
    E = H((m-g+1):size(H,1),(k+g+1):size(H,2));
    p11 = mod(D + mod(mod(E*mod(det(T)*inv(T),2),2)*B,2),2);
    p11inv = mod(det(p11)*inv(p11),2);
    p12 = mod(C + mod(mod(E*mod(det(T)*inv(T),2),2)*A,2),2);
    p1=mod(mod(p11inv*p12,2)*mes',2);
    p1=p1';
    p21 = mod(det(T)*inv(T),2)*mod(A*mes' + B*p1',2);
    p2 = mod(p21,2);
    c = [mes p1 p2'];
    
 %THEO CHUAN WIMAX Z = 81, N = 1944; IEEE802.11n, R= 2/3
%     m = 8*81;
%     k = 16*81;
%     g = 1*81;
%     A = H(1:(m-g),1:k);
%     B = H(1:(m-g),(k+1):(k+g));
%     T = H(1:(m-g),(k+g+1):size(H,2));
%     C = H((m-g+1):size(H,1),1:k);
%     D = H((m-g+1):size(H,1),(k+1):(k+g));
%     E = H((m-g+1):size(H,1),(k+g+1):size(H,2));
%     p11 = mod(D + mod(mod(E*mod(det(T)*inv(T),2),2)*B,2),2);
%     p11inv = mod(det(p11)*inv(p11),2);
%     p12 = mod(C + mod(mod(E*mod(det(T)*inv(T),2),2)*A,2),2);
%     p1=mod(mod(p11inv*p12,2)*mes',2);
%     p1=p1';
%     p21 = mod(det(T)*inv(T),2)*mod(A*mes' + B*p1',2);
%     p2 = mod(p21,2);
%     c = [mes p1 p2'];

 %THEO CHUAN WIMAX Z = 81, N = 1944; IEEE802.11n, R= 1/2
%     m = 12*81;
%     k = 12*81;
%     g = 1*81;
%     A = H(1:(m-g),1:k);
%     B = H(1:(m-g),(k+1):(k+g));
%     T = H(1:(m-g),(k+g+1):size(H,2));
%     C = H((m-g+1):size(H,1),1:k);
%     D = H((m-g+1):size(H,1),(k+1):(k+g));
%     E = H((m-g+1):size(H,1),(k+g+1):size(H,2));
%     p11 = mod(D + mod(mod(E*mod(det(T)*inv(T),2),2)*B,2),2);
%     p11inv = mod(det(p11)*inv(p11),2);
%     p12 = mod(C + mod(mod(E*mod(det(T)*inv(T),2),2)*A,2),2);
%     p1=mod(mod(p11inv*p12,2)*mes',2);
%     p1=p1';
%     p21 = mod(det(T)*inv(T),2)*mod(A*mes' + B*p1',2);
%     p2 = mod(p21,2);
%     c = [mes p1 p2'];