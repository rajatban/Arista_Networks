function chanMat = genRayChan(nTx,nRx,dist)
    % generating rayleigh channel matrix
    pathgainParameter = 0.5;
    gain = pathgainParameter / (dist^2);
    chanMat = gain * (1/sqrt(2)*(randn(nRx, nTx) + 1i*randn(nRx, nTx)));
end

