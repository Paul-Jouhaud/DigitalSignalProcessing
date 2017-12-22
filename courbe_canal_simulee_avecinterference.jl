# Récepteur avec interférences entre symboles

# Initialisation des paramètres
N = 10;
taille_message = 10000;
surechantillonnage = 10;
taille_formant = 100;
taille_zero_padding = 15;
length_samples = 8;
samples_step = 0.1;
test_number = 10;

# Initialisation des variables
formant_base = formantcos(surechantillonnage*taille_formant+1, surechantillonnage);
formant_filtre = formantcos(surechantillonnage*taille_formant+1, surechantillonnage);
teb_min = zeros(81);
teb_max = zeros(81);

# Initialisation du canal
x_canal = collect(-6*surechantillonnage:6*surechantillonnage)./surechantillonnage;
canal = zeros(length(x_canal));
mid = Int((length(x_canal) + 1)/2);
canal[mid:length(canal)] = exp.(-x_canal[mid:length(canal)]);

# Calcul de l'interférence entre symboles
filtre = conv(canal, formant_base);
filtre = filtre./(filtre'*filtre);
filtre_recepteur_naif = filtre[length(filtre):-1:1];
zero_padding = zeros(taille_zero_padding);
dirac = zeros(2*taille_zero_padding + 1);
dirac[taille_zero_padding + 1] = 1
signal_interference = emission(dirac, formant_base, surechantillonnage);
signal_interference = conv(signal_interference, canal);
recu_interference = conv(signal_interference, filtre_recepteur_naif);
end_interference = length(recu_interference);
recu_interference = recu_interference[1:surechantillonnage:end_interference];
end_interference = length(recu_interference);
recu_interference = vcat(recu_interference[Int((end_interference+1)/2):1:end_interference], recu_interference[1:1:Int((end_interference-1)/2)]);
fft_recu_interference = fft(recu_interference);

message = 2 * (randn(taille_message) .> 0.5) - 1;
signal = emission(message, formant_base, surechantillonnage);
signal = conv(signal, canal);
energie = (signal'*signal)./taille_message;

# Filtre récepteur sans suppression d'interférences
for x = collect(0:samples_step:length_samples)
    times = 1/samples_step;
    i = Int(x*times) + 1
    current_teb_min = 1;
    current_teb_max = 0;
    N0 = energie ./ (10^(x/10));
    interferences_inverses = real(ifft(1./(N0/2 + fft_recu_interference)));
    end_interference = length(interferences_inverses);
    interferences_inverses = vcat(interferences_inverses[Int((end_interference+1)/2+1):1:end_interference], interferences_inverses[1:1:Int((end_interference-1)/2+1)]);
    interferences_inverses_analogique = zeros((length(interferences_inverses)) * surechantillonnage);
    interferences_inverses_analogique[1:surechantillonnage:length(interferences_inverses_analogique)] = interferences_inverses;

    h = conv(filtre[length(filtre):-1:1], interferences_inverses_analogique);

    for y = collect(1:N)
        temp_teb = erreur_canal(x, taille_message, surechantillonnage, formant_base, h, canal);
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
title("Récepteur avec interférences");
legend(["Erreur minimale du canal", "Erreur maximale du canal", "Taux d'erreur binaire théorique"]);
savefig("data/courbe_canal_simulee_avecinterference.png");
