 function [pf] = solve_dcpf(sys)

%--------------------------------------------------------------------------
% Solves the DC power flow problem and computes the vector of the bus
% voltage angles.
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
%	- pf.time.con: convergence time
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2018-06-15
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%---------------------------------Method-----------------------------------
 pf.method = 'DC Power Flow';
%--------------------------------------------------------------------------


%--------------------------B Matix and b Vector----------------------------
 sys.Ybu(:,sys.sck(1)) = [];
 sys.Ybu(sys.sck(1),:) = [];

 b = sys.bus(:,11) - sys.bus(:,5) - sys.bus(:,16) - sys.bus(:,7);
 b(sys.sck(1)) = [];
%--------------------------------------------------------------------------


%---------------------------Preprocessing Time-----------------------------
 pf.time.pre = toc; tic
%--------------------------------------------------------------------------


%---------------------------Bus Voltage Angles-----------------------------
 pf.bus = sys.Ybu \ b;
 insert = @(a, x, n) cat(1, x(1:n), a, x(n + 1:end));
 pf.bus = insert(0, pf.bus, sys.sck(1) - 1);

 pf.bus = sys.sck(2) * ones(sys.Nbu,1) + pf.bus;
%--------------------------------------------------------------------------


%----------------------------Convergence Time------------------------------
 pf.time.con = toc; tic
%------------------------------------------------------------------------------------------------------