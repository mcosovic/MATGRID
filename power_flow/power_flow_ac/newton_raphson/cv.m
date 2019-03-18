 function [sys, alg, idx, pf, DelPQ, V, T] = cv(sys, alg, idx, pf, DelPQ, V, T, Pgl, Qgl)

%--------------------------------------------------------------------------
% Checks the bus voltage magnitude constraints.
%
% If constraint Vmin or Vmax is violated, the type of buses is changed from
% PQ bus to PV bus, and then a generator has the new voltage, where we
% compute a new reactive power for the bus where voltage magnitude is
% violated. The function saves a bus number when the constraint is
% violated.
%--------------------------------------------------------------------------
%  Inputs:
%	- sys: power system data
%	- alg: algorithm data
%	- idx: indexes data
%	- pf: power flow data
%	- DelPQ: mismatch
%	- V, T: bus voltage magnitude and angle vector
%	- Qgl: reactive power at bus
%	- Pgl: active power at bus
%
%  Outputs:
%	- sys.bus with changed column: (2)bus type;
%	- pf.alg: algorithm data
%	- idx: indexes data
%	- pf.bus with changed columns:
%	(1)minimum limits violated at bus; (2)maximum limits violated at bus;
%	- DelPQ: an active and reactive power mismatch matrix for all buses
%	- V, T: bus voltage magnitude and angle vector
%--------------------------------------------------------------------------
% The local function which is used in the AC power flow routine.
%--------------------------------------------------------------------------


%-------------------Check Voltage Magnitude Constraints--------------------
 mnv = find(V < sys.Vcon(:,1) & sys.Vcon(:,3) == 1);
 mxv = find(V > sys.Vcon(:,2) & sys.Vcon(:,3) == 1);
%--------------------------------------------------------------------------


%-------------------------------Check Vmin---------------------------------
 if ~isempty(mnv)
	sys.bus(mnv,2) = 3;

	V(mnv) = sys.Vcon(mnv, 1);
	Vp = V .* exp(1j * T);

	Q = -imag(conj(Vp(mnv)) .* (sys.Ybu(mnv,:) * Vp));

	diago = sub2ind(size(sys.Ybu), mnv, mnv);
	Vnew  = (1 ./ sys.Ybu(diago)) .* ((Pgl(mnv) - 1j * Q) ./...
			conj(Vp(mnv)) - sys.Yij(mnv,:) * Vp);

	Vp(mnv) = Vnew;
 end
%--------------------------------------------------------------------------


%-------------------------------Check Vmax---------------------------------
 if ~isempty(mxv)
	sys.bus(mxv,2) = 3;

	V(mxv) = sys.Vcon(mxv,2);
	Vp = V .* exp(1j * T);

	Q = -imag(conj(Vp(mxv)) .* (sys.Ybu(mxv,:) * Vp));

	diago = sub2ind(size(sys.Ybu), mxv, mxv);
	Vnew  = (1 ./ sys.Ybu(diago)) .* ((Pgl(mxv) - 1j * Q) ./...
			conj(Vp(mxv)) - sys.Yij(mxv,:) * Vp);

	Vp(mxv) = Vnew;
 end
%--------------------------------------------------------------------------


%------------------------Indexes, Parameters, Data-------------------------
 if ~isempty(mnv) || ~isempty(mxv)
	[alg, idx] = idx_par2(sys, alg, idx);

	V = abs(Vp);
	T = angle(Vp);

	DelS  = Vp .* conj(sys.Ybu * Vp) - (Pgl + 1i * Qgl);
	DelPQ = [real(DelS(alg.ii)); imag(DelS(alg.pq))];

	pf.bus(mnv,1) = mnv;
	pf.bus(mxv,2) = mxv;
 end
%--------------------------------------------------------------------------