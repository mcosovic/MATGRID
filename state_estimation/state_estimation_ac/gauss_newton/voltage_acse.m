 function [Fv] = voltage_acse(V, T, ml, mp, ap)

%--------------------------------------------------------------------------
% Computes the line current magnitude and angles functions and
% corresponding Jacobian matrices.
%
% The function computes values of functions Iij(V,T) nad Fij(V,T) and a
% partial derivative of functions Iij and Fij with respect to bus voltage
% angles and magnitudes.
%--------------------------------------------------------------------------
%  Inputs:
%	- V: bus voltage magnitude vector
%	- T: bus voltage angle vector
%	- ml: indexes associated with legacy bus voltage magnitude
%	  measurements
%	- mp: indexes associated with PMU bus voltage magnitude
%	  measurements
%	- ap: indexes associated with PMU bus voltage angle
%	  measurements
%	- Nbu: number of buses
%
%  Output:
%	- Fv: vector associated with bus voltage measurement values
%--------------------------------------------------------------------------
% The local function which is used in the Gauss-Newton algorithm.
%--------------------------------------------------------------------------


%------------------Voltage Magnitude and Angle Function--------------------
 Fv = [V(ml); V(mp); T(ap)];
%--------------------------------------------------------------------------