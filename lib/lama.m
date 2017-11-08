function [ water, fat ] = lama( img1, img2, img3, img4, fieldMap, betaOffset)
% lama separates supplied images into a water and fat components

  im1 = img1; im2 = img3;
  beta = fieldMap/2 + betaOffset;
  
  water = im1 .* cos(beta) + im2 .* sin(beta);
  fat = im1 .* sin(beta) - im2 .* cos(beta);
end

