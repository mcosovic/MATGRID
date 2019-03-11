 function [sys, alg, idx, pf, DelPQ, V, T, Qgl] = cq(sys, alg, idx, pf, DelPQ, V, T, Qgl, Vc, Pgl)

%--------------------------------------------------------------------------
% Checks the bus reactive power constraints.
%
% If constraint Qmin or Qmax is violated, the type of buses is changed from
% PV bus to PQ bus, and then a generator has the new reactive power, where
% we compute a new complex voltage for the bus where reactive power is
% violated. The function saves a bus number when the constraint is
% violated.
%
%  Input:
%	- Vc: complex bus voltages
%	- pf: power flow data
%	- sys: power system data
%	- Pgl: active power at bus
%	- alg: algorithm data
%	- idx: indexes data
%
%  Outputs:
%	- sys.bus with changed columns
%	  (2)bus type; (12)generator reactive power(Qg);
%	- pf.alg: algorithm data
%	- idx: indexes data
%	- pf.bus with changed columns:
%	  (1)minimum limits violated at bus; (2)maximum limits violated at bus;
%	- DelPQ: active and reactive power mismatch matrix for all buses
%	- V, T: bus voltage magnitude and angle vector
%	- Qgl: generator reactive power at bus
%
% The local function which is used in the AC power flow.
%--------------------------------------------------------------------------


%--------------------Check Reactive Power Constraints----------------------
 Q   = -imag(conj(Vc) .* (sys.Ybu * Vc));
 mnq = find(Q < sys.Qcon(:,1) & sys.Qcon(:,3) == 1);
 mxq = find(Q > sys.Qcon(:,2) & sys.Qcon(:,3) == 1);
%--------------------------------------------------------------------------


%-------------------------------Check Qmin---------------------------------
 if ~isempty(mnq)
	sys.bus(mnq,2) = 1;

	sys.bus(mnq,12) = sys.Qcon(mnq,1) + sys.bus(mnq,6);

	diago = sub2ind(size(sys.Ybu), mnq, mnq);
	Vnew  = (1 ./ sys.Ybu(diago)) .* ((Pgl(mnq) - 1i * ...
			sys.Qcon(mnq,1)) ./ conj(Vc(mnq)) - sys.Yij(mnq,:) * Vc);

	Vc(mnq) = Vnew;
 end
%--------------------------------------------------------------------------


%-------------------------------Check Qmax---------------------------------
 if ~isempty(mxq)
	sys.bus(mxq,2) = 1;

	sys.bus(mxq,12) = sys.Qcon(mxq,2) + sys.bus(mxq,6);

	diago = sub2ind(size(sys.Ybu), mxq, mxq);
	Vnew  = (1 ./ sys.Ybu(diago)) .* ((Pgl(mxq) - 1i * ...
			sys.Qcon(mxq,2)) ./ conj(Vc(mxq)) - sys.Yij(mxq,:) * Vc);

	Vc(mxq) = Vnew;
 end
%--------------------------------------------------------------------------


%------------------------Indexes, Parameters, Data-------------------------
 if ~isempty(mnq) || ~isempty(mxq)
	[alg, idx] = idx_par2(sys, alg, idx);

	V = abs(Vc);
	T = angle(Vc);

	Qgl   = sys.bus(:,12) - sys.bus(:,6);
	DelS  = Vc .* conj(sys.Ybu * Vc) - (Pgl + 1i * Qgl);
	DelPQ = [real(DelS(alg.ii)); imag(DelS(alg.pq))];

	pf.bus(mnq,1) = mnq;
	pf.bus(mxq,2) = mxq;
 end
%--------------------------------------------------------------------------