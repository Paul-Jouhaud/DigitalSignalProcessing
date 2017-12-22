# Récepteur avec élimination des interférences entre symboles

# Initialisation des paramètres
N = 10;
taille_message = 10000;
surechantillonnage = 30;
taille_formant = 30;
length_samples = 8;
samples_step = 0.1;
test_number = 10;

# Initialisation des variables
formant_base = formantcos(surechantillonnage*taille_formant+1, surechantillonnage);
formant_filtre = formantcos(surechantillonnage*taille_formant+1, surechantillonnage);
teb_min = zeros(81);
teb_max = zeros(81);

# Définition du canal
x_canal = collect(-6*surechantillonnage:6*surechantillonnage)./surechantillonnage;
canal = zeros(length(x_canal));
mid = Int((length(x_canal) + 1)/2);
canal[mid:length(canal)] = exp.(-x_canal[mid:length(canal)]);

# Définition du filtre
filtre = conv(formant_base, canal);
filtre = filtre./(filtre'*filtre);
filtre = filtre[length(filtre):-1:1];

# Calcul des interférences
interferences = calcul_interferences(surechantillonnage, formant_base, filtre, canal);

temp = interferences[Int(floor(1+length(interferences)/2)):length(interferences)];
interferences = vcat(temp, interferences[1:Int(floor(length(interferences)/2))]);
interferences_inverses = real(ifft(1./fft(interferences)));

temp = interferences_inverses[1:Int(floor(length(interferences_inverses)/2) + 1)];
interferences_inverses = vcat(interferences_inverses[Int(floor(length(interferences_inverses)/2)+2):length(interferences_inverses)], temp);

interferences_inverses_analogique = zeros(((length(interferences_inverses)-1) * surechantillonnage)+1);
interferences_inverses_analogique[1:surechantillonnage:length(interferences_inverses_analogique)] = interferences_inverses;

filtre_interferences = conv(filtre, interferences_inverses_analogique);

for x = collect(0:samples_step:length_samples)
    times = 1/samples_step;
    i = Int(x*times) + 1
    current_teb_min = 1;
    current_teb_max = 0;
    for y = collect(1:N)
        temp_teb = erreur_canal(x, taille_message, surechantillonnage, formant_base, filtre_interferences, canal);
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
title("Récepteur sans interférences");
legend(["Erreur minimale du canal", "Erreur maximale du canal", "Taux d'erreur binaire théorique"]);
savefig("data/courbe_canal_simulee_sansinterference.png");
