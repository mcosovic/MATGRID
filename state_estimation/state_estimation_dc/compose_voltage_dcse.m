 function [sys] = compose_voltage_dcse(pmu, sys)

%--------------------------------------------------------------------------
% Builds data associated with angle voltage measurements for the DC state
% estimation.
%
% The function defines the angle voltage measurement data according to
% available measurements (i.e., turn on measurements).
%--------------------------------------------------------------------------
%  Inputs:
%	- pmu: phasor voltage measurement data
%	- sys: power system data
%
%  Outputs:
%	- sys.Vap: set indexes and parameters associated with phasor voltage
%	  angle measurements
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-04-01
% Last revision by Mirsad Cosovic on 2019-04-01
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%---------------------Voltage Angle PMU Measurements-----------------------
 sys.Vap.idx = logical(pmu(:,7));
 sys.Vap.i   = sys.bus(sys.Vap.idx,1);
 sys.Vap.z   = pmu(sys.Vap.idx,5);
 sys.Vap.v   = pmu(sys.Vap.idx,6);
 sys.Vap.N   = size(sys.Vap.i,1);
%--------------------------------------------------------------------------