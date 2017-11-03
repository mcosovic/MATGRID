 function [] = dp1_disp_ac(sys, ana, pmu, out)

 
 
%-----------------------------Main Terminal-------------------------------- 
 dp2_terminal_ac(sys, out);
%--------------------------------------------------------------------------
 
 
%------------------------------Bus Terminal--------------------------------
 if sys.disp(1) == 1
    dp3_terminal_ac_bus(sys, out)
 end
%-------------------------------------------------------------------------- 


%---------------------Reactive Power Flow Terminal-------------------------
 if sys.disp(2) == 1
    dp4_terminal_ac_reactive(sys, out)
 end
%--------------------------------------------------------------------------


%---------------------Active Power Flow Terminal---------------------------
 if sys.disp(3) == 1
    dp5_terminal_ac_active(sys, out)
 end
%--------------------------------------------------------------------------


%----------------------------Shunt Terminal--------------------------------
 if sys.disp(4) == 1
    dp6_terminal_ac_shunt(sys, out)
 end
%--------------------------------------------------------------------------


%---------------Measurement Devices Terminal - Power Flow Input------------
 if sys.disp(5) == 1 && sys.method == 1
    [out] = po4_name_unit_ac(sys, ana, pmu, out);
    dp1_termianl_pf(ana, pmu, out);
 end
%--------------------------------------------------------------------------


%------------------Measurement Devices Terminal - User Input---------------
 if sys.disp(5) == 1 && sys.method == 2
    [out] = po4_name_unit_ac(sys, ana, pmu, out);
    dp2_termianl_user(ana, pmu, out);
 end
%--------------------------------------------------------------------------


%-----------------------State Estimation Evaluation------------------------
 if sys.disp(6) == 1
    dp3_terminal_eval(sys, out)
 end
%--------------------------------------------------------------------------