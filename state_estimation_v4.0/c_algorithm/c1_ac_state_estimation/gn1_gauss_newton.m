 function [out, alg, idpa] = gn1_gauss_newton(sys, ana, pmu)
 


%---------------------------Initialization--------------------------------- 
 V     = sys.bus(:,2);
 T     = sys.bus(:,3);
 x_ini = [T; V];  
 
 z   = [ana.z; pmu.z];
 v   = diag([ana.s; pmu.s].^2);
 No  = 0; 
 eps = 9999; 

 [idpa, alg] = gn2_idx_par(sys, ana, pmu);
 [Jvol]      = gn9_volt_jac(sys, ana, pmu);
%--------------------------------------------------------------------------


%--------------------------Preprocessing Time------------------------------
 out.pre_time = toc; 
%--------------------------------------------------------------------------


%++++++++++++++++++++++++Gauss-Newton Method+++++++++++++++++++++++++++++++
 tic
 while eps > sys.stop
       No = No+1;


%---------------------Voltage Angle and Magnitude Data--------------------- 
 [alg] = gn3_tij_vij(T, V, alg, idpa);
%--------------------------------------------------------------------------


%------------------------Vector f(x) and Jacobian H(x)---------------------
 [Fflo, Jflo] = gn4_flow_eqn_jac(V, alg, idpa.pij, idpa.qij);
 [Fcur, Jcur] = gn5_curr_eqn_jac(V, alg, idpa.imij); 
 [Finj, Jinj] = gn6_injc_eqn_jac(V, alg, idpa.pi, idpa.qi);
 [Fcph, Jcph] = gn7_cuph_eqn_jac(V, T, alg, idpa.icij);
 [Fvol]       = gn8_volt_eqn(V, T, idpa.vma, idpa.vmp, idpa.ti);
 
 f = [Fflo; Fcur; Finj; Fvol; Fcph];
 H = [Jflo; Jcur; Jinj; Jvol; Jcph];
 
 H(:, sys.slack(1)) = [];
%--------------------------------------------------------------------------


%------------------------------Delta x------------------------------------- 
 [dx] = gn10_increment(v, z, H, f, alg.Ntot, sys.Nbu);
 
 ins = @(a, x, n) cat(1, x(1:n), a, x(n + 1:end));
 dx  = ins(0, dx, sys.slack(1) - 1);
%--------------------------------------------------------------------------


%---------------------------Postprocessing---------------------------------
 x = x_ini + dx;                                                   
 x_ini = x;                                                                 

 T = x(1:sys.Nbu);                                                      
 V = x(sys.Nbu + 1:end); 

 eps = norm(dx, inf);
%-------------------------------------------------------------------------- 

 end
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 

%---------------------Complex Bus Voltage----------------------------------
 out.Vc        = V .* exp(T * 1i);                                                
 out.iter_time = toc;                                                                
 out.No        = No;
%--------------------------------------------------------------------------
