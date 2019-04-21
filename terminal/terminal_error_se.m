 function [] = terminal_error_se(in, re)

%--------------------------------------------------------------------------
% Displays state estimation evolution.
%--------------------------------------------------------------------------
%  Inputs:
%	- in: input result data
%	- sys: power system data
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-01-26
% Last revision by Mirsad Cosovic on 2019-04-17
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------

%%  State Estimation Evaluation
 disp(' ')
 disp('   ________________________________________________________________________________________________________')
 disp('  |                                      State Estimation Evaluation                                       |')
 disp('  |                                                                                                        |')
 disp('  |               Description                                MAE              RMSE             WRSS        |')
 disp('  |--------------------------------------------------------------------------------------------------------|')
 fprintf('  |\t Estimate Values and Measurement Values     %20.4e %16.4e %16.4e     |\n', re.error.EstimateMean)
 if in.exact
	fprintf('  |\t Estimate Values and Exact Values           %20.4e %16.4e %16.4e     |\n', re.error.EstimateExact)
	fprintf('  |\t Estimate State Variables and Exact Values  %20.4e %16.4e  \t\t\t\t\t   |\n', re.error.EstimateExactState(1:2))
 end
 disp('  |________________________________________________________________________________________________________|')