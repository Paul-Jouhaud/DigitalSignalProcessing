# Récepteur adapté au canal déformé
# Récepteur naïf avec filtre adapté de la chaîne de transmission idéale

# Initialisation des paramètres
N = 10;
taille_message = 10000;
surechantillonnage = 30;
taille_formant = 30;
length_samples = 8;
samples_step = 0.1;
test_number = 10;

# Initialisation des variables
teb_min = zeros(81);
teb_max = zeros(81);
formant_base = formantcos(surechantillonnage*taille_formant+1, surechantillonnage);
formant_filtre = formantcos(surechantillonnage*taille_formant+1, surechantillonnage);

# Définition du canal
x_canal = collect(-6:0.01:6);
canal = zeros(length(x_canal));
mid = Int((length(x_canal) + 1)/2);
canal[mid:length(canal)] = exp.(-x_canal[mid:length(canal)]);

# Définition du filtre
filtre = conv(canal, formant_base);
filtre = filtre[end:-1:1]/(filtre'*filtre);

for x = collect(0:samples_step:length_samples)
    times = 1/samples_step;
    i = Int(x*times) + 1
    current_teb_min = 1;
    current_teb_max = 0;
    for y = collect(1:N)
        temp_teb = erreur_canal(x, taille_message, surechantillonnage, filtre, formant_filtre, canal);
        if temp_teb > current_teb_max
            current_teb_max = temp_teb;
        end
        if temp_teb < current_teb_min
            current_teb_min = temp_teb;
        end
    end
    teb_min[i] = current_teb_min;
    teb_max[i] = current_teb_max;
end

# Calcul du taux d'erreur binaire théorique
x = collect(0:samples_step:length_samples);
y = zeros(length(x));
for i = collect(1:length(x))
    y[i] = 0.5 * erfc(sqrt(10^(x[i]/10)));
end

# Affichage de graphes
plot(x, teb_min, "red", x, teb_max, "blue", x, y, "green");
title("Récepteur naïf");
legend(["Erreur minimale du canal", "Erreur maximale du canal", "Taux d'erreur binaire théorique"]);
savefig("data/courbe_canal_simulee_naive.png");
