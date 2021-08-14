%  This is the main file for the simulation.
clear 
close all
clc

%% Set simulation parameters.

% There is a minimum grid size here. Otherwise, traceBack function will 
% fail. Since the dynamic equation of the car is:
%    vNext = v + 0.001 * u - 0.0025 * cos(3 * p);
% When v(0) = 0, and cos(3p) = 0, u = 1, will result in vNext = 0.001. For 
% this reason, velocity grid should be finer that 0.001.

% Bigger number means finer grids
% We will create a grid/matrix, the row is for the discretized position and 
% the column is for the discretized velocity.
gridSizePos = 400;    
gridSizeVel = 400;    

% x0 holds the initial position and velocity;
% Select -0.6 to -0.4 for position. 
% Initial velocity shold be zero as described in the original problem.
x0 = [-0.52 0];
%x0 = [0.4 0];

%% Find optimal policy.
tic
[error, predecessorP, predecessorV, policy] = ...
    mountainCarValIter(gridSizePos, gridSizeVel, 1000);
toc

%% Trace back the optimal policy, for given a certain initial condition
[XStar, UStar, TStar] = ...
    traceBack(predecessorP, predecessorV, policy, x0, gridSizePos, gridSizeVel);

%% Animation
visualizeMountainCar(gridSizePos, XStar, UStar)

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