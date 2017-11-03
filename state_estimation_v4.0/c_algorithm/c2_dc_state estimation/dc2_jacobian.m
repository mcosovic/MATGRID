 function [out] = dc2_jacobian(sys, ana, pmu)



%-----------------------Active Power Flow Jacobian-------------------------
 o = (1:ana.Npij)';
 c = [o; o];                               
 r = [ana.Pij(:,1); ana.Pij(:,2)];
 
 coef = ana.Pij(:,5);
 Jflo = sparse(c, r, [-coef; coef], ana.Npij, sys.Nbu);
%--------------------------------------------------------------------------
 
 
%--------------------Active Power Injection Jacobian-----------------------
 Jinj = -imag(sys.Ybu(ana.Pi(:,1),:));
%--------------------------------------------------------------------------


%--------------------------Voltage Angle Jacobian--------------------------
 Jang      = sparse(pmu.Nti, sys.Nbu);
 idx       = sub2ind([pmu.Nti sys.Nbu], (1:pmu.Nti)', pmu.Ti(:,1));
 Jang(idx) = 1;
%--------------------------------------------------------------------------


%----------------------------Jacobian Matrix-------------------------------
 out.Jfull = [Jflo; Jinj; Jang];
 out.J     = out.Jfull;
 
 out.J(:, sys.slack(1)) = [];
%--------------------------------------------------------------------------


%--------------------------Preprocessing Time------------------------------
 out.pre_time = toc; 
%--------------------------------------------------------------------------