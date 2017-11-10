function c = canal(TAILLE_CANAL, SURECHANTILLONNAGE)
  c = zeros(1,TAILLE_CANAL);
  x = ([1:1:TAILLE_CANAL] - floor((TAILLE_CANAL+1)/2)) / SURECHANTILLONNAGE;
  for i=1:TAILLE_CANAL
    if x(i) >= 0
    c(i) = exp(-x(i));
    end;
  end

end