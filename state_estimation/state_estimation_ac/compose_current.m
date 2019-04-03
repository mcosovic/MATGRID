 function [sys] = compose_current(leg, pmu, sys, bra)

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
%	- bra: branch indexes and parameters
%
%  Outputs:
%	- sys.Cm: set indexes and parameters associated with legacy current
%	  magnitude measurements
%	- sys.Cmp: set indexes and parameters associated with phasor current
%	  magnitude measurements
%	- sys.Cap: set indexes and parameters associated with phasor current
%	  angle measurements
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-02-26
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%---------------Line Current Magnitude Legacy Measurements-----------------
 sys.Cm.idx = logical(leg(:,5));
 sys.Cm.i   = bra.i(sys.Cm.idx);
 sys.Cm.j   = bra.j(sys.Cm.idx);
 sys.Cm.z   = leg(sys.Cm.idx,3);
 sys.Cm.v   = leg(sys.Cm.idx,4);
 sys.Cm.N   = size(sys.Cm.i,1);

 sys.Cm.A   = bra.tij(sys.Cm.idx).^4 .* (bra.gij(sys.Cm.idx).^2 + (bra.bij(sys.Cm.idx) + bra.bsi(sys.Cm.idx)).^2);
 sys.Cm.B   = bra.pij(sys.Cm.idx).^2 .* (bra.gij(sys.Cm.idx).^2 + bra.bij(sys.Cm.idx).^2);
 sys.Cm.C   = bra.tij(sys.Cm.idx).^2 .* bra.pij(sys.Cm.idx) .* (bra.gij(sys.Cm.idx).^2 + bra.bij(sys.Cm.idx) .* (bra.bij(sys.Cm.idx) + bra.bsi(sys.Cm.idx)));
 sys.Cm.D   = bra.tij(sys.Cm.idx).^2 .* bra.pij(sys.Cm.idx) .* bra.gij(sys.Cm.idx) .* bra.bsi(sys.Cm.idx);
 sys.Cm.fij = bra.fij(sys.Cm.idx);

 num = (1:sys.Cm.N)';
 sys.Cm.jci = [num; num];
 sys.Cm.jcj = [sys.Cm.i; sys.Cm.j];
%--------------------------------------------------------------------------


%---------------Line Current Magnitude Phasor Measurements-----------------
 sys.Cmp.idx = logical(pmu(:,5));
 sys.Cmp.i   = bra.i(sys.Cmp.idx);
 sys.Cmp.j   = bra.j(sys.Cmp.idx);
 sys.Cmp.z   = pmu(sys.Cmp.idx,3);
 sys.Cmp.v   = pmu(sys.Cmp.idx,4);
 sys.Cmp.N   = size(sys.Cmp.i,1);

 sys.Cmp.A   = bra.tij(sys.Cmp.idx).^4 .* (bra.gij(sys.Cmp.idx).^2 + (bra.bij(sys.Cmp.idx) + bra.bsi(sys.Cmp.idx)).^2);
 sys.Cmp.B   = bra.pij(sys.Cmp.idx).^2 .* (bra.gij(sys.Cmp.idx).^2 + bra.bij(sys.Cmp.idx).^2);
 sys.Cmp.C   = bra.tij(sys.Cmp.idx).^2 .* bra.pij(sys.Cmp.idx) .* (bra.gij(sys.Cmp.idx).^2 + bra.bij(sys.Cmp.idx) .* (bra.bij(sys.Cmp.idx) + bra.bsi(sys.Cmp.idx)));
 sys.Cmp.D   = bra.tij(sys.Cmp.idx).^2 .* bra.pij(sys.Cmp.idx) .* bra.gij(sys.Cmp.idx) .* bra.bsi(sys.Cmp.idx);
 sys.Cmp.fij = bra.fij(sys.Cmp.idx);

 num = (1:sys.Cmp.N)';
 sys.Cmp.jci = [num; num];
 sys.Cmp.jcj = [sys.Cmp.i; sys.Cmp.j];
%--------------------------------------------------------------------------


%-----------------Line Current Angle Phasor Measurements-------------------
 sys.Cap.idx = logical(pmu(:,8));
 sys.Cap.i   = bra.i(sys.Cap.idx);
 sys.Cap.j   = bra.j(sys.Cap.idx);
 sys.Cap.z   = pmu(sys.Cap.idx,6);
 sys.Cap.v   = pmu(sys.Cap.idx,7);
 sys.Cap.N   = size(sys.Cap.i,1);

 sys.Cap.Aa  = bra.tij(sys.Cap.idx).^2 .* bra.gij(sys.Cap.idx);
 sys.Cap.Ba  = bra.tij(sys.Cap.idx).^2 .* (bra.bij(sys.Cap.idx) + bra.bsi(sys.Cap.idx));
 sys.Cap.Ca  = bra.pij(sys.Cap.idx) .* bra.gij(sys.Cap.idx);
 sys.Cap.Da  = bra.pij(sys.Cap.idx) .* bra.bij(sys.Cap.idx);
 sys.Cap.Ac  = bra.tij(sys.Cap.idx).^4 .* (bra.gij(sys.Cap.idx).^2 + (bra.bij(sys.Cap.idx) + bra.bsi(sys.Cap.idx)).^2);
 sys.Cap.Bc  = bra.pij(sys.Cap.idx).^2 .* (bra.gij(sys.Cap.idx).^2 + bra.bij(sys.Cap.idx).^2);
 sys.Cap.Cc  = bra.tij(sys.Cap.idx).^2 .* bra.pij(sys.Cap.idx) .* (bra.gij(sys.Cap.idx).^2 + bra.bij(sys.Cap.idx) .* (bra.bij(sys.Cap.idx) + bra.bsi(sys.Cap.idx)));
 sys.Cap.Dc  = bra.tij(sys.Cap.idx).^2 .* bra.pij(sys.Cap.idx) .* bra.gij(sys.Cap.idx) .* bra.bsi(sys.Cap.idx);
 sys.Cap.fij = bra.fij(sys.Cap.idx);

 num = (1:sys.Cap.N)';
 sys.Cap.jci = [num; num];
 sys.Cap.jcj = [sys.Cap.i; sys.Cap.j];
%--------------------------------------------------------------------------