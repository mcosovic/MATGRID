 function leeloo(choose)


%--------------------------Read Data from GUI------------------------------
 method = find([choose{3:4}] == 1);
 acdc = find([choose{1:2}] == 1);
 
 if method == 1 
    load(char(choose{6}(choose{5})));
    dataSE.unit = {'mega', 'mega', 'deg'};
 else
    run(char(choose{6}(choose{5})));
    variable = who;                                                             
    dataSE   = struct;                                                         
    
    for i = 1:numel(variable)                                                   
        dataSE.(variable{i}) = eval(variable{i});
    end
    dataSE = rmfield(dataSE, {'choose', 'method'});
 end
%--------------------------------------------------------------------------


%----------------------------AC Power Flow---------------------------------
 if acdc == 1
    [in] = pre1_pi_model(dataSE);
    [in] = pre2_ybus(in);
    [in] = pre3_adjust_data(in);
    
    [out, in] = gn2_Gauss_Newton(in);
    [out] = pos1_post_processing(in, out); 
    pos2_terminal_ac(out, in)
   
    if method == 1
       pos3_termianl_acpf(in, out)
    end
 end   
 
 if acdc == 2
     if method == 2
        dataSE.Nbu = size(dataSE.Injection,1);
     end
     [in] =  dc1_pre_processing(dataSE);
     [out] = dc2_estimation(in);
     pos4_terminal_dc(out, in)
      
     if method == 1
        pos5_termianl_dcpf(in, out)
     end 
 end
%--------------------------------------------------------------------------

%------------------Save results in the Workspace---------------------------
 assignin('base', 'out', out);                                         
%--------------------------------------------------------------------------