 function [se] = system_data_dcse(se)

%--------------------------------------------------------------------------
% Builds the global branch indexes and parameters for the DC state
% estimation.
%
% The function defines branch and bus indexes and parameters that are used
% for the DC state estimation.
%--------------------------------------------------------------------------
%  Input:
%	- se: state estimation system data
%
%  Outputs:
%	- se.from: from bus ends
%	- se.to: to bus ends
%	- se.bij: coefficients [1/(tij*xij); 1/(tij*xij)]
%	- se.fij: transformer phase shift angle [fij -fij]
%	- se.psh: power injection shift vector
%	- se.ts: voltage angle slack bus shift vector
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2018-04-01
% Last revision by Mirsad Cosovic on 2019-04-20
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%------------------------DC State Estimation Data--------------------------
 se.from = [se.branch(:,2); se.branch(:,3)];
 se.to   = [se.branch(:,3); se.branch(:,2)];
 se.bij  = [se.branch(:,11); se.branch(:,11)];
 se.fij  = [se.branch(:,8); -se.branch(:,8)];
 se.psh  = se.bus(:,16);
 se.ts   = se.sck(2) * ones(se.Nbu,1);
%--------------------------------------------------------------------------