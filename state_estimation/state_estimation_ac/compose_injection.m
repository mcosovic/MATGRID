 function [sys] = compose_injection(inj, sys)

%--------------------------------------------------------------------------
% Builds data associated with active and reactive power injection
% measurements.
%
% The function defines the active and reactive power injection measurement
% data according to available measurements (i.e., turn on measurements).
%--------------------------------------------------------------------------
%  Inputs:
%	- inj: legacy power injection measurement data
%	- sys: power system data
%
%  Outputs:
%	- sys.Pi: set indexes and parameters associated with active power
%	  injection measurements
%	- sys.Qi: set indexes and parameters associated with reactive power
%	  injection measurements
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-02-26
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%---------------Active Power Injection Legacy Measurements-----------------
 sys.Pi.idx = logical(inj(:,4));
 sys.Pi.z   = inj(sys.Pi.idx,2);
 sys.Pi.v   = inj(sys.Pi.idx,3);
 sys.Pi.N   = size(sys.Pi.z,1);

 [i, j] = find(sys.Ybu);
 sys.Pi.bus = sys.bus(sys.Pi.idx,1);
 idx1 = ismember(i, sys.Pi.bus);
 sys.Pi.i = i(idx1);
 sys.Pi.j = j(idx1);

 Ybus = sys.Ybu(sys.Pi.bus,:);
 idx2 = find(Ybus);
 [sys.Pi.ii, ~] = find(Ybus);
 sys.Pi.Gij = real(Ybus(idx2));
 sys.Pi.Bij = imag(Ybus(idx2));
 
 lnidx = sub2ind(size(sys.Ybu), sys.Pi.bus, sys.Pi.bus);
 sys.Pi.Gii = real(sys.Ybu(lnidx));
 sys.Pi.Bii = imag(sys.Ybu(lnidx));

 sys.Pi.ij = sys.Pi.i ~= sys.Pi.j;

 [r, c]   = find(sys.Yij(sys.Pi.bus,:));
 [rr, cc] = find(sys.Yii(sys.Pi.bus,:));

 if sys.Pi.N == 1
	sys.Pi.ii  = sys.Pi.ii';
	sys.Pi.Gij = sys.Pi.Gij';
	sys.Pi.Bij = sys.Pi.Bij';
	sys.Pi.jci = [rr; r'];
	sys.Pi.jcj = [cc; c'];
 else
	sys.Pi.jci = [rr; r];
	sys.Pi.jcj = [cc; c];
 end
%--------------------------------------------------------------------------


%--------------Reactive Power Injection Legacy Measurements----------------
 sys.Qi.idx = logical(inj(:,7));
 sys.Qi.z   = inj(sys.Qi.idx,5);
 sys.Qi.v   = inj(sys.Qi.idx,6);
 sys.Qi.N   = size(sys.Qi.z,1);

 sys.Qi.bus = sys.bus(sys.Qi.idx,1);
 idx1 = ismember(i, sys.Qi.bus);
 sys.Qi.i = i(idx1);
 sys.Qi.j = j(idx1);

 Ybus = sys.Ybu(sys.Qi.bus,:);
 idx2 = find(Ybus);
 [sys.Qi.ii, ~] = find(Ybus);
 sys.Qi.Gij = real(Ybus(idx2));
 sys.Qi.Bij = imag(Ybus(idx2));

 lnidx = sub2ind(size(sys.Ybu), sys.Qi.bus, sys.Qi.bus);
 sys.Qi.Gii = real(sys.Ybu(lnidx));
 sys.Qi.Bii = imag(sys.Ybu(lnidx));

 sys.Qi.ij = sys.Qi.i ~= sys.Qi.j;

 [r, c]   = find(sys.Yij(sys.Qi.bus,:));
 [rr, cc] = find(sys.Yii(sys.Qi.bus,:));
 
 if sys.Qi.N == 1
	sys.Qi.ii = sys.Qi.ii';
	sys.Qi.Gij = sys.Qi.Gij';
	sys.Qi.Bij = sys.Qi.Bij';
	sys.Qi.jci = [rr; r'];
	sys.Qi.jcj = [cc; c'];
 else
	sys.Qi.jci = [rr; r];
	sys.Qi.jcj = [cc; c];
 end
%--------------------------------------------------------------------------