 function [pf] = solve_dcpf(sys)

%--------------------------------------------------------------------------
% Solves the DC power flow problem and computes the vector of bus voltage
% angles.
%
% The DC power flow is based on the equation Pg - Pl = Ybus*T + Psh + rsh,
% thus the least-squares solution is T =  Ybus \ (Pg - Pl - Psh - rsh).
% Further, the voltage angle on the slack bus is known, and consequently,
% it should be removed from the system. Finally, the preprocessing time is
% over, and the convergence time is obtained here, while the postprocessing
% time is initialized.
%--------------------------------------------------------------------------
%  Input:
%	- sys: power system data
%
%  Outputs:
%	- pf.bus with column: (1)bus voltage angles(Ti)
%	- pf.method: method name
%	- pf.grid: name of the analyzed power system
% 	- pf.time.pre: preprocessing time
%	- pf.time.conv: convergence time
%--------------------------------------------------------------------------
% The local function which is used for the DC power flow.
%--------------------------------------------------------------------------


%---------------------------------Method-----------------------------------
 pf.method = 'DC Power Flow';
%--------------------------------------------------------------------------


%--------------------------B Matix and Pi Vector---------------------------
 sys.Ybu(:,sys.sck(1)) = [];
 sys.Ybu(sys.sck(1),:) = [];

 b = sys.bus(:,11) - sys.bus(:,5) - sys.bus(:,16) - sys.bus(:,7);
 b(sys.sck(1)) = [];
%--------------------------------------------------------------------------


%---------------------------Preprocessing Time-----------------------------
 pf.time.pre = toc; tic
%--------------------------------------------------------------------------


%---------------------------Bus Voltage Angles-----------------------------
 T  = sys.Ybu \ b;
 in = @(a, x, n) cat(1, x(1:n), a, x(n + 1:end));
 T  = in(0, T, sys.sck(1) - 1);

 pf.bus(:,1) = sys.sck(2) * ones(sys.Nbu,1) + T;
%--------------------------------------------------------------------------


%----------------------------Convergence Time------------------------------
 pf.time.conv = toc; tic
%--------------------------------------------------------------------------