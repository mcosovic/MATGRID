 function [sys, pf, Vc, Q] = gs_cq(sys, pf, Vc, Q, Pgl)

%--------------------------------------------------------------------------
% Checks the bus reactive power constraints.
%
% If constraint Qmin or Qmax is violated, the type of buses is changed from
% PV bus to PQ bus, and then a generator has the new reactive power. The
% function saves a bus number when the constraint is violated.
%--------------------------------------------------------------------------
%  Inputs:
%	- sys: power system data
%	- pf: power flow data
%	- Vc: complex bus voltages
%	- Q: reactive power at bus
%	- Pgl: active power at bus
%
%  Outputs:
%	- sys.bus with changed columns:
%	  (2)bus type; (12)generator reactive power(Qg);
%	- sys.Qcon with changed column: (3)limit on/off;
%	- pf.bus with changed columns:
%	  (6)minimum limits violated at bus; (7)maximum limits violated at bus;
%	- Vc: complex bus voltages
%	- Q: reactive power at bus
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-25
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%--------------------Check Reactive Power Constraints----------------------
 mnq = find(Q < sys.Qcon(:,1) & sys.Qcon(:,3) == 1);
 mxq = find(Q > sys.Qcon(:,2) & sys.Qcon(:,3) == 1);
%--------------------------------------------------------------------------


%-------------------------------Check Qmin---------------------------------
 if ~isempty(mnq)
	sys.bus(mnq,2)  = 1;
	sys.Qcon(mnq,3) = 0;

	sys.bus(mnq,12) = sys.Qcon(mnq,1) + sys.bus(mnq,6);

	diago   = sub2ind(size(sys.Ybu), mnq, mnq);
	Vc(mnq) = (1 ./ sys.Ybu(diago)) .* ((Pgl(mnq) - 1i * ...
			  sys.Qcon(mnq,1)) ./ conj(Vc(mnq)) - sys.Yij(mnq,:) * Vc);
 end
%--------------------------------------------------------------------------


%-------------------------------Check Qmax---------------------------------
 if ~isempty(mxq)
	sys.bus(mxq,2)  = 1;
	sys.Qcon(mxq,3) = 0;

	sys.bus(mxq,12) = sys.Qcon(mxq,2) + sys.bus(mxq,6);

	diago   = sub2ind(size(sys.Ybu), mxq, mxq);
	Vc(mxq) = (1 ./ sys.Ybu(diago)) .* ((Pgl(mxq) - 1i * ...
			  sys.Qcon(mxq,2)) ./ conj(Vc(mxq)) - sys.Yij(mxq,:) * Vc);
 end
%--------------------------------------------------------------------------


%------------------------Indexes, Parameters, Data-------------------------
 if ~isempty(mnq) || ~isempty(mxq)
	Q = sys.bus(:,12) - sys.bus(:,6);

	pf.bus(mnq,6) = mnq;
	pf.bus(mxq,7) = mxq;
 end
%--------------------------------------------------------------------------