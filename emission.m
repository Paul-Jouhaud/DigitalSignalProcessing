function signal = emission(message, formant, SURECHANTILLONNAGE)
  signal = zeros(1,(length(message)-1)*SURECHANTILLONNAGE+1);
  signal(1,1:SURECHANTILLONNAGE:end) = message;
  signal = conv(signal, formant);
end