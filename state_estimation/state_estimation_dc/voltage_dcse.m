 function [va] = voltage_dcse(voltage, se)

%--------------------------------------------------------------------------
% Builds data associated with voltage angle measurements for the DC state
% estimation
%
% The function defines the voltage angle measurement data according to
% available measurements (i.e., turn on measurements).
%--------------------------------------------------------------------------
%  Inputs:
%	- voltage: PMU voltage angle measurement data
%	- se: state estimation system data
%
%  Outputs:
%	- va.on: measurement set (logical indexes)
%	- va.z: measurement values
%	- va.v: measurement variances
%	- va.n: number of measurements
%	- va.bus: bus indexes
%	- va.H: Jacobian matrix
%	- va.b: vector of the shift measurement values
%	- va.W: weighting matrix
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-04-01
% Last revision by Mirsad Cosovic on 2019-04-20
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-----------------------------Measurement Set------------------------------
 va.on = logical(voltage(:,7));
%--------------------------------------------------------------------------


%----------------------------Measurement Data------------------------------
 va.z = voltage(va.on,5);
 va.v = voltage(va.on,6);
 va.n = sum(va.on);

 va.bus = se.bus(va.on,1);
%--------------------------------------------------------------------------


%------------------------------System Model--------------------------------
 va.H = sparse((1:va.n)', va.bus, 1, va.n, se.Nbu);
 va.b = va.z - se.ts(va.on);
 va.W = spdiags(1 ./ va.v, 0, va.n, va.n);
%--------------------------------------------------------------------------