 function [sys] = compose_current(leg, pmu, sys, br)

%--------------------------------------------------------------------------
% Builds data associated with current measurements.
%
% The function defines the current measurement data according to available
% legacy and phasor measurements (i.e., turn on measurements).
%--------------------------------------------------------------------------
%  Inputs:
%	- leg: legacy current magnitude measurement data
%	- pmu: phasor current measurement data
%	- sys: power system data
%	- br: branch indexes and parameters
%
%  Outputs:
%	- sys.Cm: set indexes and parameters associated with legacy current
%	  magnitude measurements
%	- sys.Cmp: set indexes and parameters associated with phasor current
%	  magnitude measurements
%	- sys.Cap: set indexes and parameters associated with phasor current
%	  angle measurements
%--------------------------------------------------------------------------
% The local function which is used in the non-linear state estimation.
%--------------------------------------------------------------------------


%---------------Line Current Magnitude Legacy Measurements-----------------
 sys.Cm.idx = logical(leg(:,5));
 sys.Cm.i   = br.i(sys.Cm.idx);
 sys.Cm.j   = br.j(sys.Cm.idx);
 sys.Cm.z   = leg(sys.Cm.idx,3);
 sys.Cm.v   = leg(sys.Cm.idx,4);
 sys.Cm.N   = size(sys.Cm.i,1);

 sys.Cm.A   = br.tij(sys.Cm.idx).^4 .* (br.gij(sys.Cm.idx).^2 + (br.bij(sys.Cm.idx) + br.bsi(sys.Cm.idx)).^2);
 sys.Cm.B   = br.pij(sys.Cm.idx).^2 .* (br.gij(sys.Cm.idx).^2 + br.bij(sys.Cm.idx).^2);
 sys.Cm.C   = br.tij(sys.Cm.idx).^2 .* br.pij(sys.Cm.idx) .* (br.gij(sys.Cm.idx).^2 + br.bij(sys.Cm.idx) .* (br.bij(sys.Cm.idx) + br.bsi(sys.Cm.idx)));
 sys.Cm.D   = br.tij(sys.Cm.idx).^2 .* br.pij(sys.Cm.idx) .* br.gij(sys.Cm.idx) .* br.bsi(sys.Cm.idx);
 sys.Cm.fij = br.fij(sys.Cm.idx);

 num = (1:sys.Cm.N)';
 sys.Cm.jci = [num; num];
 sys.Cm.jcj = [sys.Cm.i; sys.Cm.j];
%--------------------------------------------------------------------------


%---------------Line Current Magnitude Phasor Measurements-----------------
 sys.Cmp.idx = logical(pmu(:,5));
 sys.Cmp.i   = br.i(sys.Cmp.idx);
 sys.Cmp.j   = br.j(sys.Cmp.idx);
 sys.Cmp.z   = pmu(sys.Cmp.idx,3);
 sys.Cmp.v   = pmu(sys.Cmp.idx,4);
 sys.Cmp.N   = size(sys.Cmp.i,1);

 sys.Cmp.A   = br.tij(sys.Cmp.idx).^4 .* (br.gij(sys.Cmp.idx).^2 + (br.bij(sys.Cmp.idx) + br.bsi(sys.Cmp.idx)).^2);
 sys.Cmp.B   = br.pij(sys.Cmp.idx).^2 .* (br.gij(sys.Cmp.idx).^2 + br.bij(sys.Cmp.idx).^2);
 sys.Cmp.C   = br.tij(sys.Cmp.idx).^2 .* br.pij(sys.Cmp.idx) .* (br.gij(sys.Cmp.idx).^2 + br.bij(sys.Cmp.idx) .* (br.bij(sys.Cmp.idx) + br.bsi(sys.Cmp.idx)));
 sys.Cmp.D   = br.tij(sys.Cmp.idx).^2 .* br.pij(sys.Cmp.idx) .* br.gij(sys.Cmp.idx) .* br.bsi(sys.Cmp.idx);
 sys.Cmp.fij = br.fij(sys.Cmp.idx);

 num = (1:sys.Cmp.N)';
 sys.Cmp.jci = [num; num];
 sys.Cmp.jcj = [sys.Cmp.i; sys.Cmp.j];
%--------------------------------------------------------------------------


%-----------------Line Current Angle Phasor Measurements-------------------
 sys.Cap.idx = logical(pmu(:,8));
 sys.Cap.i   = br.i(sys.Cap.idx);
 sys.Cap.j   = br.j(sys.Cap.idx);
 sys.Cap.z   = pmu(sys.Cap.idx,6);
 sys.Cap.v   = pmu(sys.Cap.idx,7);
 sys.Cap.N   = size(sys.Cap.i,1);

 sys.Cap.Aa  = br.tij(sys.Cap.idx).^2 .* br.gij(sys.Cap.idx);
 sys.Cap.Ba  = br.tij(sys.Cap.idx).^2 .* (br.bij(sys.Cap.idx) + br.bsi(sys.Cap.idx));
 sys.Cap.Ca  = br.pij(sys.Cap.idx) .* br.gij(sys.Cap.idx);
 sys.Cap.Da  = br.pij(sys.Cap.idx) .* br.bij(sys.Cap.idx);
 sys.Cap.Ac  = br.tij(sys.Cap.idx).^4 .* (br.gij(sys.Cap.idx).^2 + (br.bij(sys.Cap.idx) + br.bsi(sys.Cap.idx)).^2);
 sys.Cap.Bc  = br.pij(sys.Cap.idx).^2 .* (br.gij(sys.Cap.idx).^2 + br.bij(sys.Cap.idx).^2);
 sys.Cap.Cc  = br.tij(sys.Cap.idx).^2 .* br.pij(sys.Cap.idx) .* (br.gij(sys.Cap.idx).^2 + br.bij(sys.Cap.idx) .* (br.bij(sys.Cap.idx) + br.bsi(sys.Cap.idx)));
 sys.Cap.Dc  = br.tij(sys.Cap.idx).^2 .* br.pij(sys.Cap.idx) .* br.gij(sys.Cap.idx) .* br.bsi(sys.Cap.idx);
 sys.Cap.fij = br.fij(sys.Cap.idx);

 num = (1:sys.Cap.N)';
 sys.Cap.jci = [num; num];
 sys.Cap.jcj = [sys.Cap.i; sys.Cap.j];
%--------------------------------------------------------------------------