# Taux d'erreur simulé de la chaîne de transmission idéale
# courbe_ideale_simulee.jl

# Initialisation des paramètres
taille_message = 1000;
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

for x = collect(0:samples_step:length_samples)
    times = 1/samples_step;
    i = Int(x*times) + 1
    current_teb_min = 1;
    current_teb_max = 0;
    for y = collect(1:test_number)
        temp_teb = erreur_function(x, taille_message, surechantillonnage, formant_base, formant_filtre);
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

plot(x, teb_min, "red", x, teb_max, "blue", x, y, "green");
title("Taux d'erreur binaire simulé et théorique de la chaîne de transmission idéale");
legend(["Taux d'erreur binaire minimum", "Taux d'erreur binaire maximum", "Taux d'erreur binaire théorique"]);
savefig("data/courbe_ideale_simulee.png");
