 function [sys, se] = evaluation_dcse(data, sys, se)

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
%	- sys: power system data
%	- se: state estimation data
%
%  Outputs:
%	- se.estimate with additional columns:
%	  (3)estimated measurement values; (5) exact values
%	- se.error.mae1, se.error.rmse1, se.error.wrss1: errors between
%	  estimated values and corresponding measurement values
%	- se.error.mae2, se.error.rmse2, se.error.wrss2: errors between
%	  estimated values and corresponding exact values
%	- se.error.mae3, se.error.rmse3: errors between estimated state
%	  variables and corresponding exact values
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2017-08-04
% Last revision by Mirsad Cosovic on 2019-04-01
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%----------------------------Estimated Values------------------------------
 Pij = [se.branch; -se.branch];
 
 se.estimate(:,3) = [Pij(sys.Pf.idx); se.bus(sys.Pi.idx, 2); se.bus(sys.Vap.idx, 1)];
%--------------------------------------------------------------------------


%------------------------------Exact Values--------------------------------
 try
  sys.exact = 1;
  se.estimate(:,5) = [data.legacy.flow(sys.Pf.idx,9); data.legacy.injection(sys.Pi.idx,8); data.pmu.voltage(sys.Vap.idx,9)];
  sv_true = data.pmu.voltage(:,9);
  sv_esti = se.bus(:,1);
 catch
  sys.exact = 0;
 end
%--------------------------------------------------------------------------


%-----------------Estimated Values to Measurement Values-------------------
 d1 = se.estimate(:,3) - se.estimate(:,1);

 se.error.mae1  = sum(abs(d1)) / sys.Ntot;
 se.error.rmse1 = ((sum(d1.^2)) / sys.Ntot)^(1/2);
 se.error.wrss1 =  sum(((d1.^2)) ./ se.estimate(:,2));
%--------------------------------------------------------------------------


%--------------------Estimated Values to Exact Values----------------------
 if sys.exact == 1
	d2 = se.estimate(:,3) - se.estimate(:,5);
	d3 = sv_esti - sv_true;

	se.error.mae2 = sum(abs(d2)) / sys.Ntot;
	se.error.mae3 = sum(abs(d3)) / sys.Nbu;

	se.error.rmse2 = ((sum(d2).^2) / sys.Ntot)^(1/2);
	se.error.rmse3 = ((sum(d3).^2)/ sys.Nbu)^(1/2);

	se.error.wrss2 =  sum(((d2).^2) ./ se.estimate(:,2));
 end
%--------------------------------------------------------------------------