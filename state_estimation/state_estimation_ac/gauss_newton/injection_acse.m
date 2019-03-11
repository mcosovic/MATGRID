 function [Fi, Ji] = injection_acse(V, T, p, q, Nbu)

%--------------------------------------------------------------------------
% Computes the active and reactive power injection functions and
% corresponding Jacobian matrices.
%
% The function computes values of functions Pi(V,T) and Qi(V,T), and a
% partial derivative of functions Pi and Qi with respect to bus voltage
% angles and magnitudes.
%
%  Inputs:
%	- V: bus voltage magnitude vector
%	- T: bus voltage angle vector
%	- p: set indexes and parameters associated with active power injection
%	  measurements
%	- q: set indexes and parameters associated with reactive power
%	  injection measurements
%	- Nbu: number of buses
%
%  Outputs:
%	- Fi: vector associated with power injection measurement values
%	- Ji: Jacobian matrix associated with power injection measurements
%
% The local function which is used in the Gauss-Newton algorithm.
%--------------------------------------------------------------------------


%-------------------------Active Power Injection---------------------------
 U  = T(p.i) - T(p.j);
 Vi = V(p.i);
 Vj = V(p.j);
 Vb = V(p.bus);

 Tp1 = p.Gij .* cos(U) + p.Bij .* sin(U);
 Pi  = Vb .* sparse(p.ii, p.j, Tp1, p.N, Nbu) * V;
%--------------------------------------------------------------------------


%---------------------Active Power Injection Jacobian----------------------
 Tp2   = -p.Gij .* sin(U) + p.Bij .* cos(U);
 Pi_Ti = Vb .* sparse(p.ii, p.j, Tp2, p.N, Nbu) * V - Vb.^2 .* p.Bii;
 Pi_Tj = -Vi(p.ij) .* Vj(p.ij) .* Tp2(p.ij);

 Pi_Vi = sparse(p.ii, p.j, Tp1, p.N, Nbu) * V + Vb .* p.Gii;
 Pi_Vj = Vi(p.ij) .* Tp1(p.ij);

 J41 = sparse(p.jci, p.jcj, [Pi_Ti; Pi_Tj], p.N, Nbu);
 J42 = sparse(p.jci, p.jcj, [Pi_Vi; Pi_Vj], p.N, Nbu);
%--------------------------------------------------------------------------


%------------------------Reactive Power Injection--------------------------
 U  = T(q.i) - T(q.j);
 Vi = V(q.i);
 Vj = V(q.j);
 Vb = V(q.bus);

 Tq1 = q.Gij .* sin(U) - q.Bij .* cos(U);
 Qi  = Vb .* sparse(q.ii, q.j, Tq1, q.N, Nbu) * V;
%--------------------------------------------------------------------------


%--------------------Reactive Power Injection Jacobian---------------------
 Tq2 = q.Gij .* cos(U) + q.Bij .* sin(U);
 Qi_Ti = Vb .* sparse(q.ii, q.j, Tq2, q.N, Nbu) * V - Vb.^2 .* q.Gii;
 Qi_Tj = -Vi(q.ij) .* Vj(q.ij) .* Tq2(q.ij);

 Qi_Vi = sparse(q.ii, q.j, Tq1, q.N, Nbu) * V - Vb .* q.Bii;
 Qi_Vj = Vi(q.ij) .* Tq1(q.ij);

 J51 = sparse(q.jci, q.jcj, [Qi_Ti; Qi_Tj], q.N, Nbu);
 J52 = sparse(q.jci, q.jcj, [Qi_Vi; Qi_Vj], q.N, Nbu);
%--------------------------------------------------------------------------


%------------------Power Injection Function and Jacobian-------------------
 Fi = [Pi; Qi];
 Ji = [J41 J42; J51 J52];
%--------------------------------------------------------------------------