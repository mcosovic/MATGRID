 function [Pi, Qi] = gn6_injc_eqn(V, teta, in)
 


%------------------------Active Power Injection----------------------------
 Vi = diag(V(in.Pi(:,1)));

 Tij = in.pGij .* (cos(teta(in.pa(:,1)) - teta(in.pa(:,2)))) + ...         
       in.pBij .* (sin(teta(in.pa(:,1)) - teta(in.pa(:,2))));      

 in.Tp(in.pid) = Tij;
 in.Tp = in.Tp(in.Pi(:,1), :);
 
 Pi = Vi * in.Tp * V;
%-------------------------------------------------------------------------- 
 

%-----------------------Reactive Power Injection---------------------------
 Vi = diag(V(in.Qi(:,1)));

 Tij = in.qGij .* (sin(teta(in.qa(:,1)) - teta(in.qa(:,2)))) - ...         
       in.qBij .* (cos(teta(in.qa(:,1)) - teta(in.qa(:,2))));      

 in.Tq(in.qid) = Tij;
 in.Tq = in.Tq(in.Qi(:,1), :);
 
 Qi =  Vi * in.Tq * V;
%--------------------------------------------------------------------------

