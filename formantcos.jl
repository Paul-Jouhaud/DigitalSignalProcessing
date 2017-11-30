function formantcos(taille, surechantillonnage)
    pi = 3.1415926535
    formant = zeros(taille)
    t = collect(1:taille) - Int((taille+1) / 2) 
    t = t / surechantillonnage
    for i = collect(1:1:taille)
        if t[i]^2 == (1/16)
            formant[i] = pi/4
        else
            formant[i] = cospi(2*t[i]) / (1 - 16 * t[i]^2)
        end
    end
    return formant
end
