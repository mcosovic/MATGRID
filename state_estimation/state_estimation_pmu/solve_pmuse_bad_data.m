 function [se] = solve_pmuse_bad_data(user, sys)

%--------------------------------------------------------------------------
% Bad data processing using largest normalized residual test for the linear
% state estimation with PMUs only.
%
% The function computes normalized residual and according to identification
% threshold remove suspected measurement. The state estimation algorithms
% based on the WLS proceed with the bad data analysis after the estimation
% process is finished. This is usually done by processing the measurement
% residuals, and typically, the largest normalized residual test s used to
% identify bad data. The the largest normalized residual test is performed
% after the WLS is solved in the repetitive process of identifying and
% eliminating bad data measurements one after another.
%--------------------------------------------------------------------------
%  Inputs:
%	- user: user inputs
%	- sys: power system data
%
%  Outputs:
%	- se.bus with column: (1)complex bus voltages
%	- se.time.pre: preprocessing time
%	- se.time.conv: convergence time
%	- se.No: number of iterations
%   - se.bad with columns:
%     (1)largest normalized residual;
%     (2)index of suspected bad data measurement
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-05
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-----------------------------Initialization-------------------------------
 se.method = 'Linear State Estimation only with PMUs with Bad Data Processing';

 rmax = 10^30;
 cnt = 1;
 N = sys.Nv + sys.Nc;

 se.bad = zeros(1,2);
 idxGlo = (1:sys.Ntot)';
%--------------------------------------------------------------------------


%---------------------------Preprocessing Time-----------------------------
 se.time.pre = toc; tic
%--------------------------------------------------------------------------


%---------------------------Preprocessing Data-----------------------------
 C = spdiags(sys.v, 0, sys.Ntot, sys.Ntot);
 W = C \ speye(sys.Ntot, sys.Ntot);
%--------------------------------------------------------------------------


%==============PMU State Estimation with Bad Data Processing===============
 while rmax > user.badThreshold && user.badPass ~= cnt - 1


%--------------------------Bus Voltage Estimates---------------------------
 VrVi = (sys.H' * W * sys.H) \ (sys.H' * W * sys.b);
%--------------------------------------------------------------------------


%--------------------Largest Normalized Residual Test----------------------
 G     = sys.H' * W * sys.H;
 Omega = C -  sys.H * (G \ sys.H');
 r_nor = abs((sys.b - sys.H * VrVi)) ./ sqrt(diag(Omega));

 [rmax, idx] = max(r_nor);
%--------------------------------------------------------------------------


%-----------------Identification Threshold and Save Data-------------------
 bad = idxGlo(idx);
 if rmax > user.badThreshold
	idxGlo(idx) = [];
	if idx <= N
	   rem = [idx, idx + N];
	else
	   rem = [idx, idx - N];
	end
	sys.b(rem) = [];
	sys.H(rem, :) = [];
	W(rem, :) = [];                                                         %#ok<*SPRIX>
	W(:, rem) = [];
	C(rem, :) = [];
	C(:, rem) = [];
	N = N - 1;
 end

 se.bad(cnt,1) = rmax;
 se.bad(cnt,2) = bad;
 cnt = cnt + 1;
%--------------------------------------------------------------------------
 end
%==========================================================================


%--------------------------------Save Data---------------------------------
 se.time.con = toc; tic
 se.Vc = VrVi(1:sys.Nbu) + 1i * VrVi(sys.Nbu+1:end);
%--------------------------------------------------------------------------