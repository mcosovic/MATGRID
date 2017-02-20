 function pos4_terminal_dc(out, in)


 
%% Main Information

 disp(' ')
 disp(' ')
 disp(' ....................:::::::::::::::::::::::::::   State Estimation   :::::::::::::::::::::::::::....................');
 disp(' ')
 fprintf('\tMethod: DC State Estimation\n');
 fprintf(['\tDate: ', datestr(now, 'dd.mm.yyyy HH:MM:SS \n')])
 disp(' ')
 
%% Main Table

 b = in.baseMVA; 
 A = [in.Bus(:,1) ones(in.Nbu, 1) rad2deg(out.Teta) out.Pbus*b];

 disp('  ________________________________________________________________') 
 disp('      Bus     Voltage Magnitude    Voltage Phase     Bus Power')
 disp('                    [pu]               [deg]          P [MW]')
 disp('  ----------------------------------------------------------------') 
 fprintf('%8.f %16.4f %18.4f %15.4f\n', A') 
 disp('  ----------------------------------------------------------------') 
 fprintf('\t\tSum %48.4f\n', sum(out.Pbus)*b) 
 disp('  ________________________________________________________________')
 
%% Active Powe Flow

 typeBT = [repmat({'Line'}, [1, in.Nli]), repmat({'Transformer'}, [1, in.Ntr])];

 disp(' ')
 disp('   _________________________________________________________________________')
 disp('  |                                                                         |')
 disp('  |  No.      Type         From Bus     Active Power Flow [MW]     To Bus   |')
 disp('  |-------------------------------------------------------------------------|') 

 for i = 1:in.Nli + in.Ntr 
     fprintf('  | %3.f\t\t %-11s %6.f %16.4f %12.4f %8.f\t\t|\n', i, typeBT{i}, ...
     in.Br_f(i,1), out.Pbch(i)*b, -out.Pbch(i)*b, in.Br_f(i,2))
     disp('  |-------------------------------------------------------------------------|')
 end
 disp('  |_________________________________________________________________________|')
