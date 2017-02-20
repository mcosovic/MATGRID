function [Jinjc] = gn10_injc_jac(V, teta, in)




%----------------------Active Power Injection Jacobian---------------------
 s = diag(V);                                                              

 T = -in.pGij .* (sin(teta(in.pa(:,1)) - teta(in.pa(:,2)))) + ...                    
      in.pBij .* (cos(teta(in.pa(:,1)) - teta(in.pa(:,2))));                    

 in.Tp(in.pid) = T;
 Pi_ti = s * in.Tp * V - s^2 * in.pBii;

 in.Tp(logical(eye(size(in.Tp)))) = 0;
 Pi_tj = - s * in.Tp * s;

 J41 = Pi_tj + diag(Pi_ti);
 J41 = J41(in.Pi(:,1),:);
 J41(:, in.slack) = [];

 T = in.pGij .* (cos(teta(in.pa(:,1)) - teta(in.pa(:,2)))) + ...                                          
     in.pBij .* (sin(teta(in.pa(:,1)) - teta(in.pa(:,2))));

 in.Tp1(in.pid) = T;
 Pi_Vi = in.Tp1 * V + s * in.pGii;

 in.Tp1(logical(eye(size(in.Tp1)))) = 0;

 Pi_Vj = s * in.Tp1;

 J42   = diag(Pi_Vi)+Pi_Vj;
 J42   = J42(in.Pi(:,1),:);
%--------------------------------------------------------------------------


%--------------------Reactive Power Injection Jacobian---------------------
 T = in.qGij .* (cos(teta(in.qa(:,1)) - teta(in.qa(:,2)))) + ...                    
     in.qBij .* (sin(teta(in.qa(:,1)) - teta(in.qa(:,2))));
  
 in.Tq(in.qid) = T;
 Qi_ti = s * in.Tq * V - s^2 * in.pGii;

 in.Tq(logical(eye(size(in.Tq)))) = 0;
 Qi_tj = -s * in.Tq * s;

 J51 = Qi_tj+diag(Qi_ti);
 J51 = J51(in.Qi(:,1),:);
 J51(:,in.slack) = [];

 T   = in.qGij .* (sin(teta(in.qa(:,1)) - teta(in.qa(:,2)))) - ...                                        
       in.qBij .* (cos(teta(in.qa(:,1)) - teta(in.qa(:,2))));

 in.Tq1(in.qid) = T;
 Qi_Vi = in.Tq1 * V - s * in.pBii;                                                        

 in.Tq1(logical(eye(size( in.Tq1)))) = 0;
 Qi_Vj = s * in.Tq1;
 
 J52 = diag(Qi_Vi)+Qi_Vj;
 J52 = J52(in.Qi(:,1),:);
%--------------------------------------------------------------------------

 
 Jinjc = [J41 J42; J51 J52];