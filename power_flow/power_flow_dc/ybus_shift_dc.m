 function [sys] = ybus_shift_dc(sys)

%--------------------------------------------------------------------------
% Builds the Ybus matrix (sys.Nbu x sys.Nbu) and shift angle vector
% (sys.Nbu x 1) for the DC problem.
%
% The DC power flow is based on the power balance equation Pg - Pl = Ybus*T
% + Psh + rsh, where T is the vector of bus voltage angles and Psh is shift
% angle vector. Here, we form Ybus and Psh.
%
%  Inputs:
%	- sys: power system data
%
%  Outputs:
%	- sys.bus with additional column: (16)shift vector(Psh)
%	- sys.branch with additional column: (11)1/(tij*xij)
%	- sys.Ybu: Ybus matrix
%
% The local function which is used in the DC power flow and DC state
% estimation.
%--------------------------------------------------------------------------


%---------------------------Branch-Bus Matrices----------------------------
 sys.branch(:,11) = 1 ./ (sys.branch(:,5) .* sys.branch(:,7));

 row = [sys.branch(:,1); sys.branch(:,1)];
 col = [sys.branch(:,2); sys.branch(:,3)];
 ind = ones(sys.Nbr,1);

 Ai = sparse(row, col, [ind; -ind], sys.Nbr, sys.Nbu);
 Yi = sparse(row, col, [sys.branch(:,11); -sys.branch(:,11)], sys.Nbr, sys.Nbu);
%--------------------------------------------------------------------------


%-----------------------------Full Bus Matrix------------------------------
 sys.Ybu = Ai' * Yi;
%--------------------------------------------------------------------------


%---------------------------Phase Shift Vector-----------------------------
 sys.bus(:,16) = -Ai' * (sys.branch(:,11) .* sys.branch(:,8));
%--------------------------------------------------------------------------