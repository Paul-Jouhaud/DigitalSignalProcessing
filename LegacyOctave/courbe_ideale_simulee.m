teb_min = zeros(1, 81);
teb_max = zeros(1, 81);

TAILLE_MESSAGE = 1000;
SURECHANTILLONNAGE = 30;
TAILLE_FORMANT = 100;
formant_base = formantcos(SURECHANTILLONNAGE*TAILLE_FORMANT+1, SURECHANTILLONNAGE);
formant_filtre = formantcos(SURECHANTILLONNAGE*TAILLE_FORMANT+1, SURECHANTILLONNAGE);

for x = (0:0.1:8)
  i = int8(x*10 + 1);
  disp(i);
  current_teb_min = 1;
  current_teb_max = 0;
  for y=1:10
    temp_teb = erreur(x, TAILLE_MESSAGE, SURECHANTILLONNAGE, formant_base, formant_filtre);
    if temp_teb > current_teb_max
      current_teb_max = temp_teb;
    endif
    if temp_teb < current_teb_min
      current_teb_min = temp_teb;
    endif
  endfor
  teb_min(i) = current_teb_min;
  teb_max(i) = current_teb_max;
endfor
figure 1;
plot((0:0.1:8), teb_min, (0:0.1:8), teb_max)
saveas(plot((0:0.1:8), teb_min, (0:0.1:8), teb_max), 'erreur_binaire_simulee2.png')

x = (0:0.1:8);
y = 0.5 * erfc(sqrt(10.^(x/10)));
saveas(plot((0:0.1:8), teb_min, (0:0.1:8), teb_max, (0:0.1:8), y), 'diff_erreur_binaire_simulee.png')
