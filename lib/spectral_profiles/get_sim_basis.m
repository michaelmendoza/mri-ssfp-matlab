function [ Q,R,E,M ] = get_sim_basis(alpha,TEs,dphis,T1,T2,fMax,Ns)
    
    % Start a basis counter
    idx = 1;
    
    % Initialize the matrix M, the columns of which will be the proposed
    % basis vectors
    M = zeros(Ns,numel(TEs)*numel(dphis));
    
    % Get the spectra for each value dphi (i.e., phase cycling)
    for ii = 1:numel(dphis)
        dphi = dphis(ii);
        
        % Get the spectra for each pair of TE, TR (TR = 2*TE)
        for jj = 1:numel(TEs)
            [ M(:,idx),~,~ ] = ssfp_spectrum(alpha,dphi,TEs(jj),TEs(jj)*2,T1,T2,fMax,Ns);
            idx = idx + 1;
        end
    end
    
    % We're not confident that all columns of M are orthogonal, so we'll
    % run it through a QR decomposition - equivalent to Gram-Schmidt
    % orthogonalization
    [ Q,R,E ] = basis(M);    
end