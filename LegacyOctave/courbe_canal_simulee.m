TAILLE_MESSAGE = 10000;
SURECHANTILLONNAGE = 20;
TAILLE_FORMANT = 20;
formant_em = formantcos(SURECHANTILLONNAGE*TAILLE_FORMANT+1, SURECHANTILLONNAGE);
formant_re = formantcos(SURECHANTILLONNAGE*TAILLE_FORMANT+1, SURECHANTILLONNAGE);
rapport = [0:0.5:8];
max_list = zeros(1,length(rapport));
min_list = zeros(1,length(rapport));

TAILLE_CANAL=101;
c = canal(TAILLE_CANAL, SURECHANTILLONNAGE);

for i=1:length(rapport)
  i
  erreurs = zeros(1,50);
  for j=1:length(erreurs)
    erreurs(j) = erreur_canal(rapport(i), TAILLE_MESSAGE, SURECHANTILLONNAGE, formant_em, formant_re, c);
  end
  max_list(i) = max(erreurs);
  min_list(i) = min(erreurs);
end

TEB = 0.5 * erfc(sqrt((10.^(rapport/10))));

plot(rapport, max_list, rapport, min_list, rapport, TEB);