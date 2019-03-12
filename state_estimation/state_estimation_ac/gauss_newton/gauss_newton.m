 function [se] = gauss_newton(user, sys, se, data)

%--------------------------------------------------------------------------
% Solves the non-linear state estimation problem and computes the complex
% bus voltages.
%
% The function uses the Gauss-Newton method to solve non-linear state
% estimation problem. Also, the preprocessing time is over, and the
% convergence time is obtained here, while the postprocessing time is
% initialized.
%
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
%
% The local function which is used in the non-linear state estimation.
%--------------------------------------------------------------------------


%-----------------------------Initialization-------------------------------
 se.method = 'Non-linear State Estimation using Gauss-Newton Algorithm';
 [T, V] = initial_point_acse(user, sys, data);

 x   = [T; V];
 No  = 0;
 eps = 9999;
%--------------------------------------------------------------------------


%---------------------------Preprocessing Time-----------------------------

 se.time.pre = toc; tic
%--------------------------------------------------------------------------


%===========================Gauss-Newton Method============================
 while eps > sys.stop && No < 400
 No = No+1;

%----------------------Vector f(x) and Jacobian H(x)-----------------------
 [Ff, Jf] = flow_acse(V, T, sys.Pf, sys.Qf, sys.Nbu);
 [Fc, Jc] = current_acse(V, T, sys.Cm, sys.Nbu);
 [Fi, Ji] = injection_acse(V, T, sys.Pi, sys.Qi, sys.Nbu);
 [Fp, Jp] = current_ph_acse(V, T, sys.Cmp, sys.Cap, sys.Nbu);
 [Fv] = voltage_acse(V, T, sys.Vml.i, sys.Vmp.i, sys.Vap.i);

 f = [Ff; Fc; Fi; Fv; Fp];
 H = [Jf; Jc; Ji; sys.Jv; Jp];

 H(:, sys.sck(1)) = [];
%--------------------------------------------------------------------------


%---------------------------------Delta x----------------------------------
 Hti = sys.W * H;
 rti = sys.W * (se.estimate(:,1) - f);
 dx  = (Hti' * Hti) \ (Hti' * rti);

 ins = @(a, x, n) cat(1, x(1:n), a, x(n + 1:end));
 dx  = ins(0, dx, sys.sck(1) - 1);
%--------------------------------------------------------------------------


%-----------------------------Postprocessing-------------------------------
 x = x + dx;

 T = x(1:sys.Nbu);
 V = x(sys.Nbu + 1:end);

 eps = norm(dx, inf);
%--------------------------------------------------------------------------

 end
%==========================================================================


%--------------------------------Save Data---------------------------------
 se.time.conv = toc; tic
 se.bus(:,1) = V .* exp(T * 1i);
 se.No = No;
%--------------------------------------------------------------------------