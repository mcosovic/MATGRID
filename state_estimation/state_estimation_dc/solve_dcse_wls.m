 function [se] = solve_dcse_wls(se, af, ai, va)

%--------------------------------------------------------------------------
% Solves the DC state estimation problem and computes the vector of bus
% voltage angles using weighted least-squares.
%
% The weighted least-squares DC state estimation solution for an observable
% system can be obtained by solving problem T = (H'WH)\H'Wz. Further, the
% voltage angle on the slack bus is known, and consequently, it should be
% removed from the system. Finally, preprocessing time is over, and the
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
% Created by Mirsad Cosovic on 2017-08-04
% Last revision by Mirsad Cosovic on 2019-04-20
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%---------------------------------Method-----------------------------------
 se.method = 'Weighted Least-Squares DC State Estimation';
%--------------------------------------------------------------------------


%---------------------------Preprocessing Data-----------------------------
 H = [af.H; ai.H; va.H];
 b = [af.b; ai.b; va.b];
 W = blkdiag(af.W, ai.W, va.W);
%--------------------------------------------------------------------------


%---------------------------Preprocessing Time-----------------------------
 se.time.pre = toc; tic
%--------------------------------------------------------------------------


%---------------------------Bus Voltage Angles-----------------------------
 H(:, se.sck(1)) = [];

 se.Va = (H' * W * H) \ (H' * W * b);
%--------------------------------------------------------------------------


%---------------------------Data with Slack Bus----------------------------
 insert = @(a, x, n) cat(1, x(1:n), a, x(n + 1:end));
 se.Va  = insert(0, se.Va, se.sck(1) - 1);
 se.Va  = se.sck(2) * ones(se.Nbu,1) + se.Va;
%--------------------------------------------------------------------------


%----------------------------Convergence Time------------------------------
 se.time.con = toc; tic
%--------------------------------------------------------------------------