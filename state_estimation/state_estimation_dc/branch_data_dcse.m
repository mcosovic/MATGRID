 function [bra] = branch_data_dcse(sys)

%--------------------------------------------------------------------------
% Builds the global branch indexes and parameters for the DC state
% estimation.
%
% The function defines branch indexes and parameters that are used for
% branch measurements, active power flow.
%--------------------------------------------------------------------------
%  Input:
%	- sys: power system data
%
%  Outputs:
%	- br.no: branch number
%	- br.i: indexies i
%	- br.j : indexies j
%	- br.cof: coefficients [1/(tij*xij); 1/(tij*xij)]
%	- br.fij: transformer phase shift angle fij
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2018-04-01
% Last revision by Mirsad Cosovic on 2019-04-03
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-------------------------------Branch Data--------------------------------
 bra.no  = (1:2 * sys.Nbr)';
 bra.i   = [sys.branch(:,2); sys.branch(:,3)];
 bra.j   = [sys.branch(:,3); sys.branch(:,2)];
 bra.cof = [sys.branch(:,11); sys.branch(:,11)];
 bra.fij = [sys.branch(:,8); -sys.branch(:,8)];
%--------------------------------------------------------------------------