 function terminal_bus_pf(in, sys, user)

%--------------------------------------------------------------------------
% Displays power flow bus data.
%--------------------------------------------------------------------------
%  Inputs:
%	- in: input result data
%	- sys: power system data
%	- user: user input list
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-01-26
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%% Bus Data for the AC power Flow
 if any(ismember({'nr', 'gs', 'dnr', 'fdnr'}, user))
	A = [in.bus.Bus in.bus.Vmag in.bus.Vang in.bus.Pinj in.bus.Qinj in.bus.Pgen in.bus.Qgen in.bus.Pload in.bus.Qload in.bus.Psh in.bus.Qsh];
	B = [sum(in.bus.Pinj) sum(in.bus.Qinj) sum(in.bus.Pgen) sum(in.bus.Qgen) sum(in.bus.Pload) sum(in.bus.Qload) sum(in.bus.Psh) sum(in.bus.Qsh)];

	disp(' ')
	disp('   ___________________________________________________________________________________________________________________________________________________')
	disp('  |     Bus                Voltage               Injection Power      |        Generation              Consumption        |       Shunt Element       |')
	disp('  |                   Vm[pu]  |  Va[deg]        P[MW]  |  Q[MVAr]     |     P[MW]  |  Q[MVAr]       P[MW]  |  Q[MVAr]     |     P[MW]  |  Q[MVAr]     |')
	disp('  | ------------------------------------------------------------------|---------------------------------------------------|---------------------------|')
	fprintf('  |     %-8.f %11.4f %11.4f %12.2f  %10.2f     | %9.2f %11.2f %11.2f %11.2f     | %9.2f %11.2f     |\n', A')
	disp('  |-------------------------------------------------------------------|---------------------------------------------------|---------------------------|')
	fprintf('  |  Sum %44.2f %11.2f     | %9.2f %11.2f %11.2f %11.2f     | %9.2f %11.2f     |\n', B')
	disp('  |___________________________________________________________________|___________________________________________________|___________________________|')
 end

%% Bus Data for the DC power Flow
 if ismember('dc', user)
	A = [in.bus.Bus ones(sys.Nbu,1) in.bus.Vang in.bus.Pinj in.bus.Pgen in.bus.Pload in.bus.Psh];
	B = [sum(in.bus.Pinj) sum(in.bus.Pgen) sum(in.bus.Pload) sum(in.bus.Psh)];

	disp(' ')
	disp('   _________________________________________________________________________________________________________________________________')
	disp('  |     Bus                Voltage               Injection Power     |     Generation       Consumption     |     Shunt Element     |')
	disp('  |                   Vm[pu]  |  Va[deg]              P[MW]          |        P[MW]            P[MW]        |         P[MW]         |')
	disp('  | -----------------------------------------------------------------|--------------------------------------|-----------------------|')
    fprintf('  |     %-8.f %11.4f %11.4f %18.2f          | %12.2f %16.2f        | %13.2f         |\n', A')
	disp('  |------------------------------------------------------------------|--------------------------------------|-----------------------|')
	fprintf('  |  Sum %50.2f          | %12.2f %16.2f        | %13.2f         |\n', B')
	disp('  |__________________________________________________________________|______________________________________|_______________________|')
 end