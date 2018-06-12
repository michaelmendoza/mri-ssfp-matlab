function [ Q,R,E ] = basis(A)
    A = [ ones(size(A(:,1))) A ];
    [ Q,R,E ] = qr(A,0);
%     Q = A;
end