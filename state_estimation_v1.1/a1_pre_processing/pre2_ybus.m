 function [in] = pre2_ybus(in)
    


%----------------------------Preallocate-----------------------------------
 [in.Y_ij, Y_ii_bt] = deal(zeros(in.Nbu, in.Nbu));
%--------------------------------------------------------------------------


%--------------------------Linear Indexing---------------------------------
 ijY = sub2ind(size(in.Y_ij), in.fromBus, in.toBus);                        % linear indexing of "ij" elements
 jiY = sub2ind(size(in.Y_ij), in.toBus, in.fromBus);                        % linear indexing of "ji" elements
%--------------------------------------------------------------------------


%-----------------Nondiagonal Elements of Bus Matrix-----------------------
 in.Y_ij(ijY) = - in.Br(:,3);                                               % admittance of branches on "ij" position
 in.Y_ij(jiY) = - in.Br(:,3);                                               % admittance of branches on "ji" position
%--------------------------------------------------------------------------


%--------------------Diagonal Elements of Bus Matrix-----------------------
 for i = 1:in.Nbu;                                                          % count buses
     for j = 1:in.Nbr;                                                      % count branches
         if in.Br(j,1) == i                                                 % if a branch incidents with from bus
            Y_ii_bt(i,i) = Y_ii_bt(i,i) + in.Br(j,3) + in.Br(j,4);          % branch admittance (Y_ii_bt(i,i) + in.Br(j,3)) "plus" shunt susceptance (in.Br(j,4)) 
         end
         if in.Br(j,2) == i                                                 % if a branch incidents with to bus
            Y_ii_bt(i,i) = Y_ii_bt(i,i) + in.Br(j,3) + in.Br(j,5);          % the branch admittance (Y_ii_bt(i,i) + in.Br(j,3)) "plus" shunt susceptance (in.Br(j,5))  
         end
     end
 end
%--------------------------------------------------------------------------


%---------------Impedance and Admittance of Shunt Elements-----------------
 z_se = complex(in.Bus(:,4), in.Bus(:,5));                                  % shunt impedance 
 in.Y_se = 1 ./ z_se;                                                       % shunt admittance 
 in.Y_se(~isfinite(in.Y_se)) = 0; 
 
 in.N_sh = length(nonzeros(in.Y_se));                                       % number of shunt elements
%--------------------------------------------------------------------------


%---------------------------Full Y Bus Matrix------------------------------                                                  
 in.Y_bus = in.Y_ij + Y_ii_bt + diag(in.Y_se);                              % full Y bus matrix (including the slack bus)                                            
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% Ybus has (N_bus x N_bus) dimension
%--------------------------------------------------------------------------