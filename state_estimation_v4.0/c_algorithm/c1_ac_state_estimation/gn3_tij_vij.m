 function [alg] = gn3_tij_vij(T, V, alg, idpa)



%------------------Voltage Angle and Magnitude Parameters------------------
 Tij = T(idpa.i) - T(idpa.j);
 Vi  = V(idpa.i);
 Vj  = V(idpa.j);
 
 alg.cosTij = cos(Tij);
 alg.sinTij = sin(Tij);
 
 alg.Vij   = Vi .* Vj;
 alg.twoVi = Vi.^2;
 alg.twoVj = Vj.^2;
%--------------------------------------------------------------------------