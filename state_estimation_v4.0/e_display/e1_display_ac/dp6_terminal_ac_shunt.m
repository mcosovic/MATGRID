 function dp6_terminal_ac_shunt(sys, out)
 
 
 
%% Shunt Element
 
 b = sys.baseMVA;

 if ~isempty(sys.sh)
    disp(' ')
    disp('   _____________________________________________________________________________')
    disp('  |                                                                             |')
    disp('  |  Bus   Shunt Element       Reactive Power [MVAr]     Active Power [MW]      |')
    disp('  |-----------------------------------------------------------------------------|')

    for i = 1:length(sys.sh)
        if out.Qsh(sys.sh(i)) < 0
           bank = 'Capacitor';
        else
           bank = 'Inductor';
        end
           fprintf('  | %3.f\t\t %-11s %19.4f %23.4f\t\t\t|\n', sys.sh(i), bank, out.Qsh(sys.sh(i))*b, out.Psh(sys.sh(i))*b)
           disp('  |-----------------------------------------------------------------------------|')
    end
    fprintf('  |\t\tSum %32.4f %23.4f\t\t\t|\n', sum(out.Qsh)*b, sum(out.Psh)*b)
    disp('  |_____________________________________________________________________________|')
 end
 