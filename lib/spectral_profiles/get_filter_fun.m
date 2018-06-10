function [ f ] = get_filter_fun(filter_fun,w)

    if strcmp(filter_fun,'pass')
        f = ones(w,1);
    elseif strcmp(filter_fun,'square')
        f = zeros(w,1);
        f(floor(w/2)-floor(w/8):floor(w/2)+floor(w/8)) = 1;
    elseif strcmp(filter_fun,'square_offset')
        f = zeros(w,1);
        f(floor(w/4)-floor(w/8):floor(w/4)+floor(w/8)) = 1;
    elseif strcmp(filter_fun,'notch')
        x_sig = linspace(-4,4,w/4);
        f = exp(x_sig)./(exp(x_sig) + 1);
        f = 1 - [f fliplr(f)] + min(f);
        f = [ones(1,floor(w/4)) f ones(1,floor(w/4))];
    elseif strcmp(filter_fun,'notch_offset')
        x_sig = linspace(-4,4,w/4);
        f = exp(x_sig)./(exp(x_sig) + 1);
        f = 1 - [f fliplr(f)] + min(f);
        f = [ones(1,floor(w/4)) f ones(1,floor(w/4))];
        f = circshift(f,floor(w/4));
    elseif strcmp(filter_fun,'guassian_notch')
        f = ones(w,1);
        idx = floor(w/3):floor(2*w/3);
        gaus = gausswin(length(idx));
        % gaus = normpdf(linspace(-3,3,length(idx)),0,6);
        f(idx) = f(idx) - gaus + min(gaus);
    end
    
    f = f(:);
end