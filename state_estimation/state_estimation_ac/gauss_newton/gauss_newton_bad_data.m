 function [se] = gauss_newton_bad_data(user, sys, se, data)

%--------------------------------------------------------------------------
% Bad data processing using largest normalized residual test for the
% nonlinear state estimation.
%
% The function computes normalized residual and according to identification
% threshold remove suspected measurement. The state estimation algorithms
% based on the Gauss-Newton method proceed with the bad data analysis after
% the estimation process is finished. This is usually done by processing
% the measurement residuals, and typically, the largest normalized residual
% test s used to identify bad data. The the largest normalized residual
% test is performed after the Gauss-Newton algorithm converged in the
% repetitive process of identifying and eliminating bad data measurements
% one after another.
%--------------------------------------------------------------------------
%  Inputs:
%	- user: user inputs
%	- sys: power system data
%	- se: state estimation data
%	- data: power system data with measurement data
%
%  Outputs:
%	- se.bus with column: (1)complex bus voltages
%	- se.time.pre: preprocessing time
%	- se.time.conv: convergence time
%	- se.No: number of iterations
%	- se.bad with columns:
%	  (1)number of iterations; (2)largest normalized residual;
%	  (3)index of suspected bad data measurement
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-18
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-----------------------------Initialization-------------------------------
 se.method = 'Non-linear State Estimation using Gauss-Newton Method with Bad Data Processing';

 idxB = false(sys.Ntot,1);
 idxP = (1:sys.Ntot)';
 rmax = 10^30;
 cnt  = 1;

 se.bad = zeros(1,3);
%--------------------------------------------------------------------------


%---------------------------Preprocessing Time-----------------------------
 se.time.pre = toc; tic
%--------------------------------------------------------------------------


%==============Gauss-Newton Method with Bad Data Processing================
 while rmax > user.badThreshold && user.badPass ~= cnt - 1


%-----------------------------Initialization-------------------------------
 [T, V] = initial_point_acse(user, sys, data);

 x   = [T; V];
 No  = 0;
 eps = 9999;

 z = se.estimate(:,1);
 W = sys.W;
 C = sys.C;
%--------------------------------------------------------------------------


%---------------------------Gauss-Newton Method----------------------------
 while eps > sys.stop && No < user.maxIter
 No = No+1;

 [Ff, Jf] = flow_acse(V, T, sys.Pf, sys.Qf, sys.Nbu);
 [Fc, Jc] = current_acse(V, T, sys.Cm, sys.Nbu);
 [Fi, Ji] = injection_acse(V, T, sys.Pi, sys.Qi, sys.Nbu);
 [Fp, Jp] = current_ph_acse(V, T, sys.Cmp, sys.Cap, sys.Nbu);
 [Fv] = voltage_acse(V, T, sys.Vml.i, sys.Vmp.i, sys.Vap.i);

 f = [Ff; Fc; Fi; Fv; Fp];
 H = [Jf; Jc; Ji; sys.Jv; Jp];

 H(:, sys.sck(1)) = [];
 H(idxB, :) = [];
 f(idxB, :) = [];

 if No == 1
	z(idxB, :) = [];
	W(idxB, :) = [];
	W(:, idxB) = [];
	C(idxB, :) = [];
	C(:, idxB) = [];
 end

 dx = (H' * W * H) \ (H' * W * (z - f));
 ins = @(a, x, n) cat(1, x(1:n), a, x(n + 1:end));
 dx  = ins(0, dx, sys.sck(1) - 1);

 x = x + dx;
 T = x(1:sys.Nbu);
 V = x(sys.Nbu + 1:end);
 eps = norm(dx, inf);
 end
%--------------------------------------------------------------------------


%--------------------Largest Normalized Residual Test----------------------
 [Ff, Jf] = flow_acse(V, T, sys.Pf, sys.Qf, sys.Nbu);
 [Fc, Jc] = current_acse(V, T, sys.Cm, sys.Nbu);
 [Fi, Ji] = injection_acse(V, T, sys.Pi, sys.Qi, sys.Nbu);
 [Fp, Jp] = current_ph_acse(V, T, sys.Cmp, sys.Cap, sys.Nbu);
 [Fv] = voltage_acse(V, T, sys.Vml.i, sys.Vmp.i, sys.Vap.i);

 f = [Ff; Fc; Fi; Fv; Fp];
 H = [Jf; Jc; Ji; sys.Jv; Jp];

 H(:, sys.sck(1)) = [];
 H(idxB, :) = [];
 f(idxB, :) = [];

 G     = H' * W * H;
 Omega = C -  H * (G \ H');
 r_nor = abs((z - f)) ./ sqrt(diag(Omega));

 [rmax, idx] = max(r_nor);
%--------------------------------------------------------------------------


%-----------------Identification Threshold and Save Data-------------------
 bad = idxP(idx);
 if rmax > user.badThreshold
	idxB(bad) = 1;
	idxP(bad) = [];
 end

 se.bad(cnt,1) = No;
 se.bad(cnt,2) = rmax;
 se.bad(cnt,3) = bad;
 cnt = cnt + 1;
%--------------------------------------------------------------------------
 end
%==========================================================================


%--------------------------------Save Data---------------------------------
 se.time.con  = toc; tic
 se.bus       = V .* exp(T * 1i);
 se.iteration = No;
%--------------------------------------------------------------------------