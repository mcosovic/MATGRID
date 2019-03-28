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
	V = in.bus(:,1);
	b = sys.base;
	A = [sys.bus(:,15)  abs(V)  (angle(V))*180/pi  real(in.bus(:,2))*b  imag(in.bus(:,2))*b  real(in.bus(:,3))*b ...
		imag(in.bus(:,3))*b   real(in.bus(:,4))*b  imag(in.bus(:,4))*b  real(in.bus(:,5))*b  imag(in.bus(:,5))*b];
	B = [sum(real(in.bus(:,2))) sum(imag(in.bus(:,2))) sum(real(in.bus(:,3))) sum(imag(in.bus(:,3))) ...
		sum(real(in.bus(:,4))) sum(imag(in.bus(:,4))) sum(real(in.bus(:,5))) sum(imag(in.bus(:,5)))]*b;

	disp(' ')
	disp('   ___________________________________________________________________________________________________________________________________________________')
	disp('  |     Bus                Voltage               Injection Power      |        Generation              Consumption        |       Shunt Element       |')
	disp('  |                   Vm[pu]  |  Va[deg]        P[MW]  |  Q[MVAr]     |     P[MW]  |  Q[MVAr]       P[MW]  |  Q[MVAr]     |     P[MW]  |  Q[MVAr]     |')
	disp('  | ------------------------------------------------------------------|---------------------------------------------------|---------------------------|')
	fprintf('  |\t    %-8.f %11.4f %11.4f %12.2f  %10.2f     | %9.2f %11.2f %11.2f %11.2f     | %9.2f %11.2f     |\n', A')
	disp('  |-------------------------------------------------------------------|---------------------------------------------------|---------------------------|')
	fprintf('  |\tSum %45.2f %11.2f     | %9.2f %11.2f %11.2f %11.2f     | %9.2f %11.2f     |\n', B')
	disp('  |___________________________________________________________________|___________________________________________________|___________________________|')
 end

%% Bus Data for the DC power Flow
 if ismember('dc', user)
	b = sys.base;
	A = [sys.bus(:,15)  ones(sys.Nbu, 1)  180/pi*in.bus(:,1)  in.bus(:,2)*b  in.bus(:,3)*b  sys.bus(:,5)*b  sys.bus(:,7)*b];
	B = [sum(in.bus(:,2))  sum(in.bus(:,3))  sum(sys.bus(:,5))  sum(sys.bus(:,7))]*b;

	disp(' ')
	disp('   _________________________________________________________________________________________________________________________________')
	disp('  |     Bus                Voltage               Injection Power     |     Generation       Consumption     |     Shunt Element     |')
	disp('  |                   Vm[pu]  |  Va[deg]              P[MW]          |        P[MW]            P[MW]        |         P[MW]         |')
	disp('  | -----------------------------------------------------------------|--------------------------------------|-----------------------|')
    fprintf('  |\t    %-8.f %11.4f %11.4f %18.2f          | %12.2f %16.2f        | %13.2f         |\n', A')
	disp('  |------------------------------------------------------------------|--------------------------------------|-----------------------|')
	fprintf('  |\tSum %51.2f          | %12.2f %16.2f        | %13.2f         |\n', B')
	disp('  |__________________________________________________________________|______________________________________|_______________________|')

 end