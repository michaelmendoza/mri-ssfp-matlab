

function [M] = get_sim_SSFP(alpha, TEs, dphis, T1, T2, fMax, Ns, show)

    % Initialize the matrix M, the columns of which will be the proposed
    % basis vectors
    M = zeros(Ns,numel(TEs)*numel(dphis));

    % Get the spectra for each value dphi (i.e., phase cycling)
    idx = 1;
    for ii = 1:numel(dphis)
        dphi = dphis(ii);

        % Get the spectra for each pair of TE, TR (TR = 2*TE)
        for jj = 1:numel(TEs)
            [ M(:,idx),~,~ ] = ssfp_spectrum(alpha,dphi,TEs(jj),TEs(jj)*2,T1,T2,fMax,Ns);
            idx = idx + 1;
        end
    end

    % Show simulated SSFP spectra 
    if show
        figure;
        for ii = 1:size(M,2)
            subplot(6,1, ii);
            plot(abs(M(:,ii)));    
        end        
    end
end