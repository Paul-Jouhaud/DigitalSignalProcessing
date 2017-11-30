function bruit(rapport, energie_bit, taille_bruit)
    bruit =  randn(taille_bruit)
    var = energie_bit / (2*10.^(rapport/10))
    bruit = bruit * sqrt.(var)
    return bruit
end
