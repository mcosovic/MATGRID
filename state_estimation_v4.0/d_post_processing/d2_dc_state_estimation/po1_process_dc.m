 function [out, alg] = po1_process_dc(dataSE, sys, ana, pmu, out)



%-----------------------------DC Power Flow--------------------------------
 [out, alg] = po2_power_flow_dc(sys, ana, pmu, out);
%--------------------------------------------------------------------------


%-----------------------State Estimation Evolution-------------------------
 [out] = po3_evaluation_dc(dataSE, sys, ana, pmu, out); 
%--------------------------------------------------------------------------