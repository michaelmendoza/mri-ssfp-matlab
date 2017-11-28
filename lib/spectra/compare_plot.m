%% Plot two spectra on top of each other with a title
function h = compare_plot(one, two, titl)
    h = figure;
    plot(one);
    hold on;
    plot(two);
    hold off;
    title(titl);
end