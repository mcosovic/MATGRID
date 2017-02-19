function [Jcurr] = gn8_curr_jac(V, teta, Iij, in)
 


%----------------------Line Current Magnitude Jacobian---------------------
 Vi  = diag(V(in.Iij(:,1)));                                                        
 Vjd = diag(V(in.Iij(:,2)));                                                        
 Vj  = V(in.Iij(:,2));
 
 T = in.c .* (sin(teta(in.Iij(:,1)) - teta(in.Iij(:,2)))) + ...                                       
     in.d .* (cos(teta(in.Iij(:,1)) - teta(in.Iij(:,2))));                                       

 Iij_ti =  diag(T) * Vi * Vj ./Iij;
 Iij_tj = - diag(T) * Vi * Vj ./ Iij;

 T = in.c .* (cos(teta(in.Iij(:,1)) - teta(in.Iij(:,2)))) - ...                                       
     in.d .* (sin(teta(in.Iij(:,1)) - teta(in.Iij(:,2))));                                     

 Iij_Vi = (- diag(T) *Vj + Vi * in.a) ./ Iij;
 Iij_Vj = (- diag(T) * V(in.Iij(:,1)) + Vjd * in.b) ./ Iij;

 in.J31(in.ix) = [Iij_ti; Iij_tj];
 in.J32(in.ix) = [Iij_Vi; Iij_Vj];
 in.J31(:, in.slack)  = [];
 
 Jcurr = [in.J31 in.J32];
%--------------------------------------------------------------------------