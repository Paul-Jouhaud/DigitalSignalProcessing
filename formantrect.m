function [formant] = formantrect(TAILLE, SURECHANTILLONNAGE)
  PI = 3.1415926535;
  formant = zeros(1,TAILLE);
  t = ([1:1:TAILLE] - floor((TAILLE+1)/2)) / SURECHANTILLONNAGE;
  for i=1:TAILLE
    if t(i) == 0
      formant(i) = 1;
    else
      formant(i) = sin(PI * t(i)) ./ (PI * t(i));
    end;
  end
end