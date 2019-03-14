 function [se] = solve_pmuse(sys, se)

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
 se.method = 'State Estimation only with PMUs';
%--------------------------------------------------------------------------


%---------------------------Preprocessing Time-----------------------------
 se.time.pre = toc; tic
%--------------------------------------------------------------------------


%--------------------------Bus Voltage Estimates---------------------------
 C = spdiags(se.estimate(:,2), 0, sys.Ntot, sys.Ntot);
 W = C \ speye(sys.Ntot, sys.Ntot);

 VrVi = (sys.H' * W * sys.H) \ (sys.H' * W * se.estimate(:,1));
 
 se.bus = VrVi(1:sys.Nbu) + 1i * VrVi(sys.Nbu+1:end);
%--------------------------------------------------------------------------


%----------------------------Convergence Time------------------------------
 se.time.conv = toc; tic
%--------------------------------------------------------------------------