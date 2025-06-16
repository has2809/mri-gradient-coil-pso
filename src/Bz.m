function B=Bz(z, a, Z, I)
u0 = 4*pi*10^-7;
N = length(Z);
sum = 0;
for n=1:N
    term1 = ( (z-Z(n))^2 + a^2)^(-3/2);
    term2 = ( (z+Z(n))^2 + a^2)^(-3/2);
    sum = sum + (term1-term2);
end
B = (u0*(a^2)/2)* I * sum;
end