 function [sys] = ybus_ac(sys)

%--------------------------------------------------------------------------
% Builds the Ybus matrix (sys.Nbu x sys.Nbu).
%
% The function builds the Ybus matrix, as well as its derivatives, and
% forms the unified branch model.
%--------------------------------------------------------------------------
%  Input:
%	- sys: power system data
%
%  Outputs:
%	- sys.branch with additional columns:
%	  (11)branch admittance(yij); (12)admittance charging susceptance(ysi);
%	  (13)complex tap ratio(aij); (14)yij + bsi; (15)yij/aij^2;
%	  (16)-yij/conj(aij); (17)-yij/aij
%	- sys.Ybu: Ybus matrix
%	- sys.ysh: shunt elements vector
%	- sys.Yij: Ybus matrix with only non-diagonal elements
%	- sys.Yii: Ybus matrix with only diagonal elements
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-02-21
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%------------Branch Admittance and Branch Charging Susceptance-------------
 sys.branch(:,11) = 1 ./ complex(sys.branch(:,4), sys.branch(:,5));
 sys.branch(:,12) = 1i *  sys.branch(:,6) / 2;
%--------------------------------------------------------------------------


%--------------------------------Tap Ratio---------------------------------
 sys.branch(:,13) = sys.branch(:,7) .* exp(1i * sys.branch(:,8));
%--------------------------------------------------------------------------


%--------------------------Unified Branch Model----------------------------
 sys.branch(:,14) = sys.branch(:,11) + sys.branch(:,12);
 sys.branch(:,15) = sys.branch(:,14) ./ (conj(sys.branch(:,13)) .* sys.branch(:,13));
 sys.branch(:,16) = -sys.branch(:,11) ./ conj(sys.branch(:,13));
 sys.branch(:,17) = -sys.branch(:,11) ./ sys.branch(:,13);
%--------------------------------------------------------------------------


%---------------------------Branch-Bus Matrices----------------------------
 row = [sys.branch(:,1); sys.branch(:,1)];
 col = [sys.branch(:,2); sys.branch(:,3)];

 Ai = sparse(sys.branch(:,1), sys.branch(:,2), 1, sys.Nbr, sys.Nbu);
 Yi = sparse(row, col, [sys.branch(:,15); sys.branch(:,16)], sys.Nbr, sys.Nbu);

 Aj = sparse(sys.branch(:,1), sys.branch(:,3), 1, sys.Nbr, sys.Nbu);
 Yj = sparse(row, col, [sys.branch(:,17); sys.branch(:,14)], sys.Nbr, sys.Nbu);
%--------------------------------------------------------------------------


%--------------------------Diagonal Shunt Matrix---------------------------
 sys.ysh = complex(sys.bus(:,7), sys.bus(:,8));
 Ysh = sparse(sys.bus(:,1), sys.bus(:,1), sys.ysh, sys.Nbu, sys.Nbu);
%--------------------------------------------------------------------------


%-----------------------------Full Bus Matrix------------------------------
 sys.Ybu = Ai' * Yi + Aj' * Yj + Ysh;
%--------------------------------------------------------------------------


%---------------------------Diagonal Bus Matrix----------------------------
 sys.Yii = sparse(sys.Nbu, sys.Nbu);
 sys.Yii = spdiags(spdiags(sys.Ybu,0), 0, sys.Yii);
%--------------------------------------------------------------------------


%-------------------------Non-diagonal Bus Matrix--------------------------
 sys.Yij = sys.Ybu - sys.Yii;
%--------------------------------------------------------------------------