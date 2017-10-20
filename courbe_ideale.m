line = zeros(1,9);
for rapport=0:8
  line(rapport+1) = 0.5 * erfc(sqrt(rapport));
end
figure 1;
plot(line)
%saveas(plot(line), 'erreur_binaire_theorique.png')
