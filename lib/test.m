
alpha = 0.5 * pi;
dphi = 0;
T1 = 0.270;
T2 = 0.085;
fMax = 165;

[ M, f, beta ] = ssfp_spectrum(alpha, dphi, 0.003, 0.006, T1, T2, fMax);
[ M2, f, beta ] = ssfp_spectrum(alpha, dphi, 0.006, 0.012, T1, T2, fMax);
[ M3, f, beta ] = ssfp_spectrum(alpha, dphi, 0.012, 0.024, T1, T2, fMax);
[ M4, f, beta ] = ssfp_spectrum(alpha, pi, 0.003, 0.006, T1, T2, fMax);
[ M5, f, beta ] = ssfp_spectrum(alpha, pi, 0.006, 0.012, T1, T2, fMax);
[ M6, f, beta ] = ssfp_spectrum(alpha, pi, 0.012, 0.024, T1, T2, fMax);

figure(1);
subplot(3,1,1);
plot(abs(M));
subplot(3,1,2);
plot(abs(M2));
subplot(3,1,3);
plot(abs(M3));

figure(2)
subplot(3,1,1);
plot(abs(M4));
subplot(3,1,2);
plot(abs(M5));
subplot(3,1,3);
plot(abs(M6));
