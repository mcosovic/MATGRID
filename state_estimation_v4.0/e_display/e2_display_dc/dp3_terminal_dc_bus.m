 function dp3_terminal_dc_bus(sys, out)


 
%% Main Table

 b = sys.baseMVA; 
 p = 180 / pi;
 A = [sys.bus(:,1) ones(sys.Nbu, 1) out.T * p out.Pi * b];

 disp('  ________________________________________________________________') 
 disp('      Bus     Voltage Magnitude    Voltage Angle     Bus Power')
 disp('                   Vm [pu]           Va [deg]         P [MW]')
 disp('  ----------------------------------------------------------------') 
 fprintf('%8.f %16.4f %18.4f %15.4f\n', A') 
 disp('  ----------------------------------------------------------------') 
 fprintf('\t\tSum %48.4f\n', sum(out.Pi)*b) 
 disp('  ________________________________________________________________')
 
