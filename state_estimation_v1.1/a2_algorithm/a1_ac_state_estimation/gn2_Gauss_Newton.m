function [out, in] = gn2_Gauss_Newton(in)
 

%---------------------------Initialization--------------------------------- 
 V    = in.Bus(:,2);
 teta = deg2rad(in.Bus(:,3));
 x_ini = [teta; V];  
 x_ini(in.slack) = [];                                                     

 No = 0; 
 [in] = gn1_pre_processing(in);
%--------------------------------------------------------------------------


%++++++++++++++++++++++++Gauss-Newton Method+++++++++++++++++++++++++++++++

%------------------------------Constant------------------------------------ 
 epsilon = 1; 
%--------------------------------------------------------------------------
 tic
 while epsilon > in.stop
       No = No+1;
  
%------------------------------Vector f(x)--------------------------------- 
 [Pij, Qij] = gn4_flow_eqn(V, teta, in.Pij, in.Qij);
 [Iij]      = gn5_curr_eqn(V, teta, in.Iij, in.a, in.b, in.c, in.d);
 [Pi, Qi]   = gn6_injc_eqn(V, teta, in);
 [Vi, Ti]   = gn7_volt_eqn(V, teta, in.Vi, in.Ti);

 f = [Pij; Qij; Iij; Pi; Qi; Vi; Ti];                                       
%--------------------------------------------------------------------------


%--------------------------Jacobian H(x)-----------------------------------
 [Jcurr] = gn8_curr_jac(V, teta, Iij, in);
 [Jflow] = gn9_flow_jac(V, teta, in);
 [Jinjc] = gn10_injc_jac(V, teta, in);

 H = [Jflow; Jcurr; Jinjc; in.Jvol]; 
%--------------------------------------------------------------------------


%------------------------------Delta x------------------------------------- 
 [delta_x] = gn3_increment(in.C, in.z, H, No, f);
%--------------------------------------------------------------------------


%-------------------------Postprocessing-----------------------------------
 x     = x_ini + delta_x;                                                   
 x_ini = x;                                                                 

 teta1  = x(1:in.Nbu - 1);                                                   
 insert = @(a, y, n)cat(2,  y(1:n), a, y(n + 1:end));                        
 teta   = (insert(in.valsl, teta1', in.slack-1))';   
                                                               
 epsilon = norm(delta_x, inf);
 V       = x(in.Nbu:end);
%-------------------------------------------------------------------------- 


 end
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 

%---------------------Complex Bus Voltage----------------------------------
 out.V  = V .* exp(1j * teta);                                                
 out.t  = toc;                                                                
 out.No = No;
%--------------------------------------------------------------------------

