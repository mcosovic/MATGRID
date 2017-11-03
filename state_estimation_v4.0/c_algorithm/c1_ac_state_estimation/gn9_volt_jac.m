 function [Jvol] = gn9_volt_jac(sys, ana, pmu)


%-------------------Voltage Magnitude and Angle Jacobian-------------------
 Viana_V      = sparse(ana.Nvi, sys.Nbu); 
 idx          = sub2ind([ana.Nvi, sys.Nbu], (1:ana.Nvi)',  ana.Vi(:,1));
 Viana_V(idx) = 1;
 Viana_T      = sparse(ana.Nvi, sys.Nbu);
 
 Vipmu_V      = sparse(pmu.Nvi, sys.Nbu); 
 idx          = sub2ind([pmu.Nvi, sys.Nbu], (1:pmu.Nvi)',  pmu.Vi(:,1));
 Vipmu_V(idx) = 1;
 Vipmu_T      = sparse(pmu.Nvi, sys.Nbu);
 

 Ti_V      = sparse(pmu.Nti, sys.Nbu);
 Ti_T      = sparse(pmu.Nti, sys.Nbu); 
 idx       = sub2ind([pmu.Nti, sys.Nbu], (1:pmu.Nti)',  pmu.Ti(:,1));
 Ti_T(idx) = 1;
 
 Jvol = [Viana_T Viana_V; Vipmu_T Vipmu_V; Ti_T Ti_V]; 
%--------------------------------------------------------------------------
