 function dp4_terminal_ac_reactive(sys, out)
 
 

%% Reactive Power Flow

 b      = sys.baseMVA;
 typeBT = [repmat({'Line'}, [1, sys.Nli]), repmat({'Transformer'}, [1, sys.Ntr])];
 
 disp('   _____________________________________________________________________________________________________________________')
 disp('  |                                                                                                   |                 |')
 disp('  |  No.   Type       From Bus                  Reactive Power Flow [MVAr]                  To Bus    |  Losses [MVAr]  |')
 disp('  |---------------------------------------------------------------------------------------------------|-----------------|')
 for i = 1:sys.Nli + sys.Ntr   
     fprintf('  |\t  %-4.f %-11s %5.f %14.4f %16.4f %11.4f %16.4f %7.f     | %11.4f\t    |\n', i, typeBT{i}, sys.LiTr(i,1), ...
     imag(out.Sij(i))*b, imag(out.Sb_ij(i))*b, imag(out.Sb_ji(i))*b, imag(out.Sji(i))*b, sys.LiTr(i,2), out.Qlos(i)*b)
     fprintf('  | %47.4f %28.4f %21s| %15s |\n', out.Qs_i(i)*b, out.Qs_j(i)*b, [], [])
     disp('  |---------------------------------------------------------------------------------------------------|-----------------|')
 end
 fprintf('  |\t\tSum %39.4f %28.4f %20s | %11.4f\t    |\n', sum(out.Qs_i*b), sum(out.Qs_j*b), [], sum(out.Qlos*b))
 disp('  |___________________________________________________________________________________________________|_________________|')
 
