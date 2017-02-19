function [Jflow] = gn9_flow_jac(V, teta, in)
 


%-----------------------Active Power Flow Jacobian-------------------------
 Vi = diag(V(in.Pij(:,1)));                                                          
 Vj = V(in.Pij(:,2));

 T = in.Pij(:,5) .* (sin(teta(in.Pij(:,1)) - teta(in.Pij(:,2)))) - ...                                      
     in.Pij(:,6) .* (cos(teta(in.Pij(:,1)) - teta(in.Pij(:,2))));  
 
 Pij_ti =  diag(T) * Vi * Vj;
 Pij_tj = -diag(T) * Vi * Vj;
 
 T = in.Pij(:,5) .* (cos(teta(in.Pij(:,1)) - teta(in.Pij(:,2)))) + ...                                        
     in.Pij(:,6) .* (sin(teta(in.Pij(:,1)) - teta(in.Pij(:,2))));  
 
 Pij_Vi = -diag(T) * Vj + 2 * Vi * (in.Pij(:,5) + in.Pij(:,7));
 Pij_Vj = -diag(T) * V(in.Pij(:,1));

 in.J11(in.px) = [Pij_ti; Pij_tj];
 in.J12(in.px) = [Pij_Vi; Pij_Vj];
 in.J11(:, in.slack) = [];
 %--------------------------------------------------------------------------


%----------------------Reactive Power Flow Jacobian------------------------
 Vi = diag(V(in.Qij(:,1)));                                                          
 Vj = V(in.Qij(:,2));

 T = in.Qij(:,5) .* (cos(teta(in.Qij(:,1)) - teta(in.Qij(:,2)))) + ...                                        
     in.Qij(:,6) .* (sin(teta(in.Qij(:,1)) - teta(in.Qij(:,2)))); 
 
 Qij_ti = -diag(T) * Vi * Vj;
 Qij_tj =  diag(T) * Vi * Vj;

 T = in.Qij(:,5) .* (sin(teta(in.Qij(:,1)) - teta(in.Qij(:,2)))) - ...                                       
     in.Qij(:,6) .* (cos(teta(in.Qij(:,1)) - teta(in.Qij(:,2)))); 
  
 Qij_Vi = -diag(T) * Vj - 2 * Vi * (in.Qij(:,6) + in.Qij(:,7));
 Qij_Vj = -diag(T) * V(in.Qij(:,1));

 in.J21(in.qx) = [Qij_ti; Qij_tj];
 in.J22(in.qx) = [Qij_Vi; Qij_Vj];
 in.J21(:, in.slack) = [];
%--------------------------------------------------------------------------

Jflow = [in.J11 in.J12; in.J21 in.J22];