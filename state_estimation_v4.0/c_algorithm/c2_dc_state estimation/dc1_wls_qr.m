 function [out] = dc1_wls_qr(sys, ana, pmu)


 
%----------------------------Jacobian Matrix-------------------------------
 [out] = dc2_jacobian(sys, ana, pmu);
%--------------------------------------------------------------------------


%---------------------------Bus Voltage Angles-----------------------------
 tic
 out.z = [ana.z; pmu.z];
 C = spdiags([ana.s; pmu.s].^2, 0, ana.Nana + pmu.Nti, ana.Nana + pmu.Nti);
 E = speye(ana.Nana + pmu.Nti, ana.Nana + pmu.Nti);
 W = C.^(1/2) \ E;

 Hti = W * out.J;                                                     
 rti = W * out.z; 
 
 [Q,R,P] = qr(Hti);                                                         
 r       = sprank(Hti);                                                       
 Qn      = Q(:,1:r);                                                           
 U       = R(1:r,1:r);    

 Ts = P * [U \ (Qn' * rti); sparse(sys.Nbu - 1 - r, 1)];  
%--------------------------------------------------------------------------


%--------------------------Data with Slack Bus-----------------------------
 ins   = @(a, x, n) cat(1, x(1:n), a, x(n + 1:end));                        % insert the slack bus voltage angle    
 out.T = ins(0, Ts, sys.slack(1) - 1);                                      % the bus voltage angle vector
 out.T = sys.slack(2) * ones(sys.Nbu, 1) + out.T;                           % solution acording to the slack bus
%--------------------------------------------------------------------------


%----------------------------Convergence Time------------------------------
 out.conv_time = toc;                                                       
%--------------------------------------------------------------------------