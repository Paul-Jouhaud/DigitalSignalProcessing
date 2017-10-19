TAILLE_MESSAGE = 1000;
SURECHANTILLONNAGE = 30;
TAILLE_FORMANT = 100;
message = 2 * (rand(1,TAILLE_MESSAGE) > 0.5) - 1;
formant = formantcos(SURECHANTILLONNAGE*TAILLE_FORMANT+1, SURECHANTILLONNAGE);
signal = emission(message, formant, SURECHANTILLONNAGE);
filtre = formant(1,end:-1:1) / (formant*formant');
recu = reception(signal, filtre, SURECHANTILLONNAGE, 1+TAILLE_FORMANT*SURECHANTILLONNAGE/2);
recu = recu(1,1:size(message,2));
sum(abs(recu-message)/2)
plot(recu)