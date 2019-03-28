 function [se] = solve_dcse_lav(sys, se)

%--------------------------------------------------------------------------
% Solves the DC linear least absolute value state estimation problem and
% computes the vector of bus voltage angles.
%
% The least absolute value state estimation can be formulated as a linear
% programming problem, which in turn can be solved by applying one of the
% LP solution methods.  Finally, preprocessing time is over, and the
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
% Created by Mirsad Cosovic on 2019-03-19
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%---------------------------------Method-----------------------------------
 se.method = 'DC Least Absolute Value State Estimation';
%--------------------------------------------------------------------------


%---------------------------Preprocessing Time-----------------------------
 se.time.pre = toc; tic
%--------------------------------------------------------------------------


%--------------------------Bus Voltage Estimates---------------------------
 sys.H(:, sys.sck(1)) = [];
 Nbu = sys.Nbu - 1;

 c  = [zeros(Nbu,1); zeros(Nbu,1); ones(2*sys.Ntot,1)];
 A  = [sys.H -sys.H eye(sys.Ntot,sys.Ntot) -eye(sys.Ntot,sys.Ntot)];
 lb = zeros(2*Nbu + 2*sys.Ntot, 1);

 options = optimoptions('linprog','Display','off');
 disp(' Linear programming is running to find least absolute value estimator.')

 [s, ~, flag] = linprog(c, [], [], A, sys.b, lb, [], options);

 if flag == 1
	disp(' Optimal solution found.')

	se.bus = s(1:Nbu) - s(Nbu+1:2*Nbu);
	insert = @(a, x, n) cat(1, x(1:n), a, x(n + 1:end));
	se.bus = insert(0, se.bus, sys.sck(1) - 1);
	se.bus = sys.sck(2) * ones(sys.Nbu,1) + se.bus;
 else
	error('lavDc:noFeasible', 'No feasible point found.\n')
 end
%--------------------------------------------------------------------------


%----------------------------Convergence Time------------------------------
 se.time.con = toc; tic
%--------------------------------------------------------------------------