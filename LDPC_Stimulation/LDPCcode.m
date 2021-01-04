function LDPCcode
clear all; clc; clf;
%                             a=[];
%                             for i=1:25
%                             a=[a 1];
%                             end
%                             for i=1:25
%                             a=[a 0];
%                             end
%                             for i=1:31
%                             a=[a 1];
%                             end
warning off;
disp('**************************************');
disp('***        LDPC ENCODER            ***');
disp('**************************************');
%--------------------------------------------------
while(1)
    mes = input('A. NHAP MESSAGE CAN MA HOA: ');
    if(isvector(mes)) && (size(mes,1) == 1)
        for i = 1:size(mes,2)
            if ((mes(1,i) == 1)||(mes(1,i) == 0))
                check =1;
            else
                check =0;
                break;
            end
        end
        if (check == 1)
            break;
        end
    end
    fprintf('\b');
    disp(' ----> NHAP SAI, NHAP LAI');
end
%--------------------------------------------------
while(1)
    rate= input('B. NHAP TI LE TRUYEN: ');
    if ((rate <= 1) && (rate >0))
        break;
    end
    fprintf('\b');
    disp(' ---> NHAP SAI, NHAP LAI');
end
%--------------------------------------------------
n=size(mes,2)/rate;
disp('C. CHON KENH TRUYEN MA THONG TIN TRUYEN DI: ');
disp('   1. Binary Enrasure Channel (BEC)')
disp('   2. Gauss Channel');
while(1)
channel = input('   Kenh truyen: ');
switch channel
    case 1
        while(1)
            p = input('D. NHAP XAC XUAT CHEO (crossover probability): p = ');
            if ((p <= 1) && (p >0))
                break;
            end
            fprintf('\b');
            disp(' ---> NHAP SAI, NHAP LAI');
        end
        break;
    case 2
        p = input('D. NHAP CONG SUAT TIN HIEU TREN NHIEU: SNR = ');
        break;
    otherwise
        fprintf('\b');
        disp(' ---> NHAP SAI, NHAP LAI');
end
end
%--------------------------------------------------
disp('E. CHON PHUONG PHAP THIET KE: ');
disp('   1. Traditional method');
disp('   2. Repeat-accumulate codes (RA code)');
disp('   3. Quasi-cyclic codes');
while(1)
type = input('   Phuong phap: ');
switch type
    case 1
        [c,H] = generateGmatrix(mes,n);
        break;
    case 2
        [c,H] = RAcode(mes,n);
        break;
    case 3
        [c,H] = Quasicyliccodes(mes,n);
        break;
    otherwise
        fprintf('\b');
        disp(' ---> NHAP SAI, NHAP LAI');
end
end
%--------------------------------------------------
disp(' ');
disp('---------------RESULT-----------------')
text = ['CODEWORD: ', mat2str(c)];
disp(text);
% disp('H MATRIX: ');
% disp(mat2str(H));
% Tanner(H);
disp('--------------------------------------');
%--------------------------------------------------
if (channel == 1)
    LDPCproperties(p,H);
end
%--------------------------------------------------
for i=1:5
    disp('.');
    pause(1);
end
disp('');


