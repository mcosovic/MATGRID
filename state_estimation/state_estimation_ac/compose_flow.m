 function [sys] = compose_flow(flow, sys, bra)

%--------------------------------------------------------------------------
% Builds data associated with active and reactive power flow measurements.
%
% The function defines the active and reactive power flow measurement data
% according to available measurements (i.e., turn on measurements).
%--------------------------------------------------------------------------
%  Inputs:
%	- flow: legacy power flow measurement data
%	- sys: power system data
%	- bra: branch indexes and parameters
%
%  Outputs:
%	- sys.Pf: set indexes and parameters associated with active power flow
%	  measurements
%	- sys.Qf: set indexes and parameters associated with reactive power
%	  flow measurements
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-02-26
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%------------------Active Power Flow Legacy Measurements-------------------
 sys.Pf.idx = logical(flow(:,5));
 sys.Pf.i   = bra.i(sys.Pf.idx);
 sys.Pf.j   = bra.j(sys.Pf.idx);
 sys.Pf.z   = flow(sys.Pf.idx,3);
 sys.Pf.v   = flow(sys.Pf.idx,4);
 sys.Pf.N   = size(sys.Pf.i,1);

 sys.Pf.gij  = bra.gij(sys.Pf.idx);
 sys.Pf.bij  = bra.bij(sys.Pf.idx);
 sys.Pf.tgij = bra.tij(sys.Pf.idx).^2 .* sys.Pf.gij;
 sys.Pf.pij  = bra.pij(sys.Pf.idx);
 sys.Pf.fij  = bra.fij(sys.Pf.idx);

 num = (1:sys.Pf.N)';
 sys.Pf.jci = [num; num];
 sys.Pf.jcj = [sys.Pf.i; sys.Pf.j];
%--------------------------------------------------------------------------


%------------------Reactive Power Flow Legacy Measurements-----------------
 sys.Qf.idx = logical(flow(:,8));
 sys.Qf.i   = bra.i(sys.Qf.idx);
 sys.Qf.j   = bra.j(sys.Qf.idx);
 sys.Qf.z   = flow(sys.Qf.idx,6);
 sys.Qf.v   = flow(sys.Qf.idx,7);
 sys.Qf.N   = size(sys.Qf.i,1);

 sys.Qf.gij  = bra.gij(sys.Qf.idx);
 sys.Qf.bij  = bra.bij(sys.Qf.idx);
 sys.Qf.bsi  = bra.bsi(sys.Qf.idx);
 sys.Qf.tbij = bra.tij(sys.Qf.idx).^2 .* (sys.Qf.bij + sys.Qf.bsi);
 sys.Qf.pij  = bra.pij(sys.Qf.idx);
 sys.Qf.fij  = bra.fij(sys.Qf.idx);

 num = (1:sys.Qf.N)';
 sys.Qf.jci = [num; num];
 sys.Qf.jcj = [sys.Qf.i; sys.Qf.j];
%--------------------------------------------------------------------------
