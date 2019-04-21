 function [af] = flow_dcse(flow, se)

%--------------------------------------------------------------------------
% Builds data associated with active power flow measurements for the DC
% state estimation
%
% The function defines the active power flow measurement data according to
% available measurements (i.e., turn on measurements).
%--------------------------------------------------------------------------
%  Inputs:
%	- flow: legacy power flow measurement data
%	- se: state estimation system data
%
%  Outputs:
%	- af.on: measurement set (logical indexes)
%	- af.z: measurement values
%	- af.v: measurement variances
%	- af.n: number of measurements
%	- af.from: from bus end indexes
%	- af.to: to bus end indexes
%	- af.H: Jacobian matrix
%	- af.b: vector of the shift measurement values
%	- af.W: weighting matrix
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-04-01
% Last revision by Mirsad Cosovic on 2019-04-15
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-----------------------------Measurement Set------------------------------
 af.on = logical(flow(:,5));
%--------------------------------------------------------------------------


%----------------------------Measurement Data------------------------------
 af.z = flow(af.on,3);
 af.v = flow(af.on,4);
 af.n = sum(af.on);

 af.from = se.from(af.on);
 af.to   = se.to(af.on);
%--------------------------------------------------------------------------


%------------------------------System Model--------------------------------
 n = (1:af.n)';

 af.H = sparse([n; n], [af.from; af.to], [se.bij(af.on); -se.bij(af.on)], af.n, se.Nbu);
 af.b = af.z - se.fij(af.on);
 af.W = spdiags(1 ./ af.v, 0, af.n, af.n);
%--------------------------------------------------------------------------