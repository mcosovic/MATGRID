 function [Finj, Jinj] = gn6_injc_eqn_jac(V, alg, p, q)
 


%------------------------Active Power Injection----------------------------
 Tp1 = p.Gij .* alg.cosTij(p.ij) + p.Bij .* alg.sinTij(p.ij); 
 N   = sparse(p.r, p.j, Tp1, alg.Npi, alg.Nbu) * V;
 Pi  = V(p.ii) .* (N + V(p.ii) .* p.Gii); 
%-------------------------------------------------------------------------- 


%----------------------Active Power Injection Jacobian--------------------- 
 Tp2   = -p.Gij .* alg.sinTij(p.ij) + p.Bij .* alg.cosTij(p.ij); 
 Pi_Ti = V(p.ii) .* (sparse(p.r, p.j, Tp2, alg.Npi, alg.Nbu) * V);                 
 Pi_Tj = -alg.Vij(p.ij) .* Tp2;

 Pi_Vi = N + 2 * V(p.ii) .* p.Gii;
 Pi_Vj = V(p.i) .* Tp1;

 J41 = sparse(p.jci, p.jcj, [Pi_Ti; Pi_Tj], alg.Npi, alg.Nbu);
 J42 = sparse(p.jci, p.jcj, [Pi_Vi; Pi_Vj], alg.Npi, alg.Nbu);
%--------------------------------------------------------------------------


%-----------------------Reactive Power Injection---------------------------
 Tq1 = q.Gij .* alg.sinTij(q.ij) - q.Bij .* alg.cosTij(q.ij); 
 M   = sparse(q.r, q.j, Tq1, alg.Nqi, alg.Nbu) * V;
 Qi  = V(q.ii) .* (M - V(q.ii) .* q.Bii);
%--------------------------------------------------------------------------
 

%--------------------Reactive Power Injection Jacobian---------------------
 Tq2   = q.Gij .* alg.cosTij(q.ij) + q.Bij .* alg.sinTij(q.ij);
 Qi_Ti = V(q.ii) .* (sparse(q.r, q.j, Tq2, alg.Nqi, alg.Nbu) * V);
 Qi_Tj = -alg.Vij(q.ij) .* Tq2;

 Qi_Vi = M - 2 * V(q.ii) .* q.Bii;                                                        
 Qi_Vj =  V(q.i) .* Tq1;
 
 J51 = sparse(q.jci, q.jcj, [Qi_Ti; Qi_Tj], alg.Nqi, alg.Nbu);
 J52 = sparse(q.jci, q.jcj, [Qi_Vi; Qi_Vj], alg.Nqi, alg.Nbu);
%--------------------------------------------------------------------------


%------------------Power Injection Function and Jacobian-------------------
 Finj = [Pi; Qi];
 Jinj = [J41 J42; J51 J52];
%--------------------------------------------------------------------------