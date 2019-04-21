 function [pf] = decoupled_newton_raphson(user, sys)

%--------------------------------------------------------------------------
% Solves the AC power flow problem and computes the complex bus voltages
%
% The function uses the decoupled Newton-Raphson algorithm to solve the AC
% power flow problem. Also, the preprocessing time is over, and the
% convergence time is obtained here, while the postprocessing time is
% initialized.
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
 pf.method = 'AC Power Flow using Decoupled Newton-Raphson Algorithm';
 pf.limit  = zeros(sys.Nbu,2);

 V  = sys.bus(:,3);
 T  = sys.bus(:,4);
 No = 0;
%--------------------------------------------------------------------------


%----------------------Limits, Indexes and Parameters----------------------
 [sys] = qv_limits(user, sys);
 [alg, idx] = idx_par1(sys);
 [alg, idx] = idx_par2_dnr(sys, alg, idx);
%--------------------------------------------------------------------------


%------------------------Algorithm Initialization--------------------------
 Vc  = V .* exp(1i * T);
 Pgl = sys.bus(:,11) - sys.bus(:,5);
 Qgl = sys.bus(:,12) - sys.bus(:,6);

 DelS = Vc .* conj(sys.Ybu * Vc) - (Pgl + 1i * Qgl);
 DelP = real(DelS(alg.ii));
 DelQ = imag(DelS(alg.pq));

 Tij     = T(alg.i) - T(alg.j);
 alg.Te1 = alg.Gij .* sin(Tij) - alg.Bij .* cos(Tij);
%--------------------------------------------------------------------------


%---------------------------Preprocessing Time-----------------------------
 pf.time.pre = toc; tic
%--------------------------------------------------------------------------


%===================Decoupled Newton-Raphson Algorithm=====================
 while max(abs([DelP; DelQ])) > sys.stop && No < user.maxIter
 No = No + 1;


%--------------------Check Reactive Power Constraints----------------------
 if ismember('reactive', user.list)
	[sys, alg, idx, pf, V, T, Qgl] = cq_dnr(sys, alg, idx, pf, V, T, Qgl, Vc, Pgl);
 end
%--------------------------------------------------------------------------


%-------------------Check Voltage Magnitude Constraints--------------------
 if ismember('voltage', user.list)
	[sys, alg, idx, pf, V, T] = cv_dnr(sys, alg, idx, pf, V, T, Pgl);
 end
%--------------------------------------------------------------------------


%--------------------------Voltage Angle Vector----------------------------
 alg.fD1 = sparse(alg.fd1i, alg.j, -alg.Te1, sys.Nbu - 1, sys.Nbu) * V;
 alg.Vij = V(alg.i) .* V(alg.j);

 [J11] = jacobian11(V, alg, idx.j11, sys.Nbu);

 dT  = -(J11 \ DelP);
 ins = @(a, y, n) cat(1, y(1:n), a, y(n+1:end));
 dT  = ins(0, dT, sys.sck(1) - 1);
 T   = T + dT;
%--------------------------------------------------------------------------


%------------------------------New Mismatch--------------------------------
 Vc   = V .* exp(1i * T);
 DelS = Vc .* conj(sys.Ybu * Vc) - (Pgl + 1i * Qgl);
 DelQ = imag(DelS(alg.pq));
%--------------------------------------------------------------------------


%------------------------Voltage Magnitude Vector--------------------------
 Tij     = T(alg.i) - T(alg.j);
 alg.Vpq = V(alg.pq);
 alg.Te1 = alg.Gij .* sin(Tij) - alg.Bij .* cos(Tij);
 alg.fD3 = sparse(alg.fdi, alg.fdj, alg.Te1(alg.fij), alg.Npq, sys.Nbu) * V;

 [J22] = jacobian22(V, alg, idx.j22);

 dV = -(J22 \ DelQ);
 V(alg.pq) = V(alg.pq) + dV;
%--------------------------------------------------------------------------


%------------------------------New Mismatch--------------------------------
 Vc   = V .* exp(1i * T);
 DelS = Vc .* conj(sys.Ybu * Vc) - (Pgl + 1i * Qgl);
 DelP = real(DelS(alg.ii));
%--------------------------------------------------------------------------

 end
%==========================================================================


%--------------------------------Save Data---------------------------------
 pf.Vc        = Vc;
 pf.time.con  = toc; tic
 pf.iteration = No;
%--------------------------------------------------------------------------