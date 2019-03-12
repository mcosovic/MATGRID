 function [se] = solve_dcse(sys, se)

%--------------------------------------------------------------------------
% Solves the DC state estimation problem and computes the vector of bus
% voltage angles.
%
% The DC state estimation solution for an observable system can be
% obtained by solving weighted least-squares problem T = (H'WH)\H'Wz.
% Further, the voltage angle on the slack bus is known, and consequently,
% it should be removed from the system. Finally, preprocessing time is
% over, and the convergence time is obtained here, while postprocessing
% time is initialized.
%
%  Inputs:
%	- sys: power system data
%	- se: state estimation data
%
%  Outputs:
%	- se.bus: bus voltage angles Ti
%	- se.grid: name of the analyzed power system
%	- se.method: method name
%	- se.time.pre: preprocessing time
%	- se.time.conv: convergence time
%
% The local function which is used in the DC state estimation.
%--------------------------------------------------------------------------


%---------------------------------Method-----------------------------------
 se.method = 'DC State Estimation';
%--------------------------------------------------------------------------


%---------------------------Preprocessing Time-----------------------------
 se.time.pre = toc; tic
%--------------------------------------------------------------------------


%---------------------------Bus Voltage Angles-----------------------------
 C = spdiags(se.estimate(:,2), 0, sys.Ntot, sys.Ntot);
 E = speye(sys.Ntot, sys.Ntot);
 W = C \ E;

 H = sys.H;
 H(:, sys.sck(1)) = [];

 T = (H' * W * H) \ (H' * W * sys.b);
%--------------------------------------------------------------------------


%---------------------------Data with Slack Bus----------------------------
 ins = @(a, x, n) cat(1, x(1:n), a, x(n + 1:end));
 T   = ins(0, T, sys.sck(1) - 1);

 se.bus = sys.sck(2) * ones(sys.Nbu,1) + T;
%--------------------------------------------------------------------------


%----------------------------Convergence Time------------------------------
 se.time.conv = toc; tic
%--------------------------------------------------------------------------