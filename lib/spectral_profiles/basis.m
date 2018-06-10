function [ Q ] = basis(A)
    A = [ ones(size(A(:,1))) A ];
    [ Q,~ ] = qr(A,0);
%     Q = A;
end