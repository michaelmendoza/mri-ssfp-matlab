function [ f ] = get_filter_fun(filter_fun, w)

    if strcmp(filter_fun,'pass')
        f = ones(w,1);
    elseif strcmp(filter_fun,'square')
        f = zeros(w,1);
        f(floor(w/2)-floor(w/16):floor(w/2)+floor(w/16)) = 1;
    elseif strcmp(filter_fun,'square_offset')
        f = zeros(w,1);
        f(floor(w/4)-floor(w/16):floor(w/4)+floor(w/16)) = 1;
    elseif strcmp(filter_fun,'notch')
        x_sig = linspace(-4,4,w/8);
        f = exp(x_sig)./(exp(x_sig) + 1);
        f = 1 - [f fliplr(f)] + min(f);
        f = [ones(1,floor(3*w/8)) f ones(1,floor(3*w/8))];
    elseif strcmp(filter_fun,'notch_offset')
        x_sig = linspace(-4,4,w/8);
        f = exp(x_sig)./(exp(x_sig) + 1);
        f = 1 - [f fliplr(f)] + min(f);
        f = [ones(1,floor(3*w/8)) f ones(1,floor(3*w/8))];
        f = [f ones(1, w - length(f))];
        f = circshift(f,floor(w/4));
    elseif strcmp(filter_fun,'notch_offset_2')
        x_sig = linspace(-4,4,w/8);
        f = exp(x_sig)./(exp(x_sig) + 1);
        f = 1 - [f fliplr(f)] + min(f);
        f = [ones(1,floor(3*w/8)) f ones(1,floor(3*w/8))];
        f = [f ones(1, w - length(f))];
        f = circshift(f,floor(w/4));    
        f2 = zeros(1, length(f));
        for ii = 1:length(f)
            f2(ii) = f(length(f) - ii + 1);
        end
        f = f2;
    elseif strcmp(filter_fun,'guassian_notch')
        f = ones(w,1);
        idx = floor(w/3):floor(2*w/3);
        gaus = gausswin(length(idx));
        % gaus = normpdf(linspace(-3,3,length(idx)),0,6);
        f(idx) = f(idx) - gaus + min(gaus);
    end
    
    f = f(:);
end