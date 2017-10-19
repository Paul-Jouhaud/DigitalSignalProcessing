function signal = reception(signal, filtre, surechantillonage, sync)  
  signal = conv(signal, filtre);
  signal = signal(2*sync+1:surechantillonage:end);
  signal = 2 * (signal(1:end) > 0) - 1;  
end