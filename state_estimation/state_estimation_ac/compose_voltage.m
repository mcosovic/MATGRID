 function [sys] = compose_voltage(leg, pmu, sys)

%--------------------------------------------------------------------------
% Builds data associated with voltage measurements, and forms associated
% Jacobian matrix.
%
% The function defines the voltage measurement data according to available
% legacy and phasor measurements (i.e., turn on measurements).
%--------------------------------------------------------------------------
%  Inputs:
%	- leg: legacy voltage magnitude measurement data
%	- pmu: phasor voltage measurement data
%	- sys: power system data
%
%  Outputs:
%	- sys.Vml: set indexes and parameters associated with legacy voltage
%	  magnitude measurements
%	- sys.Vmp: set indexes and parameters associated with phasor voltage
%	  magnitude measurements
%	- sys.Vap: set indexes and parameters associated with phasor voltage
%	  angle measurements
%	- sys.Jvol: Jacobian matrix associated with voltage measurements
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-02-26
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%------------------Voltage Magnitude Legacy Measurements-------------------
 sys.Vml.idx = logical(leg(:,4));
 sys.Vml.i   = sys.bus(sys.Vml.idx,1);
 sys.Vml.z   = leg(sys.Vml.idx, 2);
 sys.Vml.v   = leg(sys.Vml.idx, 3);
 sys.Vml.N   = size(sys.Vml.i,1);
%--------------------------------------------------------------------------


%-------------------Voltage Magnitude PMU Measurements---------------------
 sys.Vmp.idx = logical(pmu(:,4));
 sys.Vmp.i   = sys.bus(sys.Vmp.idx,1);
 sys.Vmp.z   = pmu(sys.Vmp.idx,2);
 sys.Vmp.v   = pmu(sys.Vmp.idx,3);
 sys.Vmp.N   = size(sys.Vmp.i,1);
%--------------------------------------------------------------------------


%---------------------Voltage Angle PMU Measurements-----------------------
 sys.Vap.idx = logical(pmu(:,7));
 sys.Vap.i   = sys.bus(sys.Vap.idx,1);
 sys.Vap.z   = pmu(sys.Vap.idx,5);
 sys.Vap.v   = pmu(sys.Vap.idx,6);
 sys.Vap.N   = size(sys.Vap.i,1);
%--------------------------------------------------------------------------


%------------------Voltage Magnitude and Angle Jacobian--------------------
 Vleg_V = sparse((1:sys.Vml.N)', sys.Vml.i, 1, sys.Vml.N, sys.Nbu);
 Vleg_T = sparse(sys.Vml.N, sys.Nbu);

 Vpmu_V = sparse((1:sys.Vmp.N)', sys.Vmp.i, 1, sys.Vmp.N, sys.Nbu);
 Vpmu_T = sparse(sys.Vmp.N, sys.Nbu);

 Tpmu_V = sparse(sys.Vap.N, sys.Nbu);
 Tpmu_T = sparse((1:sys.Vap.N)', sys.Vap.i, 1, sys.Vap.N, sys.Nbu);

 sys.Jv = [Vleg_T Vleg_V; Vpmu_T Vpmu_V; Tpmu_T Tpmu_V];
%--------------------------------------------------------------------------