%--------------------------------------------------
disp('**************************************');
disp('***        LDPC DECODER            ***');
disp('**************************************');
%--------------------------------------------------
%{
while(1)
    y = input('A. NHAP MESSAGE THU DUOC: ');
    if(isvector(y)) && (size(y,1) == 1)
        for i = 1:size(y,2)
            if ((y(1,i) == 1)||(y(1,i) == 0))||isnumeric(y(1,i))
                check =1;
            else
                check =0;
                break;
            end
        end
        if (check == 1)
            break;
        end
    end
    fprintf('\b');
    disp(' ----> NHAP SAI, NHAP LAI');
end
%}
%--------------------------------------------------
p = [0.5	0.625	0.75	0.875	1	1.125	1.25	1.375	1.5	1.625	1.75	1.875	2	2.125	2.25	2.375	2.5	2.625	2.75	2.875	3	3.125	3.25	3.375	3.5	3.625	3.75	3.875	4];
%QC
%l=  [1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	2	2	2	2	2	2	3	3	3]; 
%RA
l=  [1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	2	2	2	2];
sum = zeros(1,size(p,2));
up = 0;
for o=1:10
% p = 10.^(p/10);
BE = zeros(1,size(p,2));
for q=1:size(p,2)
% w=0;
% count = 0;
% while(w==0)
if (channel == 2)
    bpskModulator = comm.BPSKModulator;
    %bpskDEModulator = comm.BPSKDemodulator;
    bpskDEModulator = comm.BPSKDemodulator('DecisionMethod',"Log-likelihood ratio");
    channelmt = comm.AWGNChannel('EbNo',p(1,q),'BitsPerSymbol',1);
    y = bpskModulator(c');
    y = channelmt(y);
    y = bpskDEModulator(y);
    y = y';
    temp = ones(1,size(y,2));
    for i=1:size(y,2)
        if (y(1,i) < 0)
            temp(1,i) = 1;
        else
            temp(1,i) = 0;
        end
    end
    check = mod(temp*H',2);
    text=['MESSAGE THU DUOC: ',mat2str(temp)];
    disp(text);
    [numerror,BER]=biterr(temp,c);
    text=['=> Number of error bit: ', num2str(numerror),'/',num2str(size(y,2))];
    disp(text);
    text=['=> Bit Error Ratio (BER): ', num2str(BER)];
    disp(text);
else
    y = bsc(c,p(1,q));
    check = mod(y*H',2);
    text=['MESSAGE THU DUOC: ',mat2str(y)];
    disp(text);
    [numerror,BER]=biterr(y,c);
    text=['=> Number of error bit: ', num2str(numerror),'/',num2str(size(y,2))];
    disp(text);
    text=['=> Bit Error Ratio (BER): ', num2str(BER)];
    disp(text);
end
%--------------------------------------------------
if isequal(check,zeros(1,size(check,2)))
%    fprintf('\b');
    disp('---> CORRECT CODEWORD');
    return
else 
%    fprintf('\b');
    disp('=> INCORRECT CODEWORD');
end
disp('=> SUA LOI');
sll = l(1,q);
disp('C. CHON THUAT TOAN GIAI MA:');
disp('   1. Sum-Product Algorithm');
disp('   2. Bit-flipping Algorithm');
up = up +1
while(1)
option = 1;
switch option
    case 1
        [z,fix] = SumproductDecode(channel,p(1,q),y,sll,H);
        break;
    case 2
        [z,fix] = BitFlipDecode(channel,y,sll,H);
        break;
    otherwise
        fprintf('\b');
        disp(' ---> NHAP SAI, NHAP LAI');
end
end
disp('D. KET LUAN: ');
if (fix == 0)
    disp('1. Decoder cannot fix this error:');
    disp('   Explanation: ');
    disp('    * Not enough ilteration number');
    disp('    * Over capacity of decoder');
    disp('2. Result:');
    text = ['z = ', mat2str(z)];
    disp(text);
else
    if isequal(z,c)
        disp(' Decoding Successfully');
        text=['   z = ',mat2str(z)];
        disp(text);
    else
        disp('=> Hamming distance is not enough decoder change data into different valid codeword in 2^k codeword');
        text=['   z = ',mat2str(z)];
        disp(text);
    end
end
disp('**************************************');
[numerror,BER]=biterr(z,c);
text=['=> Number of error bit: ', num2str(numerror),'/',num2str(size(c,2))];
disp(text);
if (BER == 0)
    BE(1,q) = -3.4;
else
    BE(1,q) = log10(BER);
end
text=['=> Bit Error Ratio (BER): ', num2str(BER)];
disp(text);
% if (q>2)
%     if (BE(1,q) <= BE(1,(q-1)))
%         w = 1;
%     else
%         count = count +1;
%         if (count == 3)
%             sll = sll +1;
%         end
%     end
% end
% end
end
sum = sum +BE;
hold on
plot(p,BE,'-r');
end
p;
BER = sum/10;
disp(mat2str(BER'));
plot(p,BER,'-b');
end
%--------------------------------------------------