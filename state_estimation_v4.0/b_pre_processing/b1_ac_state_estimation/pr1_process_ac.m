 function [sys, ana, pmu] =  pr1_process_ac(dataSE, sys)
 
 
 
%------------------------------Variables-----------------------------------
 sys.bus     = dataSE.system.bus; 
 sys.line    = dataSE.system.line; 
 sys.slack   = dataSE.system.slack; 
 sys.baseMVA = dataSE.system.baseMVA;
 sys.stop    = dataSE.system.stop; 
 
 if isfield(dataSE.system, 'transformer')  
    sys.transformer = dataSE.system.transformer;
 end
%--------------------------------------------------------------------------
 
 
%-----------------------Forming Brancehs and YBus--------------------------
 tic
 [sys] = sy1_pi_model(sys);                                                    
 [sys] = sy2_ybus(sys);                                                      
%--------------------------------------------------------------------------


%------------------------------Adjust Data---------------------------------
 [ana, pmu] = pr2_adjust_data_ac(sys, dataSE.analog, dataSE.pmu);
%--------------------------------------------------------------------------
