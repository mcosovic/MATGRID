 function [se] = error_dcse(data, se)

%--------------------------------------------------------------------------
% Computes different metrics used to measure the accuracy of the DC state
% estimation.
%
% The function computes the root mean squared error (RMSE), mean absolute
% error (MAE) and weighted residual sum of squares (WRSS) between estimated
% values and: i) corresponding measurement values; ii) corresponding exact
% values
%--------------------------------------------------------------------------
%  Inputs:
%	- data: input power system data with measurements
%	- se: state estimation data
%
%  Outputs:
%	- se.error(:,1): errors between estimated values and corresponding
%	  measurement values
%	- se.error(:,2): errors between estimated values and corresponding
%	  exact values
%	- se.error(:,3): errors between estimated state variables and c
%	  corresponding exact values
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2017-08-04
% Last revision by Mirsad Cosovic on 2019-04-20
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-----------------Estimated Values to Measurement Values-------------------
 Ntot = se.Nleg + se.Npmu;

 MAE  = sum(se.estimate(:,4)) / Ntot;
 RMSE = ((sum(se.estimate(:,4).^2)) / Ntot)^(1/2);
 WRSS =  sum(((se.estimate(:,4).^2)) ./ se.estimate(:,2));

 se.error = [MAE; RMSE; WRSS];
%--------------------------------------------------------------------------


%--------------------Estimated Values to Exact Values----------------------
 if se.exact
	d = se.Va - data.pmu.voltage(:,9);

	MAE2 = sum(se.estimate(:,6)) / Ntot;
	MAE3 = sum(abs(d)) / se.Nbu;

	RMSE2 = ((sum(se.estimate(:,6)).^2) / Ntot)^(1/2);
	RMSE3 = ((sum(d).^2)/ se.Nbu)^(1/2);

	WRSS2 = sum(((se.estimate(:,6)).^2) ./ se.estimate(:,2));

	se.error(:,2) = [MAE2; RMSE2; WRSS2];
	se.error(:,3) = [MAE3; RMSE3; 0];
 end
%--------------------------------------------------------------------------