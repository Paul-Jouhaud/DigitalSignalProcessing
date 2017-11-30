x = (0:0.1:8);
y = 0.5 * erfc(sqrt(10.^(x/10)));
figure 1;
plot(x, y)
%saveas(plot(line), 'erreur_binaire_theorique.png')
