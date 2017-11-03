 function [sys, ana, pmu] =  pr1_process_dc(dataSE, sys)
 
 
 
%------------------------------Variables-----------------------------------
 sys.line    = dataSE.system.line; 
 sys.slack   = dataSE.system.slack; 
 sys.Nbu     = dataSE.system.Nbu; 
 sys.baseMVA = dataSE.system.baseMVA;
 
 if isfield(dataSE.system, 'transformer')  
    sys.transformer = dataSE.system.transformer;
 end
%--------------------------------------------------------------------------
 
 
%-----------------------Forming Brancehs and YBus--------------------------
 tic
 sys.bus = [(1:sys.Nbu)' zeros(sys.Nbu,4)];
 [sys] = sy1_pi_model(sys);                                                    
 sys.Br(:,4:5) = zeros(sys.Nbr, 2);                                            
 [sys] = sy2_ybus(sys);                                                      
%--------------------------------------------------------------------------


%------------------------------Adjust Data---------------------------------
 [ana, pmu] = pr2_adjust_data_dc(sys, dataSE.analog, dataSE.pmu);
%--------------------------------------------------------------------------