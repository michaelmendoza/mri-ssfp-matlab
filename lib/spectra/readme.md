## Generation of Arbitrary Spectra

There are two main files:

1. simulate_test.m
2. meas_test.m

# simulate_test.m
Runs the ssfp simulations for both sinusoidal and castle-like spectra and gives coefficients to approximate both a centered pulse and offcenter pulse.

# meas_test.m
Loads in a dataset from a specified directory, allows you to choose the patch, and gives coefficients for a centered pulse and offcenter pulse.  Right now, the spectra only work with magnitude data and the spectra are found by taking a slice down the center of the patch.
