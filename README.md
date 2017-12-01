# Traitement Numérique du Signal pour les Télécommunications


Ce code a initiallement été développé en Matlab/Octave, puis entièrement ré-écrit en Julia pour des soucis de performances.

Avant d'utiliser ces scripts, veuillez créer un dossier data, dans le même dossier que les fichiers Julia.

## Todo :
- Envoyer le rapport avant le vendredi 22 décembre à midi pile

Pour l'utiliser, lancé Julia puis la commande suivante :

```
include("script.jl")`;
```

## Affiche les formants cosinus et rectangulaire

```
surechantillonnage = 10;
taille_formant = 10 * surechantillonnage + 1;
formant_rect = formantrect(taille_formant, surechantillonnage);
formant_cos = formantcos(taille_formant, surechantillonnage);
xrect = collect(1:length(formant_rect));
xrect = (xrect - (length(formant_rect) + 1) / 2) / surechantillonnage;
xcos = collect(1:length(formant_cos));
xcos = (xcos - (length(formant_cos) + 1) / 2) / surechantillonnage;
plot(xrect, formant_rect, "blue", xcos, formant_cos, "red", linewidth=1);
title("Représentation des formants cosinus et rectangulaire");
legend(["Rectangulaire", "Cosinus"]);
savefig("data/formants.png");
```

## Vérifie le bon fonctionnement de l'émetteur

```
taille_message = 1000;
surechantillonnage = 30;
taille_formant = 30;
message = 2 * (randn(taille_message) .> 0.5) - 1;
formant = formantcos(surechantillonnage * taille_formant + 1, surechantillonnage);
signal = emission(message, formant, surechantillonnage);
x = linspace(-taille_formant / 2 + 1 / surechantillonnage, taille_formant / 2 + taille_message, length(signal));
plot(x, signal, linewidth=1);
title("Message émis");
savefig("data/message.png");
```

## Vérifie le bon fonctionnement du récepteur

```
taille_message = 1000;
surechantillonnage = 30;
taille_formant = 30;
message = 2 * (randn(taille_message) .> 0.5) - 1;
formant = formantcos(surechantillonnage*taille_formant+1, surechantillonnage);
signal = emission(message, formant, surechantillonnage);
filtre = formant[length(formant):-1:1] / (formant'*formant);
recu = reception(signal, filtre, surechantillonnage, 1+taille_formant*surechantillonnage/2);
recu = recu[1:length(message)];
erreur = abs.(recu-message)/2 ;
sum(erreur);
x = collect(1:taille_message);
plot(x, erreur, linewidth=1);
title("Erreur entre le signal émis et celui reçu");
savefig("data/erreur_emis_recu.png");
```

## Ajout d'un bruit de canal

```
taille_message = 1000;
surechantillonnage = 30;
taille_formant = 30;
message = 2 * (randn(taille_message) .> 0.5) - 1;
formant = formantcos(surechantillonnage*taille_formant+1, surechantillonnage);
signal = emission(message, formant, surechantillonnage);
signal = signal + bruit(5, formant'*formant, length(signal));
filtre = formant[length(formant):-1:1] / (formant'*formant);
recu = reception(signal, filtre, surechantillonnage, 1+taille_formant*surechantillonnage/2);
recu = recu[1:length(message)];
erreur_message = abs.(recu-message)/2 ;
print(sum(erreur));
x = collect(1:taille_message);
plot(x, (recu-message)/2 , linewidth=1);
title("Erreur entre le signal émis et celui reçu");
savefig("data/erreur_emis_recu_bruitee.png");
```

## Courbes de taux d'erreur
### Taux d'erreur théorique de la chaîne de transmission idéale

```
x = collect(0:0.1:8);
y = zeros(length(x));
for i = collect(1:length(x))
    y[i] = 0.5 * erfc(sqrt(10^(x[i]/10)));
end
plot(x, y, linewidth=1);
title("Courbe idéale");
savefig("data/courbe_ideale.png");
```

### Taux d'erreur simulé de la chaîne de transmission idéale

```
# courbe_ideale_simulee.jl
teb_min = zeros(81);
teb_max = zeros(81);

taille_message = 1000;
surechantillonnage = 30;
taille_formant = 30;
formant_base = formantcos(surechantillonnage*taille_formant+1, surechantillonnage);
formant_filtre = formantcos(surechantillonnage*taille_formant+1, surechantillonnage);

for x = collect(0:0.1:8)
    i = Int(x*10) + 1
    current_teb_min = 1;
    current_teb_max = 0;
    for y = collect(1:10)
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
x = collect(0:0.1:8);
y = zeros(length(x));
for i = collect(1:length(x))
    y[i] = 0.5 * erfc(sqrt(10^(x[i]/10)));
end
plot(x, teb_min, "red", x, teb_max, "blue", x, y, "green");
title("Taux d'erreur binaire simulé et théorique de la chaîne de transmission idéale");
legend(["Taux d'erreur binaire minimum", "Taux d'erreur binaire maximum", "Taux d'erreur binaire théorique"]);
savefig("data/courbe_ideale_simulee.png");
```

## Chaîne de transmission non-idéale
### Introduction d’une déformation dans le canal
#### Test 1

```
# courbe_canal_simulee_test1.jl
teb_min = zeros(81);
teb_max = zeros(81);
N = 10;
taille_message = 10000;
surechantillonnage = 30;
taille_formant = 30;
formant_base = formantcos(surechantillonnage*taille_formant+1, surechantillonnage);
formant_filtre = formantcos(surechantillonnage*taille_formant+1, surechantillonnage);

canal = [1];

for x = collect(0:0.1:8)
    i = Int(x*10) + 1;
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
x = collect(0:0.1:8);

y = zeros(length(x));
for i = collect(1:length(x))
    y[i] = 0.5 * erfc(sqrt(10^(x[i]/10)));
end

plot(x, teb_min, "red", x, teb_max, "blue", x, y, "green");
title("Test n°1");
legend(["Erreur minimale du canal", "Erreur maximale du canal", "Taux d'erreur binaire théorique"]);
savefig("data/courbe_canal_simulee_test1.png");
```

#### Test 2

```
# courbe_canal_simulee_test2.jl
teb_min = zeros(81);
teb_max = zeros(81);
N = 10;
taille_message = 10000;
surechantillonnage = 30;
taille_formant = 30;
formant_base = formantcos(surechantillonnage*taille_formant+1, surechantillonnage);
formant_filtre = formantcos(surechantillonnage*taille_formant+1, surechantillonnage);

x_canal = collect(-6:0.01:6);
canal = zeros(length(x_canal));
mid = Int((length(x_canal) + 1)/2);
canal[mid] = 1;

for x = collect(0:0.1:8)
    i = Int(x*10) + 1
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
x = collect(0:0.1:8);

y = zeros(length(x));
for i = collect(1:length(x))
    y[i] = 0.5 * erfc(sqrt(10^(x[i]/10)));
end

plot(x, teb_min, "red", x, teb_max, "blue", x, y, "green");
title("Test n°2");
legend(["Erreur minimale du canal", "Erreur maximale du canal", "Taux d'erreur binaire théorique"]);
savefig("data/courbe_canal_simulee_test2.png");
```

#### Test 3

```
# courbe_canal_simulee_test3.jl
teb_max = zeros(81);
teb_min = zeros(81);
N = 10;
taille_message = 10000;
surechantillonnage = 30;
taille_formant = 30;
formant_base = formantcos(surechantillonnage*taille_formant+1, surechantillonnage);
formant_filtre = formantcos(surechantillonnage*taille_formant+1, surechantillonnage);

x_canal = collect(-6:0.01:6);
canal = zeros(length(x_canal));
mid = Int((length(x_canal) + 1)/2);
canal[mid] = 10;

for x = collect(0:0.1:8)
    i = Int(x*10) + 1
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
x = collect(0:0.1:8);

y = zeros(length(x));
for i = collect(1:length(x))
    y[i] = 0.5 * erfc(sqrt(10^(x[i]/10)));
end

plot(x, teb_min, "red", x, teb_max, "blue", x, y, "green");
title("Test n°3");
legend(["Erreur minimale du canal", "Erreur maximale du canal", "Taux d'erreur binaire théorique"]);
savefig("data/courbe_canal_simulee_test3.png");
```

#### Canal pour test final

```
x_canal = collect(-6:0.01:6);
canal = zeros(length(x_canal));
mid = Int((length(x_canal) + 1)/2);
canal[mid:length(canal)] = exp.(-x_canal[mid:length(canal)]);
plot(x_canal, canal, linewidth=1);
title("Canal utilisé pour la simulation");
savefig("data/canal_simulee.png");
```

#### Test complet

```
# courbe_canal_simulee.jl
teb_min = zeros(81);
teb_max = zeros(81);
N = 10;
taille_message = 10000;
surechantillonnage = 30;
taille_formant = 30;
formant_base = formantcos(surechantillonnage*taille_formant+1, surechantillonnage);
formant_filtre = formantcos(surechantillonnage*taille_formant+1, surechantillonnage);

x_canal = collect(-6:0.01:6);
canal = zeros(length(x_canal));
mid = Int((length(x_canal) + 1)/2);
canal[mid:length(canal)] = exp.(-x_canal[mid:length(canal)]);


for x = collect(0:0.1:8)
    i = Int(x*10) + 1
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
x = collect(0:0.1:8);

y = zeros(length(x));
for i = collect(1:length(x))
    y[i] = 0.5 * erfc(sqrt(10^(x[i]/10)));
end

plot(x, teb_min, "red", x, teb_max, "blue", x, y, "green");
title("Test final");
legend(["Erreur minimale du canal", "Erreur maximale du canal", "Taux d'erreur binaire théorique"]);
savefig("data/courbe_canal_simulee.png");
```

## Récepteur adapté au canal déformé
### Récepteur naïf avec filtre adapté de la chaîne de transmission idéale

```
# courbe_canal_simulee_naive.jl
teb_min = zeros(81);
teb_max = zeros(81);
N = 10;
taille_message = 10000;
surechantillonnage = 30;
taille_formant = 30;
formant_base = formantcos(surechantillonnage*taille_formant+1, surechantillonnage);
formant_filtre = formantcos(surechantillonnage*taille_formant+1, surechantillonnage);

x_canal = collect(-6:0.01:6);
canal = zeros(length(x_canal));
mid = Int((length(x_canal) + 1)/2);
canal[mid:length(canal)] = exp.(-x_canal[mid:length(canal)]);

filtre = conv(canal, formant_base);
filtre = filtre[end:-1:1]/(filtre'*filtre);

for x = collect(0:0.1:8)
    i = Int(x*10) + 1;
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
x = collect(0:0.1:8);

y = zeros(length(x));
for i = collect(1:length(x))
    y[i] = 0.5 * erfc(sqrt(10^(x[i]/10)));
end

plot(x, teb_min, "red", x, teb_max, "blue", x, y, "green");
title("Récepteur naïf");
legend(["Erreur minimale du canal", "Erreur maximale du canal", "Taux d'erreur binaire théorique"]);
savefig("data/courbe_canal_simulee_naive.png");
```

### Récepteur avec élimination des interférences entre symboles

```
# courbe_canal_simulee_sansinterference.jl
teb_min = zeros(81);
teb_max = zeros(81);
N = 10;
taille_message = 10000;
surechantillonnage = 30;
taille_formant = 30;
formant_base = formantcos(surechantillonnage*taille_formant+1, surechantillonnage);
formant_filtre = formantcos(surechantillonnage*taille_formant+1, surechantillonnage);

x_canal = collect(-6*surechantillonnage:6*surechantillonnage)./surechantillonnage;
canal = zeros(length(x_canal));
mid = Int((length(x_canal) + 1)/2);
canal[mid:length(canal)] = exp.(-x_canal[mid:length(canal)]);

filtre = conv(formant_base, canal);
filtre = filtre./(filtre'*filtre);
filtre = filtre[length(filtre):-1:1];

interferences = calcul_interferences(surechantillonnage, formant_base, filtre, canal);

temp = interferences[Int(floor(1+length(interferences)/2)):length(interferences)];
interferences = vcat(temp, interferences[1:Int(floor(length(interferences)/2))]);
interferences_inverses = real(ifft(1./fft(interferences)));

temp = interferences_inverses[1:Int(floor(length(interferences_inverses)/2) + 1)];
interferences_inverses = vcat(interferences_inverses[Int(floor(length(interferences_inverses)/2)+2):length(interferences_inverses)], temp);

interferences_inverses_analogique = zeros(((length(interferences_inverses)-1) * surechantillonnage)+1);
interferences_inverses_analogique[1:surechantillonnage:length(interferences_inverses_analogique)] = interferences_inverses;

filtre_interferences = conv(filtre, interferences_inverses_analogique);

for x = collect(0:0.1:8)
    i = Int(x*10) + 1;
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
x = collect(0:0.1:8);

y = zeros(length(x));
for i = collect(1:length(x))
    y[i] = 0.5 * erfc(sqrt(10^(x[i]/10)));
end

plot(x, teb_min, "red", x, teb_max, "blue", x, y, "green");
title("Récepteur sans interférences");
legend(["Erreur minimale du canal", "Erreur maximale du canal", "Taux d'erreur binaire théorique"]);
savefig("data/courbe_canal_simulee_sansinterference.png");
```

## Égalisation : récepteur avec filtre adaptatif

```

```
