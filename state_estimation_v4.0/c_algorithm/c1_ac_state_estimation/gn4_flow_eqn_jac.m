 function [Fflo, Jflo] = gn4_flow_eqn_jac(V, alg, p, q)


 
%----------------------Active Power Flow Function--------------------------                                                        
 Tp1 = p.gij .* alg.cosTij(p.ij) + p.bij .* alg.sinTij(p.ij);     
 Pij = alg.twoVi(p.ij) .* p.gsij - Tp1 .* alg.Vij(p.ij);
%--------------------------------------------------------------------------


%-----------------------Active Power Flow Jacobian-------------------------
 Tp2    = p.gij .* alg.sinTij(p.ij) - p.bij .* alg.cosTij(p.ij); 
 Pij_Ti = Tp2 .* alg.Vij(p.ij);
 Pij_Tj = -Pij_Ti;
 
 Pij_Vi = -Tp1 .* V(p.j) + 2 * V(p.i) .* p.gsij;
 Pij_Vj = -Tp1 .* V(p.i);
 
 J11 = sparse(p.jci, p.jcj, [Pij_Ti; Pij_Tj], alg.Npij, alg.Nbu);
 J12 = sparse(p.jci, p.jcj, [Pij_Vi; Pij_Vj], alg.Npij, alg.Nbu);
%--------------------------------------------------------------------------


%----------------------Reactive Power Flow Function------------------------
 Tq1 = q.gij .* alg.sinTij(q.ij) - q.bij .* alg.cosTij(q.ij);  
 Qij = -alg.twoVi(q.ij) .* q.bsij - Tq1 .* alg.Vij(q.ij);
%--------------------------------------------------------------------------


%----------------------Reactive Power Flow Jacobian------------------------
 Tq2    = q.gij .* alg.cosTij(q.ij) + q.bij .* alg.sinTij(q.ij); 
 Qij_Ti = -Tq2 .* alg.Vij(q.ij);
 Qij_Tj = -Qij_Ti;

 Qij_Vi = -Tq1 .* V(q.j) - 2 * V(q.i) .* q.bsij;
 Qij_Vj = -Tq1 .* V(q.i);

 J21 = sparse(q.jci, q.jcj, [Qij_Ti; Qij_Tj], alg.Nqij, alg.Nbu);
 J22 = sparse(q.jci, q.jcj, [Qij_Vi; Qij_Vj], alg.Nqij, alg.Nbu);
%--------------------------------------------------------------------------


%--------------------Power Flow Function and Jacobian----------------------
 Fflo = [Pij; Qij];
 Jflo = [J11 J12; J21 J22];
%--------------------------------------------------------------------------