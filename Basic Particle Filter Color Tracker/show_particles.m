function show_particles(X, Y_k)

figure(1)
image(Y_k)
title('+++ Showing Particles +++')

hold on
plot(X(1,:), X(2,:), '.')
hold off

drawnow
