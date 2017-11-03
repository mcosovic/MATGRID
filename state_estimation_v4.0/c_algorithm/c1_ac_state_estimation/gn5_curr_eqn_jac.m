 function [Imij, Jcur] = gn5_curr_eqn_jac(V, alg, i)
 


%----------------------Line Current Magnitude Function---------------------
 Tc1  = i.c .* alg.cosTij(i.ij) - i.d .* alg.sinTij(i.ij);
 Imij = (i.a .* alg.twoVi(i.ij) + i.b .* alg.twoVj(i.ij) - ...
                                         2 * Tc1 .* alg.Vij(i.ij)).^(1/2);
%--------------------------------------------------------------------------


%----------------------Line Current Magnitude Jacobian---------------------
 Tc2    = i.c .* alg.sinTij(i.ij) + i.d .* alg.cosTij(i.ij);                                       
 Iij_Ti = Tc2 .* alg.Vij(i.ij) ./ Imij;
 Iij_Tj = -Iij_Ti;
                      
 Iij_Vi = (-Tc1 .* V(i.j) + V(i.i) .* i.a) ./ Imij;
 Iij_Vj = (-Tc1 .* V(i.i) + V(i.j) .* i.b) ./ Imij;

 J31 = sparse(i.jci, i.jcj, [Iij_Ti; Iij_Tj], alg.Nimij, alg.Nbu);
 J32 = sparse(i.jci, i.jcj, [Iij_Vi; Iij_Vj], alg.Nimij, alg.Nbu);

 Jcur = [J31 J32];
%--------------------------------------------------------------------------


