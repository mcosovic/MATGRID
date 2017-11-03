 function [Fcph, Jcph] = gn7_cuph_eqn_jac(V, T, alg, i)


 
%----------------Real Part of Line Current Phasor Function-----------------                                                            
 Tri  = i.a .* cos(T(i.i)) - i.b .* sin(T(i.i));
 Trj  = -i.c .* cos(T(i.j)) + i.d .* sin(T(i.j));
 Irij = V(i.i) .* Tri + V(i.j) .* Trj;
%--------------------------------------------------------------------------


%------------Imaginary Part of Line Current Phasor Function----------------
 Tii  = i.b .* cos(T(i.i)) + i.a .* sin(T(i.i)); 
 Tij  = i.d .* cos(T(i.j)) + i.c .* sin(T(i.j));
 Iiij = V(i.i) .* Tii - V(i.j) .* Tij;
%--------------------------------------------------------------------------


%---------------Real Part of Line Current Phasor Jacobian------------------ 
 Ir_Ti = -V(i.i) .* Tii;
 Ir_Tj = V(i.j) .* Tij;
 
 Ir_Vi = Tri;
 Ir_Vj = Trj; 
 
 J61 = sparse(i.jci, i.jcj, [Ir_Ti; Ir_Tj], alg.Nicij, alg.Nbu);
 J62 = sparse(i.jci, i.jcj, [Ir_Vi; Ir_Vj], alg.Nicij, alg.Nbu);
%--------------------------------------------------------------------------


%-------------Imaginary Part of Line Current Phasor Jacobian---------------
 Ii_Ti = V(i.i) .* Tri;
 Ii_Tj = V(i.j) .* Trj;
 Ii_Vi = Tii;
 Ii_Vj = -Tij;
 
 J71 = sparse(i.jci, i.jcj, [Ii_Ti; Ii_Tj], alg.Nicij, alg.Nbu);
 J72 = sparse(i.jci, i.jcj, [Ii_Vi; Ii_Vj], alg.Nicij, alg.Nbu);
%--------------------------------------------------------------------------


%---------------Line Current Phasor Function and Jacobian------------------
 Fcph = [Irij; Iiij];
 Jcph = [J61 J62; J71 J72];
%-------------------------------------------------------------------------- 