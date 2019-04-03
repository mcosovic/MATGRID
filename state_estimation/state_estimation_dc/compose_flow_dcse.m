 function [sys] = compose_flow_dcse(flow, sys, bra)

%--------------------------------------------------------------------------
% Builds data associated with active power flow measurements for the DC
% state estimation
%
% The function defines the active power flow measurement data according to
% available measurements (i.e., turn on measurements).
%--------------------------------------------------------------------------
%  Inputs:
%	- flow: legacy power flow measurement data
%	- sys: power system data
%	- br: branch indexes and parameters
%
%  Outputs:
%	- sys.Pf: set indexes and parameters associated with active power flow
%	  measurements
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-04-01
% Last revision by Mirsad Cosovic on 2019-04-01
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%------------------Active Power Flow Legacy Measurements-------------------
 sys.Pf.idx = logical(flow(:,5));
 sys.Pf.i   = bra.i(sys.Pf.idx);
 sys.Pf.j   = bra.j(sys.Pf.idx);
 sys.Pf.z   = flow(sys.Pf.idx,3);
 sys.Pf.v   = flow(sys.Pf.idx,4);
 sys.Pf.N   = size(sys.Pf.i,1);

 sys.Pf.cof  = bra.cof(sys.Pf.idx);
 sys.Pf.fij  = bra.fij(sys.Pf.idx);

 num = (1:sys.Pf.N)';
 sys.Pf.jci = [num; num];
 sys.Pf.jcj = [sys.Pf.i; sys.Pf.j];
%--------------------------------------------------------------------------