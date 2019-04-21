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
%	- sys.Vcon with changed column: (3)limit on/off;
%	- pf.alg: algorithm data
%	- idx: indexes data
%	- pf.bus with changed columns:
%	  (1)bus indicator where minimum limits violated;
%	  (2)bus indicator where maximum limits violated;
%	- DelPQ: an active and reactive power mismatch matrix for all buses
%	- V, T: bus voltage magnitude and angle vector
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-02-21
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-------------------Check Voltage Magnitude Constraints--------------------
 mnv = find(V < sys.Vcon(:,1) & sys.Vcon(:,3) == 1);
 mxv = find(V > sys.Vcon(:,2) & sys.Vcon(:,3) == 1);
%--------------------------------------------------------------------------


%-------------------------------Check Vmin---------------------------------
 if ~isempty(mnv)
	sys.bus(mnv,2)  = 2;
	sys.Vcon(mnv,3) = 0;

	V(mnv) = sys.Vcon(mnv,1);
	Vp = V .* exp(1j * T);

	Q = -imag(conj(Vp(mnv)) .* (sys.Ybu(mnv,:) * Vp));

	diago = sub2ind(size(sys.Ybu), mnv, mnv);
	T(mnv) = angle((1 ./ sys.Ybu(diago)) .* ((Pgl(mnv) - 1j * Q) ./...
			 conj(Vp(mnv)) - sys.Yij(mnv,:) * Vp));
 end
%--------------------------------------------------------------------------


%-------------------------------Check Vmax---------------------------------
 if ~isempty(mxv)
	sys.bus(mxv,2)  = 2;
	sys.Vcon(mxv,3) = 0;

	V(mxv) = sys.Vcon(mxv,2);
	Vp = V .* exp(1j * T);

	Q = -imag(conj(Vp(mxv)) .* (sys.Ybu(mxv,:) * Vp));

	diago  = sub2ind(size(sys.Ybu), mxv, mxv);
	T(mxv) = angle((1 ./ sys.Ybu(diago)) .* ((Pgl(mxv) - 1j * Q) ./...
			 conj(Vp(mxv)) - sys.Yij(mxv,:) * Vp));
 end
%--------------------------------------------------------------------------


%------------------------Indexes, Parameters, Data-------------------------
 if ~isempty(mnv) || ~isempty(mxv)
	[alg, idx] = idx_par2(sys, alg, idx);

	Vp    = V.* exp(1j * T);
	DelS  = Vp .* conj(sys.Ybu * Vp) - (Pgl + 1i * Qgl);
	DelPQ = [real(DelS(alg.ii)); imag(DelS(alg.pq))];

	pf.limit(mnv,1) = 1;
	pf.limit(mxv,2) = 1;
 end
%--------------------------------------------------------------------------