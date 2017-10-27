function erreur = erreur_canal(rapport, taille_message, SURECHANTILLONNAGE, formant_base, formant_filtre, canal)
    message = 2 * (rand(1,taille_message) > 0.5) - 1;
    signal = emission(message, formant_base, SURECHANTILLONNAGE);
        signal = conv(signal, canal);
    signal = signal + bruit(rapport, signal*signal'/taille_message, size(signal,2));
    recu = reception(signal, formant_filtre, SURECHANTILLONNAGE, ...
    1 + (length(formant_base) + length(canal) - 2) / 2); 
    recu = recu(1,1:size(message,2));
    erreur = sum(abs(recu-message)/2)/taille_message;
end