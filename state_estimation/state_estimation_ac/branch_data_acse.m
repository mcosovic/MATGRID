 function [bra] = branch_data_acse(sys)

%--------------------------------------------------------------------------
% Builds the global branch indexes and parameters.
%
% The function defines branch indexes and parameters that are used for
% branch measurements, active and reactive power flow, and line current
% magnitude and angle measurements.
%--------------------------------------------------------------------------
%  Input:
%	- sys: power system data
%
%  Outputs:
%	- bra.no: branch number
%	- bra.i: indexies i
%	- bra.j : indexies j
%	- bra.gij: conductance gij
%	- bra.bij: susceptance bij
%	- bra.bsi: branch charging susceptances bsi
%	- bra.tij: transformer tap ratio magnitude tij
%	- bra.pij: transformer tap ratio magnitude pij
%	- bra.fij: transformer phase shift angle fij
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2018-08-10
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-------------------------------Branch Data--------------------------------
 bra.no  = (1:2 * sys.Nbr)';
 bra.i   = [sys.branch(:,2); sys.branch(:,3)];
 bra.j   = [sys.branch(:,3); sys.branch(:,2)];
 bra.gij = [real(sys.branch(:,11)); real(sys.branch(:,11))]; 
 bra.bij = [imag(sys.branch(:,11)); imag(sys.branch(:,11))];
 bra.bsi = [sys.branch(:,6) / 2; sys.branch(:,6) / 2];
 bra.tij = [1./sys.branch(:,7); ones(sys.Nbr,1)];
 bra.pij = [1./sys.branch(:,7); 1./sys.branch(:,7)];
 bra.fij = [sys.branch(:,8); -sys.branch(:,8)];
%--------------------------------------------------------------------------