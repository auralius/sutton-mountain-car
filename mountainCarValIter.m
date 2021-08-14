function [error, predecessorP, predecessorV, policy] = mountainCarValIter ...
    (gridSizePos, gridSizeVel, maxHorizon)

% This function will do the value iteration process to find the optimal
% policy.

P_MIN = -1.2;
P_MAX = 0.5;
V_MIN = -0.07;
V_MAX = 0.07;

% Very small number
EPSILON = 1E-6;

% Grid size of 3 means the grid consists of: 0 - 1 - 2 - 3, we must add 1
nPosStates = gridSizePos + 1;
nVelStates = gridSizeVel + 1;

posGridStep = (P_MAX - P_MIN) / gridSizePos;
velGridStep = (V_MAX - V_MIN) / gridSizeVel;

% Create J matrix
% row -> position
% column -> velocity
J = zeros(gridSizePos + 1, gridSizeVel + 1);

% Policy matrix
policy = zeros(gridSizePos + 1, gridSizeVel + 1);

u = [0, -1, 1]; % <-- '0' comes first, keep in mind that optimal 
% policy is not unique eventhough the cost is unique. If all actions
% contribute to the same costs, we will select u = 0.

% Value iteration starts here
predecessorP = zeros(gridSizePos + 1, gridSizeVel + 1);
predecessorV = zeros(gridSizePos + 1, gridSizeVel + 1);
error = zeros(maxHorizon);

fprintf('value iteration is running...\n');

for k = 1 : maxHorizon
    
    Jprev = J;
    
    for vIdx = 1 : nVelStates
        for pIdx = 1 : nPosStates
            
            % Convert index back to actual value
            p = (pIdx - 1) * posGridStep + P_MIN;  
            v = (vIdx - 1) * velGridStep + V_MIN;

            Jplus1 = inf;
            
            for uIdx = 1 : length(u)
                % Given current input u, find next state information
                [pNext, vNext] =  mountainCarSim(p, v, u(uIdx));
                pNextIdx = snapToGrid(pNext, P_MIN, P_MAX, gridSizePos);
                vNextIdx = snapToGrid(vNext, V_MIN, V_MAX, gridSizeVel);
                
                Jplus1_ =  J(pNextIdx, vNextIdx);
                        
                % Stage cost everywhere is +1 except at the target 
                if pNextIdx ~= gridSizePos + 1
                    Jplus1_ = Jplus1_ + 1;
                end
                        
                % Get the smallest one
                if Jplus1_ < Jplus1
                    Jplus1 = Jplus1_;
                    uMinIdx = uIdx;
                    pMinNextIdx = pNextIdx;
                    vMinNextIdx = vNextIdx;
                end
                   
            end % end for uIdx
            
            J(pIdx, vIdx) = Jplus1;
            policy(pIdx, vIdx) = u(uMinIdx);
            
            % Store the currrnt optimal node
            predecessorP(pIdx, vIdx) = pMinNextIdx;
            predecessorV(pIdx, vIdx) = vMinNextIdx;
            
        end % end for vIdx
    end % end for pIdx
    
    error(k) = norm(J - Jprev);
    fprintf('episode: %i, error: %f\n', k, error(k));
    
    if (error(k) < EPSILON)
        fprintf('converged with error = %f after %i episodes\n', ... 
            error(k), k);
        break;
    end
    
end % end for k

% Resize vector error.
error = error(1 : k);