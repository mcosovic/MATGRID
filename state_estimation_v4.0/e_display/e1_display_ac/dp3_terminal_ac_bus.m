 function dp3_terminal_ac_bus(sys, out)
 
 
 
%% Bus Table

 b = sys.baseMVA;
 p = (180 / pi);
 A = [sys.bus(:,1) abs(out.Vc), (angle(out.Vc)) * p, real(out.Si) * b, -imag(out.Si) * b];
 B = [sum(real(out.Si)) sum(-imag(out.Si))] * b;

 disp(' ')
 disp('  _________________________________________________________________________') 
 disp('      Bus     Voltage Magnitude   Voltage Angle           Bus Power')
 disp('                   Vm [pu]          Va [deg]          P [MW] | Q [MVAr]')
 disp('  -------------------------------------------------------------------------') 
 fprintf('%8.f %16.4f %17.4f %17.4f %9.4f\n', A') 
 disp('  -------------------------------------------------------------------------') 
 fprintf('\tSum %53.4f %9.4f\n', B') 
 disp('  _________________________________________________________________________') 

