function visualizeMountainCar(gridPos, XStar, UStar)

% This function will do visualization and animation of the mountain car.

close all; % Warning, this will close all figures!

P_MIN = -1.2;
P_MAX = 0.5;

p = P_MIN: (P_MAX - P_MIN) / gridPos : P_MAX;

%% Preparation for graphical components

% Draw y = sine(3p)to representate a mountain
hfig = figure;
hold on;
plot(p, sin(3 * p));    

set(gca, 'YTickLabel', [ ]); 

% Text labels to show current input and simulation time.
lblTime = uicontrol('style','text');
lblAction = uicontrol('style','text');
set(lblTime,'Position', [10 20 40 20]);
set(lblAction,'Position', [10 50 40 20]);

%% Animate the car
car = plot(0,0, 'or', 'LineWidth', 4);

for index = 1 : length(XStar)
    set(car, 'XData', XStar(index, 1));
    
    % Plug the XStar to the equation of the mountain
    set(car, 'YData', sin(3 *XStar(index, 1))); 
    
    set(lblTime,'String', index - 1);
    set(lblAction,'String', UStar(index));
    
    drawnow;
    write2gif(hfig, index, "animation.gif");
    %pause(0.1);
end

%% Plot the results.
figure;
hold on;

subplot(3,1,1);
plot(XStar(:,1));
title('Optimal positions over time');

subplot(3,1,2);
plot(XStar(:,2));
title('Optimal velocities over time');

subplot(3,1,3);
plot(UStar);
title('Optimal inputs over time');

end