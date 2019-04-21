 function terminal_flow(in, sys, user)

%--------------------------------------------------------------------------
% Displays power flow.
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


%% AC Power Flow
 if any(ismember({'nr', 'gs', 'dnr', 'fdnr', 'nonlinear', 'pmu'}, user))
	A = [sys.branch(:,1) in.branch.From in.branch.Pfrom in.branch.Qfrom in.branch.Pto in.branch.Qto in.branch.To in.branch.Qinj in.branch.Ploss in.branch.Qloss];

	disp(' ')
	disp('   _____________________________________________________________________________________________________________________________________________')
	disp('  |                             Active and Reactive Power Flow                              |     Injection     |     Series Impedance Loss     |')
	disp('  |                                                                                         |                   |                               |')
	disp('  |     No.      From Bus       P[MW]  |  Q[MVAr]         P[MW]  |  Q[MVAr]      To Bus     |      Q[MVAr]      |       P[MW]  |  Q[MVAr]       |')
	disp('  |-----------------------------------------------------------------------------------------|-------------------|-------------------------------|')
	fprintf('  |     %-8.f %6.f %13.2f %11.2f %13.2f %11.2f %10.f      | %12.2f      | %11.2f %11.2f       |\n', A')
	disp('  |-----------------------------------------------------------------------------------------|-------------------|-------------------------------|')
	fprintf('  |  Sum %82s | %12.2f      | %11.2f %11.2f       |\n', [], sum(in.branch.Qinj), sum(in.branch.Ploss), sum(in.branch.Qloss))
	disp('  |_________________________________________________________________________________________|___________________|_______________________________|')
 end

%% DC Power Flow
 if ismember('dc', user)
	A = [sys.branch(:,1) in.branch.From in.branch.Pflow -in.branch.Pflow in.branch.To];

	disp(' ')
	disp('   _________________________________________________________________')
	disp('  |                        Active Power Flow                        |')
	disp('  |                                                                 |')
	disp('  |     No.      From Bus       P[MW]         P[MW]      To Bus     | ')
	disp('  |-----------------------------------------------------------------|')
	fprintf('  |     %-8.f %6.f %13.2f %13.2f %10.f      |\n', A')
	disp('  |-----------------------------------------------------------------|')
	disp('  |_________________________________________________________________|')
 end