 function [sys, pf, Vc, Vcp] = gs_cv(sys, pf, Vc, Vcp, Pgl)

%--------------------------------------------------------------------------
% Checks the bus voltage magnitude constraints.
%
% If constraint Vmin or Vmax is violated, the type of buses is changed from
% PQ bus to PV bus, then we put |V| on Vmin or Vmax, where |V| is specified
% (now this is PV bus), and it needs voltage correction. Finally, we
% compute a reactive power injection  and complex bus voltage for for PV
% bus. The function saves a bus number when the constraint is violated.
%--------------------------------------------------------------------------
%  Inputs:
%	- sys: power system data
%	- pf: power flow data
%	- Vc, Vcp: complex bus voltages
%	- Pgl: active power at bus
%
%  Outputs:
%	- sys.bus with changed column: (2)bus type;
%	- sys.Vcon with changed column: (3)limit on/off;
%	- pf.bus with changed columns:
%	 (6)minimum limits violated at bus; (7)maximum limits violated at bus;
%	- Vc, Vcp: complex bus voltages
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-25
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-------------------Check Voltage Magnitude Constraints--------------------
 V = abs(Vc);
 T = angle(Vc);
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
	Vc  = V .* exp(1j * T);
	Vcp = Vc;
	pf.bus(mnv,6) = mnv;
	pf.bus(mxv,7) = mxv;
 end
%--------------------------------------------------------------------------