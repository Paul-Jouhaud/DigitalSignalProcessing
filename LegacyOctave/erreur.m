function erreur = erreur(rapport, taille_message, SURECHANTILLONNAGE, formant_base, formant_filtre)
    message = 2 * (rand(1,taille_message) > 0.5) - 1;
    signal = emission(message, formant_base, SURECHANTILLONNAGE);
    signal = signal + bruit(rapport, formant_base*formant_base', size(signal,2));
    recu = reception(signal, formant_filtre, SURECHANTILLONNAGE, ((size(formant_filtre, 2)-1)/SURECHANTILLONNAGE)*SURECHANTILLONNAGE/2); 
    recu = recu(1,1:size(message,2));
    erreur = sum(abs(recu-message)/2)/taille_message;
end