 function [se] = solve_dcse_bad_data(user, sys, se)

%--------------------------------------------------------------------------
% Bad data processing using largest normalized residual test for the
% DC state estimation.
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
%	- se: state estimation data
%
%  Outputs:
%	- se.bus: estimated values of the bus voltage angles
%	- se.time.pre: preprocessing time
%	- se.time.con: convergence time
%	- se.bad with columns:
%	  (1)largest normalized residual;
%	  (2)index of suspected bad data measurement
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-18
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-----------------------------Initialization-------------------------------
 se.method = 'DC State Estimation with Bad Data Processing';

 rmax = 10^30;
 cnt  = 1;

 se.bad = zeros(1,2);
 idxGlo = (1:sys.Ntot)';
%--------------------------------------------------------------------------


%---------------------------Preprocessing Time-----------------------------
 se.time.pre = toc; tic
%--------------------------------------------------------------------------


%---------------------------Preprocessing Data-----------------------------
 C = spdiags(se.estimate(:,2), 0, sys.Ntot, sys.Ntot);
 W = C \ speye(sys.Ntot, sys.Ntot);
 H = sys.H;
 H(:, sys.sck(1)) = [];
%--------------------------------------------------------------------------


%==============DC State Estimation with Bad Data Processing================
 while rmax > user.badThreshold && user.badPass ~= cnt - 1 


%---------------------------Bus Voltage Angles-----------------------------
 se.bus = (H' * W * H) \ (H' * W * sys.b);
 insert = @(a, x, n) cat(1, x(1:n), a, x(n + 1:end));
 se.bus = insert(0, se.bus, sys.sck(1) - 1);
%--------------------------------------------------------------------------


%--------------------Largest Normalized Residual Test----------------------
 G     = H' * W * H;
 Omega = C -  H * (G \ H');
 r_nor = abs((sys.b - sys.H * se.bus)) ./ sqrt(diag(Omega));

 [rmax, idx] = max(r_nor);
%--------------------------------------------------------------------------


%-----------------Identification Threshold and Save Data-------------------
 bad = idxGlo(idx);
 if rmax > user.badThreshold
	sys.b(idx, :) = [];
	sys.H(idx, :) = [];
	W(idx, :) = [];                                                         %#ok<*SPRIX>
	W(:, idx) = [];
	C(idx, :) = [];
	C(:, idx) = [];
	H(idx, :) = [];
	idxGlo(idx) = [];
 end

 se.bad(cnt,1) = rmax;
 se.bad(cnt,2) = bad;
 cnt = cnt + 1;
%--------------------------------------------------------------------------
 end
%==========================================================================


%--------------------------------Save Data---------------------------------
 se.time.con = toc; tic
 se.bus = sys.sck(2) * ones(sys.Nbu,1) + se.bus;
%--------------------------------------------------------------------------