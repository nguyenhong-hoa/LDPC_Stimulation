clc;
qpskModulator = comm.QPSKModulator('BitInput',true);
qpskDemodulator = comm.QPSKDemodulator('BitOutput',true);
channel = comm.AWGNChannel('EbNo',2);
data = randi([0 1],1000,1);
txSig = qpskModulator(data);
rxSig = channel(txSig);
rxData = qpskDemodulator(rxSig);
sum(rxData~=data)/size(data,1)

qpskModulator = comm.QPSKModulator('BitInput',true);
qpskDemodulator = comm.QPSKDemodulator('BitOutput',true,'DecisionMethod','Log-likelihood ratio');
% rxSig = channel(txSig);
rxSig = awgn(txSig,2);
rxData = qpskDemodulator(rxSig);
for i=1:size(rxData,1)
    if (rxData(i,1)<= 0)
        rxData(i,1)=1;
    else
        rxData(i,1)=0;
    end
end
sum(rxData~=data)/size(data,1)