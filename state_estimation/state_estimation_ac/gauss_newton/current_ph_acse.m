 function [Fp, Jp] = current_ph_acse (V, T, m, a, Nbu)

%--------------------------------------------------------------------------
% Computes the line current magnitude and angles functions and
% corresponding Jacobian matrices.
%
% The function computes values of functions Iij(V,T) nad Fij(V,T), and a
% partial derivative of functions Iij and Fij with respect to bus voltage
% angles and magnitudes.
%
%  Inputs:
%	- V: bus voltage magnitude vector
%	- T: bus voltage angle vector
%	- m: set indexes and parameters associated with line current magnitude
%	  measurements
%	- a: set indexes and parameters associated with line current angle
%	  measurements
%	- Nbu: number of buses
%
%  Outputs:
%	- Fp: vector associated with line current measurement values
%	- Jp: Jacobian matrix associated with line current measurements
%
% The local function which is used in the Gauss-Newton algorithm.
%--------------------------------------------------------------------------


%---------------------Line Current Magnitude Function----------------------
 U  = T(m.i) - T(m.j) - m.fij;
 Vi = V(m.i);
 Vj = V(m.j);

 Tm1 = m.C .* cos(U) - m.D .* sin(U);
 Fm  = (m.A .* Vi.^2 + m.B .* Vj.^2 - 2 * Vi .* Vj .* Tm1).^(1/2);
%--------------------------------------------------------------------------


%---------------------Line Current Magnitude Jacobian----------------------
 Tm2    = m.C .* sin(U) + m.D .* cos(U);
 Iij_Ti = Vi .* Vj .* Tm2 ./ Fm;
 Iij_Tj = -Iij_Ti;

 Iij_Vi = (-Vj .* Tm1 + m.A .* Vi) ./ Fm;
 Iij_Vj = (-Vi .* Tm1 + m.B .* Vj) ./ Fm;

 J61 = sparse(m.jci, m.jcj, [Iij_Ti; Iij_Tj], m.N, Nbu);
 J62 = sparse(m.jci, m.jcj, [Iij_Vi; Iij_Vj], m.N, Nbu);
%--------------------------------------------------------------------------


%-----------------------Line Current Angle Function------------------------
 U  = T(a.j) + a.fij;
 Ti = T(a.i);
 Vi = V(a.i);
 Vj = V(a.j);

 Iijc = (a.Aa.*cos(Ti) - a.Ba.*sin(Ti)).*Vi - (a.Ca.*cos(U) - a.Da.*sin(U)).*Vj + ...
         1i* ((a.Aa.*sin(Ti) + a.Ba.*cos(Ti)).*Vi - (a.Ca.*sin(U) + a.Da.*cos(U)).*Vj);  
 Fa  = angle(Iijc);
 Fma = abs(Iijc).^2;        
%--------------------------------------------------------------------------


%----------------------Line Angle Magnitude Jacobian-----------------------
 U   = T(a.i) - T(a.j) - a.fij;
 Tm1 = a.Cc .* cos(U) - a.Dc .* sin(U);

 Ta1    = - Vi .* Vj .* Tm1;
 Bij_Ti = (a.Ac .* Vi.^2 + Ta1) ./ Fma;
 Bij_Tj = (a.Bc .* Vj.^2 + Ta1) ./ Fma;

 Ta2    = a.Cc .* sin(U) + a.Dc .* cos(U);
 Bij_Vi = -Vj .* Ta2 ./ Fma;
 Bij_Vj = Vi .* Ta2 ./ Fma;

 J71 = sparse(a.jci, a.jcj, [Bij_Ti; Bij_Tj], a.N, Nbu);
 J72 = sparse(a.jci, a.jcj, [Bij_Vi; Bij_Vj], a.N, Nbu);
%--------------------------------------------------------------------------


%-----------------------Line Current Phasor Jacobian-----------------------
 Fp = [Fm; Fa];
 Jp = [J61 J62; J71 J72];
%--------------------------------------------------------------------------