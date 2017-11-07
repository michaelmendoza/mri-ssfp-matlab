function [Mc] = ssfp(beta, M0, alpha, phi, dphi, TR, TE, T1, T2)

E1 = exp(-TR/T1);
E2 = exp(-TR/T2);
theta = beta - dphi; % beta = 2*pi*f0*TR;
Mbottom = (1 - E1 * cos(alpha)) * (1 - E2 * cos(theta)) - E2 * (E1 - cos(alpha)) * (E2 - cos(theta));
Mx = M0 * (1 - E1) * sin(alpha) * (1 - E2 * cos(theta)) / Mbottom;
My = M0 * (1 - E1) * E2 * sin(alpha) * sin(theta) / Mbottom;
Mc = Mx + 1j * My;
Mc = Mc * exp(i * beta * (TE / TR)) * exp(-TE / T2);
