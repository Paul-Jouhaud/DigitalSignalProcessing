function reception(signal, filtre, surechantillonnage, sync)
    signal = conv(signal, filtre);
    zero = Int(floor((length(filtre)-1)/2 + sync));
    signal = signal[zero:surechantillonnage:length(signal)-zero+1];
    signal = 2 * (signal .> 0) - 1;
    return signal
end
