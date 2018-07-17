

function plot_data(im_sim, f_sim, sim_basis, f_sim_approx_coeff, Ns)

figure;
imshow(abs(im_sim(384:640, :)'),[]);
title('Simulated Filtered');

figure;
plot(mean(abs(im_sim(384:640, 118:138)), 2));

end



