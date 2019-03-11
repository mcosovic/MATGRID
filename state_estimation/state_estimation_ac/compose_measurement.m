 function [sys, se] = compose_measurement(sys)

%--------------------------------------------------------------------------
% Builds data associated with all available measurements.
%
% The function defines the the total number of measurements, and forms
% vectors of measurement values and variances, and the diagonal weighted
% matrix.
%
%  Input:
%	- sys: power system data
%
%  Outputs:
%	- sys.Nleg: number of legacy measurements
%	- sys.Npmu: number of phasor measurements
%	- sys.Ntot: total number of measurements
%	- se.estimate with columns:
%	  (1)measurement values; (2)measurement variances
%	- sys.W: diagonal weighted matrix
%
% The local function which is used in the non-linear state estimation.
%--------------------------------------------------------------------------


%--------------------------Compose Measurements----------------------------
 sys.Nleg = sys.Pf.N + sys.Qf.N + sys.Cm.N + sys.Pi.N + sys.Qi.N + sys.Vml.N;
 sys.Npmu = sys.Vmp.N + sys.Vap.N + sys.Cmp.N + sys.Cap.N;
 sys.Ntot  = sys.Nleg + sys.Npmu;

 se.estimate = [sys.Pf.z; sys.Qf.z; sys.Cm.z; sys.Pi.z; sys.Qi.z; sys.Vml.z; ...
			   sys.Vmp.z; sys.Vap.z; sys.Cmp.z; sys.Cap.z];

 se.estimate(:,2) = [sys.Pf.v; sys.Qf.v; sys.Cm.v; sys.Pi.v; sys.Qi.v; sys.Vml.v; ...
					sys.Vmp.v; sys.Vap.v; sys.Cmp.v; sys.Cap.v];

 C = spdiags(se.estimate(:,2), 0, sys.Ntot, sys.Ntot);
 sys.W = C.^(1/2) \ speye(sys.Ntot, sys.Ntot);
%--------------------------------------------------------------------------