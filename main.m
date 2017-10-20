TAILLE_MESSAGE = 1000;
SURECHANTILLONNAGE = 30;
TAILLE_FORMANT = 100;
message = 2 * (rand(1,TAILLE_MESSAGE) > 0.5) - 1;
formant = formantcos(SURECHANTILLONNAGE*TAILLE_FORMANT+1, SURECHANTILLONNAGE);
signal = emission(message, formant, SURECHANTILLONNAGE);
signal = signal + bruit(5, formant*formant', size(signal,2));
recu = reception(signal, formant, SURECHANTILLONNAGE, TAILLE_FORMANT*SURECHANTILLONNAGE/2);
recu = recu(1,1:size(message,2));
sum(abs(recu-message)/2)
%figure 1;
%plot(recu);
%saveas(recu,'signal_bruite.jpg');
%figure 2;
%plot(recu - message);
%saveas(plot(recu - message),'diff_noise.png')