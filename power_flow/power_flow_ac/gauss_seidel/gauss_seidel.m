 function [pf] = gauss_seidel(user, sys)

%--------------------------------------------------------------------------
% Solves the AC power flow problem and computes the complex bus voltages.
%
% The function uses the Gauss-Seidel algorithm to solve the AC power flow
% problem. Also, the preprocessing time is over, and the convergence time
% is obtained here, while the postprocessing time is initialized.
%--------------------------------------------------------------------------
%  Inputs:
%	- user: user data
%	- sys: power system data
%
%  Outputs:
%   - pf.Vc: complex bus voltages
%	- pf.limit with columns:
%	  (1)bus indicator where minimum limits violated;
%	  (2)bus indicator where maximum limits violated;
%	- pf.method: method name
%	- pf.grid: name of the analyzed power system
%	- pf.time.pre: preprocessing time
%	- pf.time.con: convergence time
%	- pf.iteration: number of iterations
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-25
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%------------------------Algorithm Initialization--------------------------
 pf.method = 'AC Power Flow using Gauss-Seidel Algorithm';
 pf.limit  = zeros(sys.Nbu,2);

 Vc  = sys.bus(:,3) .* exp(1i * sys.bus(:,4));
 Vcp = Vc;
 Q   = sys.bus(:,12) - sys.bus(:,6);
 Pgl = sys.bus(:,11) - sys.bus(:,5);
 No  = 0;
 eps = 9999;
%--------------------------------------------------------------------------


%---------------------------------Limits-----------------------------------
 [sys] = qv_limits(user, sys);
%--------------------------------------------------------------------------


%---------------------------Preprocessing Time-----------------------------
 pf.time.pre = toc; tic
%--------------------------------------------------------------------------


%=========================Gauss-Seidel Algorithm===========================
 while eps > sys.stop && No < user.maxIter
 No = No + 1;


%--------------------Check Reactive Power Constraints----------------------
 if ismember('reactive', user.list)
	[sys, pf, Vc, Q] = gs_cq(sys, pf, Vc, Q, Pgl);
 end
%--------------------------------------------------------------------------


%-------------------Check Voltage Magnitude Constraints--------------------
 if ismember('voltage', user.list)
	[sys, pf, Vc, Vcp] = gs_cv(sys, pf, Vc, Vcp, Pgl);
 end
%--------------------------------------------------------------------------


 for i = 1:sys.Nbu
	if i ~= sys.sck(1)

%----------------------PV Bus - Compute Bus Voltage------------------------
	   if sys.bus(i,2) == 2
		  Q(i) = -imag(conj(Vc(i)) * (sys.Ybu(i,:) * Vc));
	   end
%--------------------------------------------------------------------------


%---------------------PQ and PV - Compute Bus Voltage----------------------
	   Vc(i) = (1 / sys.Ybu(i,i)) * (((Pgl(i) - 1i * Q(i)) / ...
			   conj(Vc(i))) - sys.Yij(i,:) * Vc);
%--------------------------------------------------------------------------


%-----------------------PV Bus - Voltage Correction------------------------
	   if sys.bus(i,2) == 2
		  Vc(i) = abs(Vcp(i)) * cos(angle(Vc(i))) + ...
				  1i * abs(Vcp(i)) * sin(angle(Vc(i)));
	   end
%--------------------------------------------------------------------------
	end
 end


%----------------------------Check Convergence-----------------------------
 eps = max(abs((Vc) - (Vcp)));
 Vcp = Vc;
%--------------------------------------------------------------------------

 end
%==========================================================================


%--------------------------------Save Data---------------------------------
 pf.Vc        = Vc;
 pf.time.con  = toc; tic
 pf.iteration = No;
%--------------------------------------------------------------------------