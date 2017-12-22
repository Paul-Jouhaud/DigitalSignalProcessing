# Chaîne de transmission non-idéale
# Introduction d’une déformation dans le canal
# Test 1

# Initialisation des paramètres
N = 10;
taille_message = 1000;
surechantillonnage = 30;
taille_formant = 30;
length_samples = 8;
samples_step = 0.1;

# Initialisation des variables
formant_base = formantcos(surechantillonnage*taille_formant+1, surechantillonnage);
formant_filtre = formantcos(surechantillonnage*taille_formant+1, surechantillonnage);
teb_min = zeros(81);
teb_max = zeros(81);

# Initialisation du canal
canal = [1];

for x = collect(0:samples_step:length_samples)
    times = 1/samples_step;
    i = Int(x*times) + 1
    current_teb_min = 1;
    current_teb_max = 0;
    for y = collect(1:N)
        temp_teb = erreur_canal(x, taille_message, surechantillonnage, formant_base, formant_filtre, canal);
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

# Affichage des graphes
plot(x, teb_min, "red", x, teb_max, "blue", x, y, "green");
title("Test n°1");
legend(["Erreur minimale du canal", "Erreur maximale du canal", "Taux d'erreur binaire théorique"]);
savefig("data/courbe_canal_simulee_test1.png");
