 function [data, se, af, ai] = restore_observability(data, user, se)

%--------------------------------------------------------------------------
% Adds pseudo-measurements to restore observability.
%
% The function forms pseudo-measurement list and adds pseudo-measurements.
% Pseudo-measurements are defined as regular measurements from input data,
% but variance of those can be defined separately.
%--------------------------------------------------------------------------
%  Inputs:
%	- data: input power system data
%	- user: user inputs
%	- se: state estimation system data
%
%  Outputs:
%	- data: measurement data with pseudo-measurements
%	- se.observe.psm: pseudo-measurement indicators
%	- ai: active power injection measurements with pseudo-measurements
%	- af: active power flow measurements with pseudo-measurements
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-29
% Last revision by Mirsad Cosovic on 2019-04-20
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-------------------------Pseudo-measurement List--------------------------
 fromIsland = se.observe.island(se.branch(:,2),2);
 toIsland   = se.observe.island(se.branch(:,3),2);

 tie = fromIsland ~= toIsland;
 tie = se.branch(tie,2:3);

 injList = unique(tie(:));
 floList = [tie; tie(:,2) tie(:,1)];

 Ni = length(injList);
 Nf = size(floList,1);
%--------------------------------------------------------------------------


%----------------------Pseudo-measurement Jacobians------------------------
 temp = data;
 temp.legacy.injection(:,4) = 0;
 temp.legacy.injection(injList,4) = 1;
 [pi] = injection_dcse(temp.legacy.injection, se);

 on = ismember([se.from se.to], [floList(:,1) floList(:,2)], 'rows');
 temp.legacy.flow(:,5) = 0;
 temp.legacy.flow(on,5) = 1;
 [pf] = flow_dcse(temp.legacy.flow, se);

 Hc = [pi.H; pf.H];
% --------------------------------------------------------------------------


%--------------------------Restore Observability---------------------------
 id = logical(diag(se.D) <= 1e-5);
 Te = speye(se.Nbu, se.Nbu);
 W  = Te(id,:) / se.L;
 B  = (Hc * se.P * W')';

 [~, R, E] = qr(B,0);
 if ~isvector(R)
	diagr = abs(diag(R));
 else
	diagr = R(1);
 end

 r = find(diagr >= (10^-5)*diagr(1), 1, 'last');
 p = sort(E(1:r));

 if isempty(p)
	p = 1;
 end
%--------------------------------------------------------------------------


%---------------------------Pseudo-measurements----------------------------
 inj = (1:Ni)';
 inj = injList(ismember(inj, p));

 data.legacy.injection(inj,3) = user.psvar;
 data.legacy.injection(inj,4) = 1;

 [ai] = injection_dcse(data.legacy.injection, se);

 flo = (Ni+1:1:Ni+Nf)';
 flo = floList(ismember(flo, p),:);
 flo = ismember([se.from se.to], flo, 'rows');

 data.legacy.flow(flo,4) = user.psvar;
 data.legacy.flow(flo,5) = 1;

 [af] = flow_dcse(data.legacy.flow, se);
%--------------------------------------------------------------------------


%----------------------Pseudo-measurement Indicators-----------------------
 injOn = data.legacy.injection(:,4);
 injOn(inj) = 2;

 floOn = data.legacy.flow(:,5);
 floOn(flo) = 2;

 se.observe.psm = [floOn; injOn];
 se.observe.psm = find(se.observe.psm == 2);
%--------------------------------------------------------------------------