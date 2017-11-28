%% Generate a centered pulse
function [ v ] = center_pulse(len)
    v = zeros(len,1);
    v(floor(len/3):end-floor(len/3)) = 1;
end