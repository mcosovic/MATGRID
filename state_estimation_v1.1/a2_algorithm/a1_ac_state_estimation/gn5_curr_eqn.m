function [Iij] = gn5_curr_eqn(V, teta, Iijm, a, b, c, d)
 

%--------------------------Line Current Magnitude--------------------------
 Vid = diag(V(Iijm(:,1)));                                                         
 Vi  = V(Iijm(:,1));                                                               
 Vj  = V(Iijm(:,2));                                                                
 
 T = c .* cos(teta(Iijm(:,1)) - teta(Iijm(:,2))) - ...
     d .* sin(teta(Iijm(:,1)) - teta(Iijm(:,2)));

 Iij = (diag(a) * Vi.^2 + diag(b) * Vj.^2 - ...
        2 * diag(T) * Vid * Vj).^(1/2);
%--------------------------------------------------------------------------
