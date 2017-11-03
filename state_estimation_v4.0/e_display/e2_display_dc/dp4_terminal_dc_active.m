 function dp4_terminal_dc_active(sys, out)


 
%% Active Powe Flow

 b      = sys.baseMVA; 
 typeBT = [repmat({'Line'}, [1, sys.Nli]), repmat({'Transformer'}, [1, sys.Ntr])];

 disp(' ')
 disp('   _____________________________________________________________________')
 disp('  |                                                                     |')
 disp('  |  No.  Type         From Bus     Active Power Flow [MW]     To Bus   |')
 disp('  |---------------------------------------------------------------------|') 

 for i = 1:sys.Nli + sys.Ntr 
     fprintf('  |\t  %-3.f %-11s %5.f %17.4f %12.4f %8.f\t\t|\n', i, typeBT{i}, ...
     sys.LiTr(i,1), out.Pij(i)*b, -out.Pij(i)*b, sys.LiTr(i,2))
     disp('  |---------------------------------------------------------------------|')
 end
 disp('  |_____________________________________________________________________|')
