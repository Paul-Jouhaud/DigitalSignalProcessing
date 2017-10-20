line = zeros(1,21);
for rapport=0:20
  line(rapport+1) = 0.5 * erfc(sqrt(rapport));
end
figure 1;
plot(line)
