function [formant] = formantcos(TAILLE, SURECHANTILLONNAGE)
  PI = 3.1415926535;
  formant = zeros(1,TAILLE);
  t = ([1:1:TAILLE] - floor((TAILLE+1)/2)) / SURECHANTILLONNAGE;
  for i=1:TAILLE
    if (t(i)*t(i)) == (1/16)
      formant(i) = PI / 4;
    else
      formant(i) = cos(2*PI*t(i)) ./ (1 - 16 * t(i) * t(i));
    end;
  end
end