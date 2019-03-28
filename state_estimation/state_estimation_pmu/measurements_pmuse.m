 function [data, sys] = measurements_pmuse(data, sys, br)

%--------------------------------------------------------------------------
% Builds the measurement data for the PMU state estimation, and forms the
% system model.
%
% The function defines measurement data according to available measurements
% (turn off measurements are removed), where the corresponding Jacobian
% matrix is defined, with associated vectors.
%--------------------------------------------------------------------------
%  Inputs:
%	- data: input power system data with measurements
%	- sys: power system data
%	- br: branch indexes and parameters
%
%  Outputs:
%	- data.pmu.current with additional column:
%	  (11)indexes of branches that agree with sys.branch
%	- data.pmu.voltage with additional column:
%	  (10)indexes of buses that agree with sys.bus
%	- data.pmu.voltage with additional column:
%	  (10)indexes of buses that agree with sys.bus
%	- sys.H, sys.b, sys.v: matrix and vector of the system model
%	- sys.Nv: number of complex bus voltage measurements
%	- sys.Nc: number of complex line current measurements
%	- sys.Nti: number of voltage angle measurements
%	- sys.Nleg: number of legacy measurements
%	- sys.Npmu: number of phasor measurements
%	- sys.Ntot: total number of measurements
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-05
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-----------------------Current Phasor Measurements------------------------
 fix = logical(data.pmu.current(:,5));

 data.pmu.current(~fix,:) = [];
 data.pmu.current = [data.pmu.current br.no(fix,1)];
 sys.Nc = size(data.pmu.current,1);

 c = [(1:sys.Nc)'; (1: sys.Nc)'];
 r = [br.i(fix); br.j(fix)];
%--------------------------------------------------------------------------


%--------------Jacobians of the Current Phasor Measurements----------------
 Jcr_vir = br.tij(fix).^2 .* br.gij(fix);
 Jcr_vjr = -br.pij(fix) .* (br.gij(fix) .* cos(br.fij(fix)) - br.bij(fix) .* sin(br.fij(fix)));
 Jcr_vr = sparse(c,r, [Jcr_vir; Jcr_vjr], sys.Nc, sys.Nbu);

 Jcr_vii = -br.tij(fix).^2 .* (br.bij(fix) + br.bsi(fix));
 Jcr_vji = br.pij(fix) .* (br.bij(fix) .* cos(br.fij(fix)) + br.gij(fix) .* sin(br.fij(fix)));
 Jcr_vi  = sparse(c,r, [Jcr_vii; Jcr_vji], sys.Nc, sys.Nbu);

 Jci_vir = br.tij(fix).^2 .* (br.bij(fix) + br.bsi(fix));
 Jci_vjr = -br.pij(fix) .* (br.bij(fix) .* cos(br.fij(fix)) + br.gij(fix) .* sin(br.fij(fix)));
 Jci_vr = sparse(c,r, [Jci_vir; Jci_vjr], sys.Nc, sys.Nbu);

 Jci_vii = br.tij(fix).^2 .* br.gij(fix);
 Jci_vji = -br.pij(fix) .* (br.gij(fix) .* cos(br.fij(fix)) - br.bij(fix) .* sin(br.fij(fix)));
 Jci_vi  = sparse(c,r, [Jci_vii; Jci_vji], sys.Nc, sys.Nbu);
%--------------------------------------------------------------------------


%-----------------------Voltage Phasor Measurements------------------------
 fix = logical(data.pmu.voltage(:,4));

 data.pmu.voltage(~fix,:) = [];
 data.pmu.voltage = [data.pmu.voltage sys.bus(fix,1)];

 sys.Nv = size(data.pmu.voltage,1);
%--------------------------------------------------------------------------


%--------------Jacobians of the Voltage Phasor Measurements----------------
 idx = data.pmu.voltage(:,14);
 Jvr = sparse((1:sys.Nv)', idx, 1, sys.Nv, 2*sys.Nbu);
 Jvi = sparse((1:sys.Nv)', idx+ sys.Nbu, 1, sys.Nv, 2*sys.Nbu);
%--------------------------------------------------------------------------


%------------------------------System Model--------------------------------
 sys.Npmu = 2*sys.Nc + 2*sys.Nv;
 sys.Ntot = sys.Npmu;
 sys.Nleg = 0;

 sys.b = [data.pmu.voltage(:,10); data.pmu.current(:,11)
          data.pmu.voltage(:,12); data.pmu.current(:,13)];

 sys.v = [data.pmu.voltage(:,11); data.pmu.current(:,12) 
          data.pmu.voltage(:,13); data.pmu.current(:,14)];

 sys.H = [Jvr; Jcr_vr Jcr_vi; Jvi; Jci_vr Jci_vi];
%--------------------------------------------------------------------------