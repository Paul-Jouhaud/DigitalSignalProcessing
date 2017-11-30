function signal = reception(signal, filtre, surechantillonage, sync)  
  signal = conv(signal, filtre);
  zero = (length(filtre)-1)/2 + sync;
  signal = signal(1,zero:surechantillonage:length(signal) - zero+1);
  signal = 2 * (signal > 0) - 1;  
end
