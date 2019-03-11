 function [] = terminal_evaluation_se(sys, se)



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