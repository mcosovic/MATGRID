 function [se] = solve_dcse_lav(se, af, ai, va)

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
%	- se: state estimation system data
%	- af: active power flow measurement data
%	- ai: active power injection measurement data
%	- va: voltage angle measurement data
%
%  Outputs:
%	- se.Va: estimated values of the bus voltage angles
%	- se.method: method name
%	- se.time.pre: preprocessing time
%	- se.time.con: convergence time
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-19
% Last revision by Mirsad Cosovic on 2019-04-20
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%---------------------------------Method-----------------------------------
 se.method = 'DC Least Absolute Value State Estimation';
%--------------------------------------------------------------------------


%---------------------------Preprocessing Data-----------------------------
 H = [af.H; ai.H; va.H];
 b = [af.b; ai.b; va.b];
%--------------------------------------------------------------------------


%---------------------------Preprocessing Time-----------------------------
 se.time.pre = toc; tic
%--------------------------------------------------------------------------


%---------------------------Bus Voltage Angles-----------------------------
 H(:, se.sck(1)) = [];
 Nbu = se.Nbu - 1;
 Nm  = size(H,1);

 c  = [zeros(Nbu,1); zeros(Nbu,1); ones(2*Nm,1)];
 A  = [H -H eye(Nm,Nm) -eye(Nm,Nm)];
 lb = zeros(2*Nbu + 2*Nm, 1);

 options = optimoptions('linprog','Display','off');
 disp(' Linear programming is running to find least absolute value estimator.')

 [s, ~, flag] = linprog(c, [], [], A, b, lb, [], options);

 if flag == 1
	disp(' Optimal solution found.')

	se.Va  = s(1:Nbu) - s(Nbu+1:2*Nbu);
	insert = @(a, x, n) cat(1, x(1:n), a, x(n + 1:end));
	se.Va  = insert(0, se.Va, se.sck(1) - 1);
	se.Va  = se.sck(2) * ones(se.Nbu,1) + se.Va;
 else
	error('lavDc:noFeasible', 'No feasible point found.\n')
 end
%--------------------------------------------------------------------------


%----------------------------Convergence Time------------------------------
 se.time.con = toc; tic
%--------------------------------------------------------------------------