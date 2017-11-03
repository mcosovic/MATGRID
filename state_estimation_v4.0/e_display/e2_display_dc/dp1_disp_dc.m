 function [] = dp1_disp_dc(sys, ana, pmu, out)

 
 
%-----------------------------Main Terminal-------------------------------- 
 dp2_terminal_dc(out)
%--------------------------------------------------------------------------
 
 
%------------------------------Bus Terminal--------------------------------
 if sys.disp(1) == 1
    dp3_terminal_dc_bus(sys, out)
 end
%-------------------------------------------------------------------------- 


%----------------------Active Power Flow Terminal--------------------------
 if sys.disp(3) == 1
    dp4_terminal_dc_active(sys, out)
 end
%--------------------------------------------------------------------------


%---------------Measurement Devices Terminal - Power Flow Input------------
 if sys.disp(5) == 1 && sys.method == 1
    [out] = po4_name_unit_dc(sys, ana, pmu, out);
    dp1_termianl_pf(ana, pmu, out);
 end
%--------------------------------------------------------------------------


%------------------Measurement Devices Terminal - User Input---------------
 if sys.disp(5) == 1 && sys.method == 2
    [out] = po4_name_unit_dc(sys, ana, pmu, out);
    dp2_termianl_user(ana, pmu, out);
 end
%--------------------------------------------------------------------------


%-----------------------State Estimation Evaluation------------------------
 if sys.disp(6) == 1
    dp3_terminal_eval(sys, out)
 end
%--------------------------------------------------------------------------