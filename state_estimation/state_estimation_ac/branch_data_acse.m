 function [br] = branch_data_acse(sys)

%--------------------------------------------------------------------------
% Builds the global branch indexes and parameters.
%
% The function defines branch indexes and parameters that are used for
% branch measurements, active and reactive power flow, and line current
% magnitude and angle measurements.
%
%  Input:
%	- sys: power system data
%
%  Outputs:
%	- br.no: branch number
%	- br.i: indexies i
%	- br.j : indexies j
%	- br.gij: conductance gij
%	- br.bij: susceptance bij
%	- br.bsi: branch charging susceptances bsi
%	- br.tij: transformer tap ratio magnitude tij
%	- br.pij: transformer tap ratio magnitude pij
%	- br.fij: transformer phase shift angle fij
%
% The local function which is used in the non-linear state estimation.
%--------------------------------------------------------------------------


%-------------------------------Branch Data--------------------------------
 br.no  = (1:2 * sys.Nbr)';
 br.i   = [sys.branch(:,2); sys.branch(:,3)];
 br.j   = [sys.branch(:,3); sys.branch(:,2)];
 br.gij = [real(sys.branch(:,11)); real(sys.branch(:,11))]; 
 br.bij = [imag(sys.branch(:,11)); imag(sys.branch(:,11))];
 br.bsi = [sys.branch(:,6) / 2; sys.branch(:,6) / 2];
 br.tij = [1./sys.branch(:,7); ones(sys.Nbr,1)];
 br.pij = [1./sys.branch(:,7); 1./sys.branch(:,7)];
 br.fij = [sys.branch(:,8); -sys.branch(:,8)];
%--------------------------------------------------------------------------