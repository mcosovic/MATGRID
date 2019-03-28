 function [] = terminal_error_se(sys, se)

%--------------------------------------------------------------------------
% Displays state estimation evolutaion.
%--------------------------------------------------------------------------
%  Inputs:
%	- sys: power system data
%	- se: state estimation result data
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-01-26
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------

%%  State Estimation Evaluation
 disp(' ')
 disp('   ________________________________________________________________________________________________________')
 disp('  |                                      State Estimation Evaluation                                       |')
 disp('  |                                                                                                        |')
 disp('  |               Description                                MAE              RMSE             WRSS        |')
 disp('  |--------------------------------------------------------------------------------------------------------|')
 fprintf('  |\t Estimate Values and Measurement Values     %20.4e %16.4e %16.4e     |\n', [se.error.mae1  se.error.rmse1  se.error.wrss1])
 if sys.exact == 1
	fprintf('  |\t Estimate Values and Exact Values           %20.4e %16.4e %16.4e     |\n', [se.error.mae2  se.error.rmse2  se.error.wrss2])
	fprintf('  |\t Estimate State Variables and Exact Values  %20.4e %16.4e  \t\t\t\t\t   |\n', [se.error.mae3  se.error.rmse3])
 end
 disp('  |________________________________________________________________________________________________________|')