teb_min = zeros(81);
teb_max = zeros(81);

taille_message = 10000;
surechantillonnage = 30;
taille_formant = 30;
formant_base = formantcos(surechantillonnage*taille_formant+1, surechantillonnage);
formant_filtre = formantcos(surechantillonnage*taille_formant+1, surechantillonnage);

canal = [1];

for x = collect(0:0.1:8)
    i = Int(x*10) + 1
    current_teb_min = 1;
    current_teb_max = 0;
    for y = collect(1:10)
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
x = collect(0:0.1:8)

y = zeros(length(x))
for i = collect(1:length(x))
    y[i] = 0.5 * erfc(sqrt(10^(x[i]/10)))
end

plot(x, teb_min, "red", x, teb_max, "blue", x, y, "green")
title("Test n°1")
legend(["Erreur minimale du canal", "Erreur maximale du canal", "Taux d'erreur binaire théorique"])
savefig("data/courbe_canal_simulee_test1.png")
