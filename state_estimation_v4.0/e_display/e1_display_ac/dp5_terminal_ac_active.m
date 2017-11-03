 function dp5_terminal_ac_active(sys, out)
 
 
 
%% Active Powe Flow

 b      = sys.baseMVA;
 typeBT = [repmat({'Line'}, [1, sys.Nli]), repmat({'Transformer'}, [1, sys.Ntr])];

 disp('   ___________________________________________________________________________________________________________________')
 disp('  |                                                                                                 |                 |')
 disp('  |  No.  Type        From Bus                    Active Power Flow [MW]                    To Bus  |   Losses [MW]   |')
 disp('  |-------------------------------------------------------------------------------------------------|-----------------|')
 for i = 1:sys.Nli + sys.Ntr 
     fprintf('  |\t  %-3.f %-11s %4.f %22.4f %30.4f %15.f    | %11.4f\t  |\n', i, typeBT{i}, sys.LiTr(i,1), real(out.Sij(i))*b, ... 
     real(out.Sji(i))*b, sys.LiTr(i,2), (out.Plos(i)+out.Ps_i(i) + out.Ps_j(i))*b)
     disp('  |-------------------------------------------------------------------------------------------------|-----------------|')
 end
 fprintf('  |\t\tSum %87s | %11.4f\t  |\n', [],sum((out.Plos + out.Ps_i + out.Ps_j)*b))
 disp('  |_________________________________________________________________________________________________|_________________|')
 