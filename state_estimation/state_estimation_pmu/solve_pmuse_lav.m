 function [se] = solve_pmuse_lav(sys)

%--------------------------------------------------------------------------
% Solves the PMU linear least absolute value state estimation problem and
% computes the vector of complex bus voltages.
%
% The least absolute value state estimation can be formulated as a linear
% programming problem, which in turn can be solved by applying one of the
% LP solution methods.  Finally, preprocessing time is over, and the
% convergence time is obtained here, while postprocessing time is
% initialized.
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
% Created by Mirsad Cosovic on 2019-03-17
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%---------------------------------Method-----------------------------------
 se.method = 'Linear Least Absolute Value State Estimation only with PMUs';
%--------------------------------------------------------------------------


%---------------------------Preprocessing Time-----------------------------
 se.time.pre = toc; tic
%--------------------------------------------------------------------------


%--------------------------Bus Voltage Estimates---------------------------
 c  = [zeros(2*sys.Nbu,1); zeros(2*sys.Nbu,1); ones(2*sys.Ntot,1)];
 A  = [sys.H -sys.H eye(sys.Ntot,sys.Ntot) -eye(sys.Ntot,sys.Ntot)];
 lb = zeros(4*sys.Nbu + 2*sys.Ntot, 1);

 options = optimoptions('linprog','Display','off');
 disp(' Linear programming is running to find least absolute value estimator.')

 [s, ~, flag] = linprog(c, [], [], A, sys.b, lb, [], options);

 if flag == 1
	disp(' Optimal solution found.')
	VrVi  = s(1:2*sys.Nbu) - s(2*sys.Nbu+1:4*sys.Nbu);
	se.Vc = VrVi(1:sys.Nbu) + 1i * VrVi(sys.Nbu+1:end);
 else
	error('lavPmu:noFeasible', 'No feasible point found.\n')
 end
%--------------------------------------------------------------------------


%----------------------------Convergence Time------------------------------
 se.time.con = toc; tic
%--------------------------------------------------------------------------