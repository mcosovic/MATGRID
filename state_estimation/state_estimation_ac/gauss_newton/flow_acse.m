 function [Ff, Jf] = flow_acse(V, T, p, q, Nbu)

%--------------------------------------------------------------------------
% Computes the active and reactive power flow functions and corresponding
% Jacobian matrices.
%
% The function computes values of functions Pij(V,T) and Qij(V,T), and a
% partial derivative of functions Pij and Qij with respect to bus voltage
% angles and magnitudes.
%--------------------------------------------------------------------------
%  Inputs:
%	- V: bus voltage magnitude vector
%	- T: bus voltage angle vector
%	- p: set indexes and parameters associated with active power flow
%	  measurements
%	- q: set indexes and parameters associated with active power flow
%	  measurements
%	- Nbu: number of buses
%
%  Outputs:
%	- Ff: vector associated with power flow measurement values
%	- Jf: Jacobian matrix associated with power flow measurements
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-02-26
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-----------------------Active Power Flow Function-------------------------
 U  = T(p.i) - T(p.j) - p.fij;
 Vi = V(p.i);
 Vj = V(p.j);

 Tp1 = p.gij .* cos(U) + p.bij .* sin(U);
 Pij = Vi.^2 .* p.tgij - p.pij .* Vi .* Vj .* Tp1;
%--------------------------------------------------------------------------


%-----------------------Active Power Flow Jacobian-------------------------
 Tp2    = p.gij .* sin(U) - p.bij .* cos(U);
 Pij_Ti = p.pij .* Vi .* Vj .* Tp2;
 Pij_Tj = -Pij_Ti;

 Pij_Vi =  2 * p.tgij .* Vi  - p.pij .* Vj .* Tp1;
 Pij_Vj = -p.pij .* Vi .* Tp1 ;

 J11 = sparse(p.jci, p.jcj, [Pij_Ti; Pij_Tj], p.N, Nbu);
 J12 = sparse(p.jci, p.jcj, [Pij_Vi; Pij_Vj], p.N, Nbu);
%--------------------------------------------------------------------------


%----------------------Reactive Power Flow Function------------------------
 U  = T(q.i) - T(q.j) - q.fij;
 Vi = V(q.i);
 Vj = V(q.j);

 Tq1 = q.gij .* sin(U) - q.bij .* cos(U);
 Qij = - q.tbij .* Vi.^2 - q.pij .* Vi .* Vj .* Tq1;
%--------------------------------------------------------------------------


%----------------------Reactive Power Flow Jacobian------------------------
 Tq2    = q.gij .* cos(U) + q.bij .* sin(U);
 Qij_Ti = -q.pij .* Vi .* Vj .* Tq2;
 Qij_Tj = -Qij_Ti;

 Qij_Vi = - 2 * q.tbij .* Vi - q.pij .* Vj .* Tq1;
 Qij_Vj = -q.pij .* Vi .* Tq1;

 J21 = sparse(q.jci, q.jcj, [Qij_Ti; Qij_Tj], q.N, Nbu);
 J22 = sparse(q.jci, q.jcj, [Qij_Vi; Qij_Vj], q.N, Nbu);
%--------------------------------------------------------------------------


%--------------------Power Flow Function and Jacobian----------------------
 Ff = [Pij; Qij];
 Jf = [J11 J12; J21 J22];
%--------------------------------------------------------------------------