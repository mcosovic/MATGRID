 function leeloo(choose)


 
%--------------------------Read Data from GUI------------------------------
 sys.method = find([choose{3:4}] == 1);
 sys.acdc   = find([choose{1:2}] == 1);
 sys.disp   = choose{7};
 
 if sys.method == 1 
    load(char(choose{6}(choose{5})));
 else
    run(char(choose{6}(choose{5})));
    variable = who;                                                             
    dataSE   = struct;                                                       
    
    for i = 1:numel(variable)                                                   
        dataSE.(variable{i}) = eval(variable{i});
    end
    dataSE = rmfield(dataSE, {'choose', 'sys'});
 end
%--------------------------------------------------------------------------


%--------------------------State Estimation--------------------------------
 if sys.acdc == 1
    [sys, ana, pmu]  = pr1_process_ac(dataSE, sys);
    [out, alg, idpa] = gn1_gauss_newton(sys, ana, pmu); 
    [out]            = po1_process_ac(dataSE, sys, ana, pmu, alg, idpa, out);
    
    dp1_disp_ac(sys, ana, pmu, out)
 end   
 
 if sys.acdc == 2
     [sys, ana, pmu] = pr1_pr_process_dc(dataSE, sys);  
     [out]           = dc1_wls_qr(sys, ana, pmu);   
     [out]           = po1_process_dc(dataSE, sys, ana, pmu, out);
     
     dp1_disp_dc(sys, ana, pmu, out);
 end
%--------------------------------------------------------------------------


%--------------------Save Results in the Workspace-------------------------
 assignin('base', 'dataSE', dataSE); 
 assignin('base', 'out', out);
%--------------------------------------------------------------------------
