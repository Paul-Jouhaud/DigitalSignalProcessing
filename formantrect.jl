function formantrect(taille, surechantillonnage)
    pi = 3.1415926535
    formant = zeros(taille)
    t = collect(1:taille) - Int((taille+1) / 2) 
    t = t / surechantillonnage
    for i = collect(1:taille)
        if t[i] == 0
            formant[i] = 1
        else
            formant[i] = sinpi(t[i]) / (pi * t[i])
        end
    end
    return formant
end
