function [ Mc, f, Beta ] = SSFPSpectrum(alpha, dphi, TE, TR, T1, T2)
    % SSFPSpectrum() generates an SSFP transverse magnetization spectrum with default parameters. 

    if not(exist('alpha')) TE = pi, end
	  if not(exist('dphi')) TE = 0, end
    if not(exist('TE')) TE = 0.005, end
    if not(exist('TR')) TR = 0.010, end
		if not(exist('T1')) T1 = 0.270, end
		if not(exist('T2')) T2 = 0.085, end
		
    M0 = 1;
    phi = 0;
    
    f0  = 0;
    beta0 = 2*pi*TR*f0; % Calculate addition phase due to f0
    BetaMax = 2 * pi;
    Ns = 100;
    
    Mc = [];
    count = 1;
    for beta = linspace(0, BetaMax, Ns)   % Interate through beta values
        Mc(count) = ssfp(beta + beta0, M0, alpha, phi, dphi, TR, TE, T1, T2);
        count = count + 1;
    end
        
    Beta = linspace(-BetaMax, BetaMax, Ns);
    f = Beta / TR / (2*pi);
end


