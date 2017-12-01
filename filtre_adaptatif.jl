mutable struct GradientFiltre
    mu
    filtre
    taille
end


function adaptatif_gradient_init(taille, mu)
    return GradientFiltre(mu, zeros(taille), taille);
end

function adaptatif_gradient(x, y, filtre)
    filtre.x = x;
    erreur = filtre.filtre*x - y;
    filtre.filtre = filtre.filtre - mu*filtre.x'*erreur; 
end

mu = 0.5;
taillle = 1000;

