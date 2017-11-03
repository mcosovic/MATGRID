 function [idpa, alg] = gn2_idx_par(sys, ana, pmu)



%----------------------------Global Parameters-----------------------------
 [idpa.i, idpa.j] = find(sys.Yij); 
 
 alg.Nbu   = sys.Nbu;
 alg.Npij  = ana.Npij; 
 alg.Nqij  = ana.Nqij;
 alg.Npi   = ana.Npi;
 alg.Nqi   = ana.Nqi;
 alg.Nimij = ana.Nimij;
 alg.Nicij = pmu.Nicij;
 alg.Ntot  = ana.Nana + pmu.Npmu;
%--------------------------------------------------------------------------


%-----------------------------Active Power Flow----------------------------
 Pij = ana.Pij;
 
 [~, idpa.pij.ij] = ismember([Pij(:,1) Pij(:,2)], [idpa.i idpa.j], 'rows');

 idpa.pij.gij  = Pij(:,5);
 idpa.pij.bij  = Pij(:,6);
 idpa.pij.gsij = Pij(:,5) + Pij(:,7);
 
 num          = (1:ana.Npij)';
 idpa.pij.jci = [num; num];                               
 idpa.pij.jcj = [Pij(:,1); Pij(:,2)];
 idpa.pij.i   = Pij(:,1);
 idpa.pij.j   = Pij(:,2);
%--------------------------------------------------------------------------
 
 
%----------------------------Reactive Power Flow---------------------------
 Qij = ana.Qij;
 
 [~, idpa.qij.ij] = ismember([Qij(:,1) Qij(:,2)], [idpa.i idpa.j], 'rows');

 idpa.qij.gij  = Qij(:,5);
 idpa.qij.bij  = Qij(:,6);
 idpa.qij.bsij = Qij(:,6) + Qij(:,7); 
 
 num          = (1:ana.Nqij)';
 idpa.qij.jci = [num; num];                               
 idpa.qij.jcj = [Qij(:,1); Qij(:,2)];
 idpa.qij.i   = Qij(:,1);
 idpa.qij.j   = Qij(:,2);
%--------------------------------------------------------------------------


%--------------------------Line Currnet Magnitude--------------------------
 I = ana.Imij;
 
 [~, idpa.imij.ij] = ismember([I(:,1) I(:,2)], [idpa.i idpa.j], 'rows');

 idpa.imij.a = (I(:,5) + I(:,7)).^2 + (I(:,6) + I(:,8)).^2;  
 idpa.imij.b = I(:,5).^2 + I(:,6).^2; 
 idpa.imij.c = I(:,5) .* (I(:,5) + I(:,7)) + I(:,6) .* (I(:,6) + I(:,8));
 idpa.imij.d = I(:,5) .* I(:,8) - I(:,6) .* I(:,7);
 
 num           = (1:ana.Nimij)';
 idpa.imij.jci = [num; num];                               
 idpa.imij.jcj = [I(:,1); I(:,2)];
 idpa.imij.i   = I(:,1);
 idpa.imij.j   = I(:,2);
%--------------------------------------------------------------------------


%--------------------------Active Power Injection--------------------------
 Pi = ana.Pi;
 
 Ypi            = sparse(sys.Nbu, sys.Nbu);
 Ypi(Pi(:,1),:) = sys.Yij(Pi(:,1),:);
 [i, idpa.pi.j] = find(Ypi);  
 idpa.pi.ij     = ismember(idpa.i, Pi(:,1));

 idpa.pi.Gij = real(sys.Ybu(sub2ind([sys.Nbu sys.Nbu], i, idpa.pi.j))); 
 idpa.pi.Bij = imag(sys.Ybu(sub2ind([sys.Nbu sys.Nbu], i, idpa.pi.j))); 
 idpa.pi.Gii = real(sys.Ybu(sub2ind([sys.Nbu sys.Nbu], Pi(:,1), Pi(:,1)))); 

 idpa.pi.ii     = Pi(:,1);
 [idpa.pi.r, c] = find(sys.Yij(Pi(:,1),:));

 [rr, cc]    = find(sys.Yii(Pi(:,1),:));
 idpa.pi.jci = [rr; idpa.pi.r];
 idpa.pi.jcj = [cc; c];
 idpa.pi.i   = idpa.i(idpa.pi.ij);
%--------------------------------------------------------------------------


%-----------------------Reactive Power Injection---------------------------
 Qi = ana.Qi;

 Yqi            = sparse(sys.Nbu, sys.Nbu);
 Yqi(Qi(:,1),:) = sys.Yij(Qi(:,1),:);
 [i, idpa.qi.j] = find(Yqi);  
 idpa.qi.ij     = ismember(idpa.i, Qi(:,1));

 idpa.qi.Gij = real(sys.Ybu(sub2ind([sys.Nbu sys.Nbu], i, idpa.qi.j))); 
 idpa.qi.Bij = imag(sys.Ybu(sub2ind([sys.Nbu sys.Nbu], i, idpa.qi.j))); 
 idpa.qi.Bii = imag(sys.Ybu(sub2ind([sys.Nbu sys.Nbu], Qi(:,1), Qi(:,1)))); 

 idpa.qi.ii     = Qi(:,1);
 [idpa.qi.r, c] = find(sys.Yij(Qi(:,1),:));
 
 [rr, cc]    = find(sys.Yii(Qi(:,1),:));
 idpa.qi.jci = [rr; idpa.qi.r];
 idpa.qi.jcj = [cc; c];
 idpa.qi.i   = idpa.i(idpa.qi.ij);
%--------------------------------------------------------------------------


%-----------------------Voltage Magnitude and Angle------------------------
 idpa.vma.i = ana.Vi(:,1); 
 idpa.vmp.i = pmu.Vi(:,1);
 idpa.ti.i  = pmu.Ti(:,1);
%--------------------------------------------------------------------------


%--------------------------Line Currnet Phasor-----------------------------
 Ic = pmu.Icij;

 idpa.icij.i = Ic(:,1);
 idpa.icij.j = Ic(:,2);
 idpa.icij.a = Ic(:,6) + Ic(:,8);  
 idpa.icij.b = Ic(:,7) + Ic(:,9);
 idpa.icij.c = Ic(:,6);  
 idpa.icij.d = Ic(:,7);
 
 num           = (1:pmu.Nicij)';
 idpa.icij.jci = [num; num];                               
 idpa.icij.jcj = [Ic(:,1); Ic(:,2)];
%--------------------------------------------------------------------------