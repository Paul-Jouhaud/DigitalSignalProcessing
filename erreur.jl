function erreur_function(rapport, taille_message, surechantillonnage, formant_base, formant_filtre)
    message = 2 * (randn(taille_message) .> 0.5) - 1;
    signal = emission(message, formant_base, surechantillonnage);
    signal = signal + bruit(rapport, formant_base'*formant_base, length(signal));
    recu = reception(signal, formant_filtre, surechantillonnage, ((length(formant_filtre)-1))/2); 
    recu = recu[1:length(message)];
    erreur = sum(abs.(recu-message)/2)/taille_message;
    return erreur
end
