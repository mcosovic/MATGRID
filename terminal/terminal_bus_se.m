 function terminal_bus_se(in, sys, user)

%--------------------------------------------------------------------------
% Displays bus data after state estimation algorithms.
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


%% Bus Data for the Non-linear and PMU State Estimation
 if any(ismember({'nonlinear', 'pmu'}, user))
    b = sys.base;
    A = [sys.bus(:,15)  abs(in.bus(:,1))  (angle(in.bus(:,1)))*180/pi  real(in.bus(:,2))*b  imag(in.bus(:,2))*b  real(in.bus(:,3))*b  imag(in.bus(:,3))*b];
    B = [sum(real(in.bus(:,2))) sum(imag(in.bus(:,2))) sum(real(in.bus(:,3))) sum(imag(in.bus(:,3)))]*b;


	disp(' ')
	disp('   _______________________________________________________________________________________________')
	disp('  |     Bus                Voltage               Injection Power      |       Shunt Element       |')
	disp('  |                   Vm[pu]  |  Va[deg]        P[MW]  |  Q[MVAr]     |     P[MW]  |  Q[MVAr]     |')
	disp('  | ------------------------------------------------------------------|---------------------------|')
	fprintf('  |\t    %-8.f %11.4f %11.4f %12.2f  %10.2f     | %9.2f %11.2f     |\n', A')
	disp('  |-------------------------------------------------------------------|---------------------------|')
	fprintf('  |\tSum %45.2f %11.2f     | %9.2f %11.2f     |\n', B')
	disp('  |___________________________________________________________________|___________________________|')
 end

%% Bus Data for the DC State Estimation
 if ismember('dc', user)
    b = sys.base;
    p = 180 / pi;
    A = [sys.bus(:,15)  ones(sys.Nbu, 1)  in.bus(:,1)*p  in.bus(:,2)*b  -sys.bus(:,7)*b];
    B = [sum(in.bus(:,2))*b  -sum(sys.bus(:,7))*b];

	disp(' ')
	disp('   __________________________________________________________________________________________')
	disp('  |     Bus                Voltage               Injection Power     |     Shunt Element     |')
	disp('  |                   Vm[pu]  |  Va[deg]              P[MW]          |         P[MW]         |')
	disp('  | -----------------------------------------------------------------|-----------------------|')
    fprintf('  |\t    %-8.f %11.4f %11.4f %18.2f          | %13.2f         |\n', A')
	disp('  |------------------------------------------------------------------|-----------------------|')
	fprintf('  |\tSum %51.2f          | %13.2f         |\n', B')
	disp('  |__________________________________________________________________|_______________________|')
 end