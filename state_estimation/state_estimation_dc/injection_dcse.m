 function [ai] = injection_dcse(injection, se)

%--------------------------------------------------------------------------
% Builds data associated with active power injection measurements for the
% DC state estimation
%
% The function defines the active power injection measurement data
% according to available measurements (i.e., turn on measurements).
%--------------------------------------------------------------------------
%  Inputs:
%	- injection: legacy power injection measurement data
%	- se: state estimation system data
%
%  Outputs:
%	- ai.on: measurement set (logical indexes)
%	- ai.z: measurement values
%	- ai.v: measurement variances
%	- ai.n: number of measurements
%	- ai.bus: bus indexes
%	- ai.H: Jacobian matrix
%	- ai.b: vector of the shift measurement values
%	- ai.W: weighting matrix
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-04-01
% Last revision by Mirsad Cosovic on 2019-04-20
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-----------------------------Measurement Set------------------------------
 ai.on = logical(injection(:,4));
%--------------------------------------------------------------------------


%----------------------------Measurement Data------------------------------
 ai.z = injection(ai.on,2);
 ai.v = injection(ai.on,3);
 ai.n = sum(ai.on);

 ai.bus = se.bus(ai.on,1);
%--------------------------------------------------------------------------


%------------------------------System Model--------------------------------
 ai.H = se.Ybu(ai.on,:);
 ai.b = ai.z - se.psh(ai.on);
 ai.W = spdiags(1 ./ ai.v, 0, ai.n, ai.n);
%--------------------------------------------------------------------------