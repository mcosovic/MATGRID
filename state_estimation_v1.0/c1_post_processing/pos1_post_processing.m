 function [out] = pos1_post_processing(in, out)


 
%-------------------------------Input--------------------------------------
 V = out.V;                                                                         % the solution of iterative algorithm 
%--------------------------------------------------------------------------  


%--------------------Preallocate and Linear Indexing-----------------------
 out.Si = zeros(in.Nbu, 1);                                                 % the apparent power injection into bus 
 iVi    = sub2ind(size(V), in.Br_f(:,1));                                   % commplex but voltage indexes on side from bus
 jVj    = sub2ind(size(V), in.Br_f(:,2));                                   % commplex bus voltage indexes on side to bus
%--------------------------------------------------------------------------        


%---------------------Apparent Power of the Bus----------------------------
 for i = 1:in.Nbu                                                           % count buses
     for j = 1:in.Nbu                                                       % count buses
         out.Si(i) = out.Si(i) + conj(V(i)) * V(j) * in.Y_bus(i,j);         % out.Si(i) on the right-hand side - if a bus connects with more branches   
     end
 end
%-------------------------------------------------------------------------- 

 
%------------------Power at Branch/Transformer Susceptance-----------------                                                      
 out.Qinj_f = -imag(in.Br_f(:,4)) .* (abs(V(iVi)).^2);                      % the reactive power injection from branch shunt susceptances on side from bus
 out.Qinj_t = -imag(in.Br_f(:,5)) .* (abs(V(jVj)).^2);                      % the reactive power injection from branch shunt susceptances on side to bus
 
 out.Pinj_f =  real(in.Br_f(:,4)) .* (abs(V(iVi)).^2);                      % the active power losse of transformer shunt susceptance on side from bus 
 out.Pinj_t =  real(in.Br_f(:,5)) .* (abs(V(jVj)).^2);                      % the active power losse of transformer shunt susceptance on side to bus
%--------------------------------------------------------------------------

 
%-------------------------Current at Buses---------------------------------
 out.Imk_f = (V(iVi) - V(jVj)) .* in.Br_f(:,3) + V(iVi) .* in.Br_f(:,4);    % the line current at branch from bus
 out.Imk_t = (V(jVj) - V(iVi)) .* in.Br_f(:,3) + V(jVj) .* in.Br_f(:,5);    % the line current at branch into bus
  
 out.Imkb_f = in.Br_f(:,3) .* (V(iVi) - V(jVj));                            % the line current after branch shunt susceptance on side from bus
 out.Imkb_t = in.Br_f(:,3) .* (V(jVj) - V(iVi));                            % the line current after branch shunt susceptance on side to bus
%--------------------------------------------------------------------------


%--------------------Apparent Power at Buses-------------------------------
 out.Smk_f = V(iVi) .* conj(out.Imk_f);                                     % the apparent power at branch from bus   
 out.Smk_t = V(jVj) .* conj(out.Imk_t);                                     % the apparent power at branch into bus  
 
 out.Smkb_f = V(iVi) .* conj(out.Imkb_f);                                   % the apparent power after branch shunt susceptance on side from bus
 out.Smkb_t = V(jVj) .* conj(out.Imkb_t);                                   % the apparent power after branch shunt susceptance on side to bus
%--------------------------------------------------------------------------


%---------------------------Branch Impedance-------------------------------
 Z = 1 ./ in.Br_f(:,3);                                                     % branch impedance                                                   
 Z(~isfinite(Z)) = 0; 
%--------------------------------------------------------------------------


%--------------------Aciteve and Reactive Losses---------------------------
 out.Plos = (abs(out.Imkb_f)).^2 .* (real(Z));                              % active power losses at branch    
 out.Qlos = (abs(out.Imkb_f)).^2 .* (imag(Z));                              % reactive power losses at branch
%--------------------------------------------------------------------------


%-------------------------Shunt Elements-----------------------------------
 out.Qsh = -imag(in.Y_se) .* (abs(V.^2));                                   % reactive power injetion from shunt element            
 out.Psh =  real(in.Y_se) .* (abs(V.^2));                                   % active power losses at shunt element 
%--------------------------------------------------------------------------


%-----------------------Note - pi Model------------------------------------
%
% | Smk_f   Smkb_f   Smkb_t   Smk_t |
% |-------|-----------------|-------|
% |       |                 |       |
%         |                 |
%         | Qinj       Qinj |  
%         |                 |
%         -                 - 
%--------------------------------------------------------------------------