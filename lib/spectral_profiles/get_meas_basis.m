function [ Q,Ms,R,E ] = get_meas_basis(imData,meas_smoothing_span)

    % Here's the idea:
    % Grab a reasonable portion of the image given by bnds.  Then remove
    % the background image by subtracting the root sum of squares recon,
    % then you are left with just the bssfp profile for each TR - exactly
    % what we wanted.
    
    % Find the bounds using edge detection
    BW = edge(abs(imData(:,:,1)));
    rows = sum(BW,2);
    idx = find(rows);
    bnds = [ idx(1) idx(end) ];
    Ms = bnds(2) - bnds(1);

    % Root sum of squares
    im = rssq(imData,3);

    M = zeros(Ms,size(imData,3));
    for ii = 1:size(imData,3)
        M(:,ii) = imData(bnds(1):bnds(2)-1,end/2,ii) - im(bnds(1):bnds(2)-1,end/2);
        M(:,ii) = smooth(M(:,ii),meas_smoothing_span,'rloess');
    end
    
%     A = basis(abs(M));
    [ Q,R,E ] = basis(M);
end