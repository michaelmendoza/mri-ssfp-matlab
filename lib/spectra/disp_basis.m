function [ h ] = disp_basis(Q,titl)
    h = figure;
    title(titl);
    N = size(Q,2);
    for k = 1:N
        subplot(N,1,k);
        plot(abs(Q(:,k)));
    end
end