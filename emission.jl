function emission(message, formant, surechantillonnage)
    signal = zeros((length(message) - 1) * surechantillonnage + 1)
    signal[1:surechantillonnage:length(signal)] = message
    signal = conv(signal, formant);
    return signal
end
