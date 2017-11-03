 function [sys] = sy1_pi_model(sys)



%--------------------PI model of Transmission Line-------------------------
 zli = complex(sys.line(:,3), sys.line(:,4));                               % transmission line impedance 
 yli = 1 ./ zli;                                                            % transmission line admittance
 bli = 1i * sys.line(:,5);                                                  % half transmission line charging susceptance
%--------------------------------------------------------------------------


%------------------------PI model of Transformer---------------------------
 if isfield(sys, 'transformer')                                             % if the transformer data exists
    ztr = complex(sys.transformer(:,3), sys.transformer(:,4));              % transformer series impedance 
    ytr = (1 ./ ztr) ./ sys.transformer(:,5);                               % transformer series admittance (admittance over tap position)
    ytr(~isfinite(ytr)) = 0;    

    btr_t = (1 ./ sys.transformer(:,5)) .* ...                              % transformer shunt susceptance on the tap side
            (1 ./ sys.transformer(:,5) - 1) .* (1 ./ ztr);                 
    btr_t(isnan(btr_t)) = 0; 

    btr = (1 - 1 ./ sys.transformer(:,5)) .* (1 ./ ztr);                    % transformer shunt susceptance on the opposite tap side
    btr(isnan(btr)) = 0;    
    
    Tr = [sys.transformer(:,1:2) ytr btr_t btr];                            % transformer data matrix 
 else
    Tr = [];                                                                % if the transformer data not exist
 end
%--------------------------------------------------------------------------


%-------------------------Line-Transformer Data----------------------------
 LiTr     = [sys.line(:,1:2) yli bli bli];
 sys.LiTr = [LiTr; Tr];                                                     % full branch data matrix 
%--------------------------------------------------------------------------


%--------------------More Branches Between Two Buses-----------------------
 if isfield(sys, 'transformer') 
    Tr1        = Tr;                                                           
    mem        = ~ismember(sort(Tr(:,1:2), 2), Tr(:,1:2), 'rows');    
    Tr1(mem,4) = Tr(mem,5);
    Tr1(mem,5) = Tr(mem,4);
    
    LiTr = [LiTr; Tr1];
 end
  
 ft = LiTr(:,1:2);                                                          % branch matrix from bus, to bus
 ft = sort(ft, 2);                                                          % sort the matrix
  
 [a,~,i] = unique(ft, 'rows');                                              % find unique conection between two buses
 
 sys.Br = [a, accumarray(i, LiTr(:,3)), ...                                 % branch data matrix (transmission line and transformer)
           accumarray(i, LiTr(:,4)), accumarray(i, LiTr(:,5))];   
%--------------------------------------------------------------------------


%-------------------------Parameters of System-----------------------------
 sys.Nbu = size(sys.bus, 1);                                                % number of buses
 sys.Nli = size(sys.line, 1);                                               % number of transmission lines
 sys.Ntr = size(Tr, 1);                                                     % number of transformers
 sys.Nbr = size(a,1);                                                       % number of branches (transmission lines and transformers)
%--------------------------------------------------------------------------