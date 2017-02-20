 function pos2_terminal_ac(out, in)



%% Main Informations

 disp(' ')
 disp(' ')
 disp(' ....................:::::::::::::::::::::::::::   State Estimation   :::::::::::::::::::::::::::....................');
 disp(' ')
 fprintf('\tMethod: AC State Estimation\n');
 fprintf(['\tDate: ', datestr(now, 'dd.mm.yyyy HH:MM:SS \n')])
 fprintf('\tStopping condition for iterative process: %s\n ', num2str(in.stop))
 fprintf('\tIterations elapsed time: %2.5f seconds\n', out.t)
 fprintf ('\tNumber of iterations: %d\n', out.No)
 disp(' ')
 

%% Main Table

 b = in.baseMVA;
 A = [in.Bus(:,1) abs(out.V), rad2deg(angle(out.V)), real(out.Si)*b, -imag(out.Si)*b];
 B = [sum(real(out.Si)) sum(-imag(out.Si))]*b;

 disp(' ')
 disp('  _________________________________________________________________________') 
 disp('      Bus     Voltage Magnitude   Voltage Phase           Bus Power')
 disp('                  V [p.u.]           T [deg]          P [MW] | Q [MVAr]')
 disp('  -------------------------------------------------------------------------') 
 fprintf('%8.f %16.4f %17.4f %17.4f %9.4f\n', A') 
 disp('  -------------------------------------------------------------------------') 
 fprintf('\tSum %53.4f %9.4f\n', B') 
 disp('  _________________________________________________________________________') 

%% Reactive Power Flow
 
 typeBT = [repmat({'Branch'}, [1, in.Nli]), repmat({'Transformer'}, [1, in.Ntr])];
 
 disp('   ___________________________________________________________________________________________________________________')
 disp('  |                                                                                                 |                 |')
 disp('  |  No.  Type        From Bus                  Reactive Power Flow [MVAr]                  To Bus  |  Losses [MVAr]  |')
 disp('  |-------------------------------------------------------------------------------------------------|-----------------|')
 for i = 1:in.Nli + in.Ntr   
     fprintf('  | %3.f\t %-11s %5.f %14.4f %16.4f %11.4f %16.4f %7.f     | %11.4f\t  |\n', i, typeBT{i}, in.Br_f(i,1), ...
     imag(out.Smk_f(i))*b, imag(out.Smkb_f(i))*b, imag(out.Smkb_t(i))*b, imag(out.Smk_t(i))*b, in.Br_f(i,2), out.Qlos(i)*b)
     fprintf('  | %45.4f %28.4f %21s| %15s |\n', out.Qinj_f(i)*b, out.Qinj_t(i)*b, [], [])
     disp('  |-------------------------------------------------------------------------------------------------|-----------------|')
 end
 fprintf('  |\t\tSum %37.4f %28.4f %20s | %11.4f\t  |\n', sum(out.Qinj_f*b), sum(out.Qinj_t*b), [], sum(out.Qlos*b))
 disp('  |_________________________________________________________________________________________________|_________________|')

%% Active Powe Flow

 disp('   ___________________________________________________________________________________________________________________')
 disp('  |                                                                                                 |                 |')
 disp('  |  No.  Type        From Bus                    Active Power Flow [MW]                    To Bus  |   Losses [MW]   |')
 disp('  |-------------------------------------------------------------------------------------------------|-----------------|')
 for i = 1:in.Nli + in.Ntr 
     fprintf('  | %3.f\t %-11s %5.f %22.4f %30.4f %15.f    | %11.4f\t  |\n', i, typeBT{i}, in.Br_f(i,1), real(out.Smk_f(i))*b, ... 
     real(out.Smk_t(i))*b, in.Br_f(i,2), (out.Plos(i)+out.Pinj_f(i)+out.Pinj_t(i))*b)
     disp('  |-------------------------------------------------------------------------------------------------|-----------------|')
 end
 fprintf('  |\t\tSum %87s | %11.4f\t  |\n', [],sum((out.Plos + out.Pinj_f + out.Pinj_t)*b))
 disp('  |_________________________________________________________________________________________________|_________________|')

%% Shunt Element

 if any(in.Y_se)
    disp(' ')
    disp('   _____________________________________________________________________________')
    disp('  |                                                                             |')
    disp('  |  Bus   Shunt Element       Reactive Power [MVAr]     Active Power [MW]      |')
    disp('  |-----------------------------------------------------------------------------|')

    for i = 1:length(in.Y_se)
        if in.Y_se(i) ~= 0
           if out.Qsh(i) < 0
              bank = 'Capacitor';
           else
              bank = 'Inductor';
           end
           fprintf('  | %3.f\t\t %-11s %19.4f %23.4f\t\t\t|\n', i, bank, out.Qsh(i)*b, out.Psh(i)*b)
           disp('  |-----------------------------------------------------------------------------|')
        end
    end
    fprintf('  |\t\tSum %32.4f %23.4f\t\t\t|\n', sum(out.Qsh)*b, sum(out.Psh)*b)
    disp('  |_____________________________________________________________________________|')
 end