function [XStar, UStar, TStar] = traceBack(predecessorP, predecessorV, ...
    policy, x0, gridSizePos, gridSizeVel)

% This function will trace back the predecessor and the policy matrix for
% the given inital state. 

P_MIN = -1.2;
P_MAX = 0.5;
V_MIN = -0.07;
V_MAX = 0.07;

p = x0(1);
v = x0(2);

index = 1;

% Start from initial condition
pIdx = snapToGrid(p, P_MIN, P_MAX, gridSizePos);
vIdx = snapToGrid(v, V_MIN, V_MAX, gridSizeVel);

while(1)
    XStar(index, :) = [p v];
    UStar(index) = policy(pIdx, vIdx);
    
    pPredIdx = predecessorP(pIdx, vIdx);
    vPredIdx = predecessorV(pIdx, vIdx);
    
    if (pPredIdx == gridSizePos + 1)
        XStar(index, :) = [p v];
        UStar(index) = policy(pIdx, vIdx);
    
        break;
    end
    
    % Convert index back to actual value
    p = (pPredIdx - 1) / gridSizePos * (P_MAX - P_MIN) + P_MIN;  
    v = (vPredIdx - 1) / gridSizeVel * (V_MAX - V_MIN) + V_MIN;
    
    index = index + 1;
    
    pIdx = pPredIdx;
    vIdx = vPredIdx;
    
end

TStar = index - 1;