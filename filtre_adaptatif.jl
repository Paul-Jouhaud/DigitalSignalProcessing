function adaptatif_carre_init(taille_filtre, w)
    H = zeros(taille_filtre);
    X = zeros(taille_filtre);
    Y = zeros((taille_filtre-1)/2+1);
    r = zeros(taille_filtre);
    filtre = Dict()
    filtre["W"] = w;
    filtre["H"] = H;
    filtre["taille"] = taille_filtre;
    filtre["X"] = X;
    filtre["Y"] = Y;
    filtre["R"] = r;

    for i=collect(1:1:taille_filtre)
        r[i] = 1/(w^(i-1));
    end
    filtre["R"] = diagm(r)
    return filtre
end

function adaptatif_carre(x, y, filtre)
    filtre["X"] = vcat(filtre["X"][2:length(filtre["X"])], x);
    filtre["Y"] = vcat(filtre["Y"][2:length(filtre["Y"])], y);

    err = filtre["H"] * filtre["X"]' - filtre["Y"][1];
    
    num = filtre["X"]' * filtre["R"];
    num = filtre["X"] * num;
    num = filtre["R"] * num;
    den = filtre["W"] + filtre["X"]' * filtre["R"]' * filtre["X"];
    filtre["R"] = (1./filtre["W"]) * (filtre["R"] - num'./den);
    tmp = filtre["X"]' * err;
    tmp = filtre["R"]' * tmp';
    filtre["H"] = filtre["H"] - tmp;
    return sum(err), filtre
end

function test_carre_filtre(taille_filtre, taille_signal, w, filtre)
    x = randn(taille_signal);
    erreurs = zeros(taille_signal);
    y = conv(x, filtre);
    zero = Int((length(filtre)-1)/2);
    y = y[1+zero:length(y)-zero];

    filtre_adaptatif = adaptatif_carre_init(taille_filtre, w);

    for i=collect(1:1:taille_signal)
        err, filtre_adaptatif = adaptatif_carre(x[i], y[i], filtre_adaptatif);
        erreurs[i] = err;
    end
    i=collect(1:1:taille_signal)
    plot(i, erreurs, "blue");
    title("Erreur avec filtre adaptatif");
    savefig("data/courbe_filtre_adaptatif.png");
    return convergence
end
