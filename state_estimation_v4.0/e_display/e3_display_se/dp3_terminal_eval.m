 function [] = dp3_terminal_eval(sys, out)
 
 disp(' ')
 disp('   ___________________________________________________________________________________________________________________') 
 disp('  |                                              State Estimation Evaluation                                          |')
 disp('  |                                                                                                                   |')
 disp('  |               Description                                        MAE               RMSE               WRSS        |')
 disp('  |-------------------------------------------------------------------------------------------------------------------|')
 fprintf('  |\t Measurements and Corresponding Estimate Values            %12.4e %18.4e %18.4e \t  |\n', [out.MAE1 out.RMSE1 out.WRSS1])
 
 if sys.method == 1
 fprintf('  |\t True Electrical Values and Corresponding Estimate Values  %12.4e %18.4e %18.4e \t  |\n', [out.MAE2 out.RMSE2 out.WRSS2])
 fprintf('  |\t True State Variable and Estimate State Variables          %12.4e %18.4e  \t\t\t\t\t  |\n', [out.MAE3 out.RMSE3])
 end
 disp('  |___________________________________________________________________________________________________________________|') 
 
 
 