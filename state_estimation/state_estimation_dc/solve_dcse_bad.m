 function [data, se, af, ai, va] = solve_dcse_bad(data, user, se, af, ai, va)

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
%	- data: input power system data
%	- user: user inputs
%	- se: state estimation system data
%	- af: active power flow measurement data
%	- ai: active power injection measurement data
%	- va: voltage angle measurement data
%
%  Outputs:
%	- se.Va: estimated values of the bus voltage angles
%	- se.time.pre: preprocessing time
%	- se.time.con: convergence time
%	- se.bad with columns:
%	  (1)largest normalized residual;
%	  (2)indicator of the remove or non-remove measurements;
%	  (3)measurement index; (4)measurement type; (5)bad data pass;
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-18
% Last revision by Mirsad Cosovic on 2019-04-18
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%---------------------------Preprocessing Data-----------------------------
 H = [af.H; ai.H; va.H];
 b = [af.b; ai.b; va.b];
 W = blkdiag(af.W, ai.W, va.W);
 R = [af.v; ai.v; va.v];
%--------------------------------------------------------------------------


%-----------------------------Initialization-------------------------------
 se.method = 'DC State Estimation with Bad Data Processing';
 se.bad    = zeros(1,7);

 rmax = 10^30;
 cnt  = 1;

 idxflo = [(1:2*se.Nbr)' ones(2*se.Nbr,1)];
 idxflo = idxflo(af.on,:);
 idxinj = [se.bus(:,1) 2*ones(se.Nbu,1)];
 idxinj = idxinj(ai.on,:);
 idxvol = [se.bus(:,1) 3*ones(se.Nbu,1)];
 idxvol = idxvol(va.on,:);

 idxM = [idxflo; idxinj; idxvol];
 idxG = (1:(af.n+ai.n+va.n))';

 on = [af.on; ai.on; va.on];

 H(:, se.sck(1)) = [];
%--------------------------------------------------------------------------


%---------------------------Preprocessing Time-----------------------------
 se.time.pre = toc; tic
%--------------------------------------------------------------------------


%==============DC State Estimation with Bad Data Processing================
 while rmax > user.badThreshold && user.badPass ~= cnt - 1

   
%--------------------------Critical Measurments----------------------------
 G = H' * H;
 
 Va = G \ (H' * b);
 se.criti = abs((b - H * Va)) <= 1e-10;
%--------------------------------------------------------------------------     

     
%---------------------------Bus Voltage Angles-----------------------------
 G = H' * W * H;
 se.Va = G \ (H' * W * b);
%--------------------------------------------------------------------------


%--------------------Largest Normalized Residual Test----------------------
 try
	[Gi] = sparseinv(G);
 catch
	error('bad:observable', 'The system is unobservable. Run observability analysis. \n')   
 end

 Omega = R - sum((H * Gi) .* H, 2);
 r_nor = abs((b - H * se.Va)) ./ sqrt(abs(Omega));

 r_nor(se.criti) = 0;
 [rmax, idx] = max(r_nor);
%--------------------------------------------------------------------------


%-----------------Identification Threshold and Save Data-------------------
 bad = idxG(idx);
 se.bad(cnt,2) = 0;
 se.bad(cnt,3:4) = idxM(bad,:);

 if rmax > user.badThreshold
	if idxM(bad,2) == 1
	   data.legacy.flow(idxM(bad,1),5) = 0;
	   [af]  = flow_dcse(data.legacy.flow, se);
	end

	if idxM(bad,2) == 2
	   data.legacy.injection(idxM(bad,1),4) = 0;
	   [ai] = injection_dcse(data.legacy.injection, se);
	end

	if idxM(bad,2) == 3
	   data.pmu.voltage(idxM(bad,1),7) = 0;
	   [va] = voltage_dcse(data.pmu.voltage, se);
	end

	H = [af.H; ai.H; va.H];
	b = [af.b; ai.b; va.b];
	W = blkdiag(af.W, ai.W, va.W);
    R = [af.v; ai.v; va.v];

	H(:, se.sck(1)) = [];

	idxG(idx) = [];
	se.bad(cnt,2) = 1;
    se.criti(idx) = [];
 end

 se.bad(cnt,1) = rmax;
 se.bad(cnt,5) = cnt;
 se.bad(cnt,6) = bad; 
 cnt = cnt + 1;
%--------------------------------------------------------------------------
 end
%==========================================================================


%---------------------------Data with Slack Bus----------------------------
 if any(se.bad(:,2))
    cc = find(on);
    se.bad(:,7) = cc(se.bad(:,6)); 
     
	se.Va  = (H' * W * H) \ (H' * W * b);
 end

 insert = @(a, x, n) cat(1, x(1:n), a, x(n + 1:end));
 se.Va  = insert(0, se.Va, se.sck(1) - 1);
 se.Va  = se.sck(2) * ones(se.Nbu,1) + se.Va;
%--------------------------------------------------------------------------


%----------------------------Convergence Time------------------------------
 se.time.con = toc; tic
%--------------------------------------------------------------------------