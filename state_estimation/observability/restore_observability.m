 function [data, se] = restore_observability(data, sys, obs, se, bra, user)

%--------------------------------------------------------------------------
% Adds pseudo-measurements to restore observability.
%
% The function forms pseudo-measurement list and adds pseudo-measurements.
% Pseudo-measurements are defined as regular measurements from input data,
% but variance of those can be defined separately.
%--------------------------------------------------------------------------
%  Input:
%	- data: input power system data
%	- sys: power system data
%	- obs: observability analysis data
%	- se: state estimation data
%	- bra: state estimation data
%	- user: user input list
%	- br: branch indexes and parameters
%
%  Output:
%	- se.observe.injection: active power injection pseudo-measurement data
%	- se.observe.flow: active power flow pseudo-measurement data
%	- data: pseudo_measurment are active
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-29
% Last revision by Mirsad Cosovic on 2019-04-07
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-------------------------Pseudo-measurement List--------------------------
 fromIs = se.observe.island(se.observe.branch(:,1),2);
 toIs = se.observe.island(se.observe.branch(:,2),2);

 bound = fromIs ~= toIs;
 bound = se.observe.branch(bound,1:2);

 injList = unique(bound(:));
 floList = [bound; bound(:,2) bound(:,1)];

 Ni = length(injList);
 Nf = size(floList,1);
%--------------------------------------------------------------------------


%----------------------Pseudo-measurement Jacobians------------------------
 Hi = sys.Ai(:,injList)' * sys.Ai;

 n  = (1:Nf)';
 i  = [n; n];
 j  = [floList(:,1); floList(:,2)];
 c  = ones(Nf,1);
 Hf = sparse(i, j, [c; -c], Nf, sys.Nbu);

 Hc = [Hi; Hf];
%--------------------------------------------------------------------------


%--------------------------Restore Observability---------------------------
 Li = (obs.L) \ speye(sys.Nbu, sys.Nbu);
 U  = round(obs.D*10^5)/10^5;
 id = logical(diag(U) == 0);
 W  = Li(id,:);

 B  = (Hc * obs.P * W')';

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

 inj = (1:Ni)';
 flo = (Ni+1:1:Ni+Nf)';

 idxInj = injList(ismember(inj, p));

 idxFlo = floList(ismember(flo, p),:);
 idxFlo = ismember([bra.i bra.j], idxFlo, 'rows');

 data.legacy.injection(idxInj,4) = 1;
 data.legacy.flow(idxFlo,5) = 1;

 data.legacy.injection(idxInj,3) = user.psvar;
 data.legacy.flow(idxFlo,4) = user.psvar;

 se.observe.injection = data.legacy.injection(idxInj,1:3);
 se.observe.flow = data.legacy.flow(idxFlo,1:4);
%--------------------------------------------------------------------------