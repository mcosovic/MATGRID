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
%  Input:
%	- sys: power system data
%
%  Outputs:
%	- se.bus: complex bus voltages
%	- se.method: method name
%	- se.time.pre: preprocessing time
%	- se.time.conv: convergence time
%--------------------------------------------------------------------------
% The local function which is used in the DC state estimation.
%--------------------------------------------------------------------------


%---------------------------------Method-----------------------------------
 se.method = 'DC Least Absolute Value State Estimation';
%--------------------------------------------------------------------------


%---------------------------Preprocessing Time-----------------------------
 se.time.pre = toc; tic
%--------------------------------------------------------------------------


%--------------------------Bus Voltage Estimates---------------------------
 sys.H(:, sys.sck(1)) = [];
 sys.Nbu = sys.Nbu - 1;
 
 c  = [zeros(sys.Nbu,1); zeros(sys.Nbu,1); ones(2*sys.Ntot,1)];
 A  = [sys.H -sys.H eye(sys.Ntot,sys.Ntot) -eye(sys.Ntot,sys.Ntot)];
 lb = zeros(2*sys.Nbu + 2*sys.Ntot, 1);

 options = optimoptions('linprog','Display','off');
 disp(' Linear programming is running to find least absolute value estimator.')

 [s, ~, flag] = linprog(c, [], [], A, sys.b, lb, [], options);

 if flag == 1
	disp(' Optimal solution found.')
	 T = s(1:sys.Nbu) - s(sys.Nbu+1:2*sys.Nbu);
     ins = @(a, x, n) cat(1, x(1:n), a, x(n + 1:end));
     T = ins(0, T, sys.sck(1) - 1);
	 se.bus = sys.sck(2) * ones(sys.Nbu+1,1) + T;
 else
	error('lavDc:noFeasible', 'No feasible point found.\n')
 end
%--------------------------------------------------------------------------


%----------------------------Convergence Time------------------------------
 se.time.conv = toc; tic
%--------------------------------------------------------------------------