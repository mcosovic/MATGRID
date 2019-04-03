 function [sys] = compose_injection_dcse(inj, sys)

%--------------------------------------------------------------------------
% Builds data associated with active power injection measurements for the
% DC state estimation.
%
% The function defines the active power injection measurement data
% according to available measurements (i.e., turn on measurements).
%--------------------------------------------------------------------------
%  Inputs:
%	- inj: legacy power injection measurement data
%	- sys: power system data
%
%  Outputs:
%	- sys.Pi: set indexes and parameters associated with active power
%	  injection measurements
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-04-01
% Last revision by Mirsad Cosovic on 2019-04-01
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%---------------Active Power Injection Legacy Measurements-----------------
 sys.Pi.idx = logical(inj(:,4));
 sys.Pi.z   = inj(sys.Pi.idx,2);
 sys.Pi.v   = inj(sys.Pi.idx,3);
 sys.Pi.N   = size(sys.Pi.z,1);
 sys.Pi.Psh = sys.bus(sys.Pi.idx,16);
%--------------------------------------------------------------------------