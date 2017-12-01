function calcul_interferences(surechantillonnage, formant, filtre, canal)
    # Cette fonction renvoie le signal analogique en sortie du recepteur
    # lorsqu'on envoie un Dirac comme message. On peut ainsi observer les
    # interférences entre symboles (s'il n'y avait pas d'interférences, la
    # sortie serait un Dirac). 
    nbZeros = 100;
    message = zeros(nbZeros+1)
    message[Int(nbZeros/2+1)] = 1;
    formant = formantcos(surechantillonnage*length(formant)+1, surechantillonnage);
    signal = emission(message, formant, surechantillonnage);
    signal = conv(signal, canal);
    sortie_recepteur = conv(signal, filtre);
    milieu = (length(filtre)-1)/2 + (length(formant)-1)/2 + (length(canal) - 1)/2 +1;
    sortie_recepteur = sortie_recepteur[Int(mod(milieu, surechantillonnage)):surechantillonnage:end];
    return sortie_recepteur
    #   figure, plot((0:length(sortie_recepteur)-1) - (length(sortie_recepteur)-1)/2, sortie_recepteur)
    #   title('Interference entre symboles')
end
