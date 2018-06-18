
function [basis, coeff] = get_basis_coeff(M)
    
    % Generate coefficents
    A = M; %[ ones(length(M),1) M ];
    [ Q, R, E ] = qr(A,0); % QR Decompoistion
    basis = Q(:, E); % Reorder after QR 
    R = R(E, E); % Reorder after QR
    desired = ones(length(A), 1);
    coeff = basis \ desired; 
    
end