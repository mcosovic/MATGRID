 function [out] = po2_power_flow_ac(sys, out)


 
%-------------------------------Input--------------------------------------
 tic
 Vc = out.Vc;                                                               % the solution of iterative algorithm 
%-------------------------------------------------------------------------- 
 
 
%-----------------------------Linear Indexing------------------------------
 iVi = sub2ind([sys.Nbu, 1], sys.LiTr(:,1));                                % commplex but voltage indexes on side from bus
 jVj = sub2ind([sys.Nbu, 1], sys.LiTr(:,2));                                % commplex bus voltage indexes on side to bus
%--------------------------------------------------------------------------        


%---------------------Apparent Power of the Bus----------------------------
 out.Si = (conj(sys.Ybu) * conj(Vc)) .* Vc;                                 % the apparent power injection into bus     
%-------------------------------------------------------------------------- 


%------------------Power at Branch/Transformer Susceptance-----------------                                                      
 out.Qs_i = -imag(sys.LiTr(:,4)) .* (abs(Vc(iVi)).^2);                      % the reactive power injection from branch shunt susceptances on side from bus
 out.Qs_j = -imag(sys.LiTr(:,5)) .* (abs(Vc(jVj)).^2);                      % the reactive power injection from branch shunt susceptances on side to bus
 
 out.Ps_i =  real(sys.LiTr(:,4)) .* (abs(Vc(iVi)).^2);                      % the active power loss of transformer shunt susceptance on side from bus 
 out.Ps_j =  real(sys.LiTr(:,5)) .* (abs(Vc(jVj)).^2);                      % the active power loss of transformer shunt susceptance on side to bus
%--------------------------------------------------------------------------

 
%-------------------------Current at Buses---------------------------------
 out.Iij = (Vc(iVi) - Vc(jVj)) .* sys.LiTr(:,3) + Vc(iVi) .* sys.LiTr(:,4); % the line current at branch from bus
 out.Iji = (Vc(jVj) - Vc(iVi)) .* sys.LiTr(:,3) + Vc(jVj) .* sys.LiTr(:,5); % the line current at branch into bus
  
 out.Ib_ij = sys.LiTr(:,3) .* (Vc(iVi) - Vc(jVj));                          % the line current after branch shunt susceptance on side from bus
 out.Ib_ji = sys.LiTr(:,3) .* (Vc(jVj) - Vc(iVi));                          % the line current after branch shunt susceptance on side to bus
%--------------------------------------------------------------------------


%--------------------Apparent Power at Buses-------------------------------
 out.Sij = Vc(iVi) .* conj(out.Iij);                                        % the apparent power at branch from bus   
 out.Sji = Vc(jVj) .* conj(out.Iji);                                        % the apparent power at branch into bus  
 
 out.Sb_ij = Vc(iVi) .* conj(out.Ib_ij);                                    % the apparent power after branch shunt susceptance on side from bus
 out.Sb_ji = Vc(jVj) .* conj(out.Ib_ji);                                    % the apparent power after branch shunt susceptance on side to bus
%--------------------------------------------------------------------------


%--------------------Aciteve and Reactive Losses---------------------------
 Z = 1 ./ sys.LiTr(:,3);                                                    % branch impedance                                                   
 Z(~isfinite(Z)) = 0; 

 out.Plos = (abs(out.Ib_ij)).^2 .* (real(Z));                               % active power losses at branch    
 out.Qlos = (abs(out.Ib_ij)).^2 .* (imag(Z));                               % reactive power losses at branch
%--------------------------------------------------------------------------


%-------------------------Shunt Elements-----------------------------------
 out.Qsh = -imag(sys.Ysh) * (abs(Vc.^2));                                   % reactive power injetion from shunt element            
 out.Psh =  real(sys.Ysh) * (abs(Vc.^2));                                   % active power losses at shunt element 
%--------------------------------------------------------------------------


%------------------------Postprocessing Time-------------------------------
 out.pos_time = toc;
%-------------------------------------------------------------------------- 


%-----------------------Note - pi Model------------------------------------
%
% | Sij    Sb_ij       Sb_ji    Sji |
% |-------|-----------------|-------|
% |       |                 |       |
%         |                 |
%         | Qs_i       Qs_j |  
%         |                 |
%         -                 - 
%--------------------------------------------------------------------------