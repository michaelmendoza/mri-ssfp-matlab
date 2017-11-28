%% Simulated Spectra, magnitude data
function [ Q, c ] = simulate(alpha, dphi, TEs, TRs, T1, T2, fMax, desired, show_figs)

    M = zeros(100,length(TEs)*2);
    for kk = 1:length(TEs)
        % (1) Generate spectra
        [m,~,~] = ssfp_spectrum(alpha,dphi,TEs(kk),TRs(kk),T1,T2,fMax);
        M(:,kk) = m.';
        [m,~,~] = ssfp_spectrum(alpha,dphi+pi,TEs(kk),TRs(kk),T1,T2,fMax);
        M(:,kk+length(TEs)) = m.';

        % Show each pair
        if show_figs == 1
            figure(kk);
            subplot(2,1,1);
            plot((M(:,kk)));
            subplot(2,1,2);
            plot((M(:,kk+length(TEs))));
        end
    end
    
    % (2) Approximate desired function, store coefficients
    Q = make_basis(M);
    c = Q\desired;
end