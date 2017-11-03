 function [sys] = sy2_ybus(sys)
    


%----------------------------Preallocate-----------------------------------
 [sys.Yij, Yi, Yj] = deal(sparse(sys.Nbu, sys.Nbu));
%--------------------------------------------------------------------------


%--------------------------Linear Indexing---------------------------------
 ijY = sub2ind(size(sys.Yij), sys.Br(:,1), sys.Br(:,2));                    % linear indexing of "ij" elements
 jiY = sub2ind(size(sys.Yij), sys.Br(:,2), sys.Br(:,1));                    % linear indexing of "ji" elements
%--------------------------------------------------------------------------


%-----------------Nondiagonal Elements of Bus Matrix-----------------------
 sys.Yij(ijY) = -sys.Br(:,3);                                               % admittance of branches on "ij" position
 sys.Yij(jiY) = -sys.Br(:,3);                                               % admittance of branches on "ji" position
%--------------------------------------------------------------------------


%--------------------Diagonal Elements of Bus Matrix-----------------------
 Yi(ijY) = sys.Br(:,4);                                                     % branch shunt elements from bus 
 Yj(jiY) = sys.Br(:,5);                                                     % branch shunt elements to bus 
 sys.Yii = spdiags(sum(Yi + Yj - sys.Yij, 2), 0, sys.Nbu, sys.Nbu);         % diagonal elements
%--------------------------------------------------------------------------


%---------------Impedance and Admittance of Shunt Elements-----------------
 zsh         = complex(sys.bus(:,4), sys.bus(:,5));                         % shunt impedance  
 [sys.sh, ~] = find(zsh);                                                   % bus where shunt elements are located
 sys.Ysh     = sparse(sys.sh, sys.sh, 1 ./ zsh(sys.sh), sys.Nbu, sys.Nbu);  % shunt admittance                                                                  
 sys.Nsh     = length(sys.sh);                                              % number of shunt elements
%--------------------------------------------------------------------------


%---------------------------Full Y Bus Matrix------------------------------                                                  
 sys.Ybu = sys.Yij + sys.Yii + sys.Ysh;                                     % full Y bus matrix (including the slack bus)                                            
%--------------------------------------------------------------------------