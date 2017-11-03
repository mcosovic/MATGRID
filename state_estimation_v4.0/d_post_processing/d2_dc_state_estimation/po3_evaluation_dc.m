 function [out] = po3_evaluation_dc(dataSE, sys, ana, pmu, out)

 
 
%----------------------------------Data------------------------------------
 if sys.method == 1
    out.true = [dataSE.analog.flow(:,6); dataSE.analog.injection(:, 5); 
             dataSE.pmu.voltage(:, 5)];

    out.true = out.true([ana.on; pmu.on]);
    sv_true  = dataSE.pmu.voltage(:,5); 
    sv_esti  = out.T;
    Nsv      = sys.Nbu;
 end
 
 N     = ana.Nana + pmu.Nti;
 out.s = [ana.s; pmu.s];
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