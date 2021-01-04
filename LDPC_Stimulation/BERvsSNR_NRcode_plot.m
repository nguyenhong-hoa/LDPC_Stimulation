EbNoVec = (-1:0.5:11 )';      % Eb/No values (dB)
berEst = zeros(size(EbNoVec));
bpskModulator = comm.BPSKModulator;
bpskDEModulator = comm.BPSKDemodulator('DecisionMethod',"Log-likelihood ratio");
p = dvbs2ldpc(1/2);
ldpcEncoder = comm.LDPCEncoder(p);
ldpcDecoder = comm.LDPCDecoder(p);
msg = logical(randi([0 1],size(p,2)-size(p,1),1));
for n = 1:length(EbNoVec)
   
    % Reset the error and bit counters
    numErrs = 0;
    numBits = 0;
 
    while numErrs < 1000 && numBits < 1e6
        
         % Transmit and receive LDPC coded signal data
        encData = ldpcEncoder(msg);
     
         %channel
        dataMod_psk = bpskModulator(encData);
        
        
        % Pass through AWGN channel
        channel = comm.AWGNChannel('EbNo',EbNoVec(n),'BitsPerSymbol',1);
        dataMod_psk2=channel(dataMod_psk);
        
        dataDeMod_psk3=bpskDEModulator(dataMod_psk2);
        rxBits = ldpcDecoder(dataDeMod_psk3);
        
        MSG=rxBits;
        chk = isequal(msg,MSG);
            
       % Calculate the number of bit errors
        nErrors = biterr(msg,MSG);
        
        % Increment the error and bit counters
        numErrs = numErrs + nErrors;
        numBits = numBits + length(msg); 
    end
    
    % Estimate the BER
    berEst(n) = numErrs/numBits;
end
berTheory = berawgn(EbNoVec,'psk',2,'nondiff');
semilogy(EbNoVec,berEst,'-.')
grid
legend('Estimated BER ldpc')
xlabel('Eb/No (dB)')
ylabel('Bit Error Rate')