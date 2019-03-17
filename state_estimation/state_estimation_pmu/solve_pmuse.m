 function [se] = solve_pmuse(sys)

%--------------------------------------------------------------------------
% Solves the PMU linear state estimation problem and computes the vector of
% bus voltage angles.
%
% The state estimation solution for the system observable only by PMUs can
% be obtained by solving weighted least-squares problem T = (H'WH)\H'Wz.
% Finally, preprocessing time is over, and the convergence time is obtained
% here, while postprocessing time is initialized.
%--------------------------------------------------------------------------
%  Input:
%	- sys: power system data
%
%  Outputs:
%	- se.bus: complex bus voltages
%	- se.method: method name
%	- se.time.pre: preprocessing time
%	- se.time.conv: convergence time
%--------------------------------------------------------------------------
% The local function which is used in the PMU state estimation.
%--------------------------------------------------------------------------


%---------------------------------Method-----------------------------------
 se.method = 'Linear State Estimation only with PMUs';
%--------------------------------------------------------------------------


%---------------------------Preprocessing Time-----------------------------
 se.time.pre = toc; tic
%--------------------------------------------------------------------------


%--------------------------Bus Voltage Estimates---------------------------
 C = spdiags(sys.v, 0, sys.Ntot, sys.Ntot);
 W = C \ speye(sys.Ntot, sys.Ntot);

 VrVi = (sys.H' * W * sys.H) \ (sys.H' * W * sys.b);

 se.bus = VrVi(1:sys.Nbu) + 1i * VrVi(sys.Nbu+1:end);
%--------------------------------------------------------------------------


%----------------------------Convergence Time------------------------------
 se.time.conv = toc; tic
%--------------------------------------------------------------------------