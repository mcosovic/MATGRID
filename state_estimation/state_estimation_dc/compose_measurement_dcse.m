 function [sys, se] = compose_measurement_dcse(sys, se)

%--------------------------------------------------------------------------
% Builds data associated with all available measurements.
%
% The function defines the the total number of measurements, and forms
% vectors of measurement values and variances, and the diagonal weighted
% matrix.
%--------------------------------------------------------------------------
%  Input:
%	- sys: power system data
%
%  Outputs:
%	- sys.Nleg: number of legacy measurements
%	- sys.Npmu: number of phasor measurements
%	- sys.Ntot: total number of measurements
%	- se.estimate with columns:
%	  (1)measurement values; (2)measurement variances
%	- sys.b, sys.H: matrix and vector of the system model
%	- sys.W: diagonal weighted matrix
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-01-04
% Last revision by Mirsad Cosovic on 2019-01-04
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%--------------------------Compose Measurements----------------------------
 sys.Nleg = sys.Pf.N + sys.Pi.N;
 sys.Npmu = sys.Vap.N;
 sys.Ntot = sys.Nleg + sys.Npmu;

 se.estimate = [sys.Pf.z; sys.Pi.z; sys.Vap.z];
 se.estimate(:,2) = [sys.Pf.v; sys.Pi.v; sys.Vap.v];
%--------------------------------------------------------------------------


%------------------------------System Model--------------------------------
 Hf = sparse(sys.Pf.jci, sys.Pf.jcj, [sys.Pf.cof; -sys.Pf.cof], sys.Pf.N, sys.Nbu);
 Hi = sys.Ybu(sys.Pi.idx,:);
 Hv = sparse((1:sys.Vap.N)', sys.Vap.i, 1, sys.Vap.N, sys.Nbu);
 
 sys.H = [Hf; Hi; Hv];
 sys.b = se.estimate(:,1) - [sys.Pf.fij; sys.Pi.Psh; sys.sck(2) * ones(sys.Vap.N,1)];
 sys.C = spdiags(se.estimate(:,2), 0, sys.Ntot, sys.Ntot);
 sys.W = sys.C \ speye(sys.Ntot, sys.Ntot);
%--------------------------------------------------------------------------