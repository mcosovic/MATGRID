 function [out] = po3_evaluation_ac(dataSE, sys, ana, pmu, alg, idpa, out)

 
 
%----------------------------------Data------------------------------------
 if sys.method == 1
    out.true = [dataSE.analog.flow(:,8); dataSE.analog.flow(:,9); 
                dataSE.analog.current(:,6); dataSE.analog.injection(:,7); 
                dataSE.analog.injection(:,8); dataSE.analog.voltage(:,5); 
                dataSE.pmu.voltage(:,6); dataSE.pmu.voltage(:,7);  
                dataSE.pmu.current(:,7); dataSE.pmu.current(:,8)]; 
            
    out.true = out.true([ana.on; pmu.on]);             
 end
%--------------------------------------------------------------------------  

 
%-----------------------------Data SE--------------------------------------
 V = abs(out.Vc);
 T = angle(out.Vc);
 
 [Fflo, ~] = gn4_flow_eqn_jac(V, alg, idpa.pij, idpa.qij);
 [Fcur, ~] = gn5_curr_eqn_jac(V, alg, idpa.imij); 
 [Finj, ~] = gn6_injc_eqn_jac(V, alg, idpa.pi, idpa.qi);
 [Fcph, ~] = gn7_cuph_eqn_jac(V, T, alg, idpa.icij);
 [Fvol]    = gn8_volt_eqn(V, T, idpa.vma, idpa.vmp, idpa.ti);
 Icij      = Fcph(1:pmu.Nicij) + Fcph(pmu.Nicij + 1:end) * 1i;
 
 out.f = [Fflo; Fcur; Finj; Fvol; abs(Icij); angle(Icij)];
 
 Icij  = pmu.Icij(:,3) + pmu.Icij(:,4) * 1i;
 out.z = [ana.z; pmu.Vi(:,2); pmu.Ti(:,2); abs(Icij); angle(Icij)];
 N     = size(out.z, 1);
 out.s = [ana.s; pmu.s];
 
 if sys.method == 1
    sv_true = [dataSE.pmu.voltage(:,6); dataSE.pmu.voltage(:,7)];
    sv_esti = [V; T];
    Nsv     = 2 * sys.Nbu;
 end
%-------------------------------------------------------------------------- 


%---------------------State Estimation Evaluation--------------------------
 out.MAE1  = sum(abs(out.z - out.f)) / N; 
 out.RMSE1 = ((sum(out.z - out.f).^2) / N)^(1/2); 
 out.WRSS1 =  sum(((out.z - out.f).^2) ./ (out.s.^2));
 
 if sys.method == 1
    out.MAE2 = sum(abs(out.true - out.f)) / N;
    out.MAE3 = sum(abs(sv_true - sv_esti)) / Nsv;
 
    out.RMSE2 = ((sum(out.true - out.f).^2) / N)^(1/2); 
    out.RMSE3 = ((sum(sv_true - sv_esti).^2)/ Nsv)^(1/2);   
      
    out.WRSS2 =  sum(((out.true - out.f).^2) ./ (out.s.^2));
 end   
%-------------------------------------------------------------------------- 


%------------------------Postprocessing Time-------------------------------
 out.pos_time = toc;
%--------------------------------------------------------------------------