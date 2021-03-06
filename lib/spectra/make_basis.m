function [ Q ] = make_basis(A)
    % Append constant function to beginning of A
    A = [ ones(size(A,1),1) A ];
    % QR decomposition gives orthonormal Q identical to that generated by
    % Gram-Schmidt algorithm.  Some sources say this is more robust than
    % using the generic GS algorithm - see
    % https://blogs.mathworks.com/cleve/2016/07/25/compare-gram-schmidt-and-householder-orthogonalization-algorithms/
    [Q,~] = qr(A,0);
end