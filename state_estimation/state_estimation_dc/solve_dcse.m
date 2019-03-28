 function [se] = solve_dcse(sys, se)

%--------------------------------------------------------------------------
% Solves the DC state estimation problem and computes the vector of bus
% voltage angles.
%
% The weighted least-squares DC state estimation solution for an observable
% system can be obtained by solving problem T = (H'WH)\H'Wz. Further, the
% voltage angle on the slack bus is known, and consequently, it should be
% removed from the system. Finally, preprocessing time is over, and the
% convergence time is obtained here, while postprocessing time is
% initialized.
%--------------------------------------------------------------------------
%  Inputs:
%	- sys: power system data
%	- se: state estimation data
%
%  Outputs:
%	- se.bus: estimated values of the bus voltage angles
%	- se.method: method name
%	- se.time.pre: preprocessing time
%	- se.time.con: convergence time
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2017-08-04
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%---------------------------------Method-----------------------------------
 se.method = 'Weighted Least-Squares DC State Estimation';
%--------------------------------------------------------------------------


%---------------------------Preprocessing Time-----------------------------
 se.time.pre = toc; tic
%--------------------------------------------------------------------------


%---------------------------Bus Voltage Angles-----------------------------
 W = spdiags(se.estimate(:,2), 0, sys.Ntot, sys.Ntot) \ speye(sys.Ntot, sys.Ntot);

 sys.H(:, sys.sck(1)) = [];

 se.bus = (sys.H' * W * sys.H) \ (sys.H' * W * sys.b);
%--------------------------------------------------------------------------


%---------------------------Data with Slack Bus----------------------------
 insert = @(a, x, n) cat(1, x(1:n), a, x(n + 1:end));
 se.bus = insert(0, se.bus, sys.sck(1) - 1);
 se.bus = sys.sck(2) * ones(sys.Nbu,1) + se.bus;
%--------------------------------------------------------------------------


%----------------------------Convergence Time------------------------------
 se.time.con = toc; tic
%--------------------------------------------------------------------------