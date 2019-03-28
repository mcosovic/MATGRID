 function [pf] = fast_newton_raphson(user, sys)

%--------------------------------------------------------------------------
% Solves the AC power flow problem and computes the complex bus voltages
%
% The function uses the fast decoupled Newton-Raphson algorithm (version
% BX) to solve the AC power flow problem. Also, the preprocessing time is
% over, and the convergence time is obtained here, while the postprocessing
% time is initialized.
%--------------------------------------------------------------------------
%  Inputs:
%	- user: user data
%	- sys: power system data
%
%  Outputs:
%	- pf.bus with columns:
%	  (1)bus complex voltages; (6) bus where the minimum limits violated;
%	  (7)bus where the maximum limits violated;
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
 pf.method = 'AC Power Flow using Fast Decoupled Newton-Raphson Algorithm';
 pf.bus = zeros(sys.Nbu,7);

 V  = sys.bus(:,3);
 T  = sys.bus(:,4);
 No = 0;

 pq  = find(sys.bus(:,2) == 1);
 Npq = length(pq);

 Vc  = V .* exp(1i * T);
 Pgl = sys.bus(:,11) - sys.bus(:,5);
 Qgl = sys.bus(:,12) - sys.bus(:,6);

 DelS = Vc .* conj(sys.Ybu * Vc) - (Pgl + 1i * Qgl);
 DelP = real(DelS) ./ V;
 DelP(sys.sck(1)) = [];
 DelQ = imag(DelS(pq));

 [sys] = qv_limits(user, sys);
%--------------------------------------------------------------------------


%-----------------------------Matrix B prime-------------------------------
 prime = sys;
 prime.bus(:,8) = 0;
 prime.branch(:,6) = 0;
 prime.branch(:,7) = 1;

 [prime] = ybus_ac(prime);
 Bp = imag(prime.Ybu);
%--------------------------------------------------------------------------


%-----------------------------Matrix B prime2------------------------------
 prime2 = sys;
 prime2.branch(:,8) = 0;
 prime2.branch(:,4) = 0;
 [prime2] = ybus_ac(prime2);
 Bp2 = imag(prime2.Ybu);
%--------------------------------------------------------------------------


%----------------------------Jacobian Matrices-----------------------------
 Bp(sys.sck(1), :) = [];
 Bp(:, sys.sck(1)) = [];
 Bpi = Bp \ speye([sys.Nbu - 1, sys.Nbu - 1]);

 Bpp  = Bp2;
 Bpp  = Bpp(:,pq);
 Bpp  = Bpp(pq, :);
 Bppi = Bpp \ speye([Npq, Npq]);
%--------------------------------------------------------------------------


%---------------------------Preprocessing Time-----------------------------
 pf.time.pre = toc; tic
%--------------------------------------------------------------------------


%=================Fast Decoupled Newton-Raphson Algorithm==================
 while max(abs([DelP; DelQ])) > sys.stop && No < user.maxIter
 No = No + 1;

%--------------------Check Reactive Power Constraints----------------------
 if ismember('reactive', user.list)
    [sys, pf, V, T, Qgl, pq, Npq, Bppi] = cq_fnr(sys, pf, V, T, Qgl, Vc, Pgl, pq, Npq, Bp2, Bppi);
 end
%--------------------------------------------------------------------------


%-------------------Check Voltage Magnitude Constraints--------------------
 if ismember('voltage', user.list) && No > 1
	[sys, pf, V, T, pq, Npq, Bppi] = cv_fnr(sys, pf, V, T, Pgl, pq, Npq, Bp2, Bppi);
 end
%--------------------------------------------------------------------------


%--------------------------Voltage Angle Vector----------------------------
 dT  = Bpi * DelP;
 ins = @(a, y, n) cat(1, y(1:n), a, y(n+1:end));
 dT  = ins(0, dT, sys.sck(1) - 1);
 T   = T + dT ;
%--------------------------------------------------------------------------


%------------------------------New Mismatch--------------------------------
 Vc   = V .* exp(1i * T);
 DelS = (Vc .* conj(sys.Ybu * Vc) - (Pgl + 1i * Qgl)) ./ V;
 DelQ = imag(DelS(pq));
%--------------------------------------------------------------------------


%------------------------Voltage Magnitude Vector--------------------------
 dV    = Bppi * DelQ;
 V(pq) = V(pq) + dV;
%--------------------------------------------------------------------------


%------------------------------New Mismatch--------------------------------
 Vc   = V .* exp(1i * T);
 DelS = (Vc .* conj(sys.Ybu * Vc) - (Pgl + 1i * Qgl));
 DelP = real(DelS) ./ V;
 DelP(sys.sck(1)) = [];
%--------------------------------------------------------------------------

 end
%==========================================================================


%--------------------------------Save Data---------------------------------
 pf.time.con  = toc; tic
 pf.bus(:,1)  = Vc;
 pf.iteration = No;
%--------------------------------------------------------------------------