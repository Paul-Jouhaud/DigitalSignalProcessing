function erreur_canal(rapport, taille_message, surechantillonnage, formant_base, formant_filtre, canal)
    message = 2 * (rand(taille_message) .> 0.5) - 1;
    signal = emission(message, formant_base, surechantillonnage);
    signal = conv(signal, canal);
    signal = signal + bruit(rapport, signal'*signal/taille_message, length(signal));
    recu = reception(signal, formant_filtre, surechantillonnage, 1 + (length(formant_base) + length(canal) - 2) / 2);
    recu = recu[1:length(message)];
    erreur = sum(abs.(recu-message)/2)/taille_message;
    return erreur
end
