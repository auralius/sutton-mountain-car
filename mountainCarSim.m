function [pNext, vNext] = mountainCarSim(p, v, u)

    P_MIN = -1.2;
    P_MAX = 0.5;
    V_MIN = -0.07;
    V_MAX = 0.07;
    
    vNext = v + 0.001 * u - 0.0025 * cos(3 * p);
    
    % Apply boundary
    vNext = min(max(vNext, V_MIN), V_MAX);
    
    pNext = p + vNext;
    
    % Apply boundary
    pNext = min(max(pNext, P_MIN), P_MAX);
 
    % Inelastic wall on the left side
    if pNext <= P_MIN
        vNext = 0;
    end