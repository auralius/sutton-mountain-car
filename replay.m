% This function will replay the animation without re-doing all the
% calculations.

%% Animation, warning: this will close all opened figures.
close all;
visualizeMountainCar(gridPos, XStar, UStar);

%% Plot errors over iterations.
figure
plot(error);
title('Convergence errors over iterations');

%% Plot the policy matrix.
figure
imagesc(policy)
title('Policy matrix')
xlabel('Position');
ylabel('Velocity');