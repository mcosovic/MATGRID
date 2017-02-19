 function [in] = pre1_pi_model(in)



%--------------------PI model of Transmission Line-------------------------
 z_li = complex(in.Line(:,3), in.Line(:,4));                                % transmission line impedance 
 y_li = 1 ./ z_li;                                                          % transmission line admittance
 b_li = 1i * in.Line(:,5);                                                  % half transmission line charging susceptance
%--------------------------------------------------------------------------


%------------------------PI model of Transformer---------------------------
 if isfield(in, 'Transformer')                                              % if the transformer data exists
    z_tr = complex(in.Transformer(:,3), in.Transformer(:,4));               % transformer series impedance 
    y_tr = (1./z_tr) ./ in.Transformer(:,5);                                % transformer series admittance (admittance over tap position)
    y_tr(~isfinite(y_tr)) = 0;    

    b_tr_t = (1 ./ in.Transformer(:,5)) .* ...                              % transformer shunt susceptance on the tap side
             (1 ./ in.Transformer(:,5) - 1) .* (1 ./ z_tr);                 
    b_tr_t(isnan(b_tr_t)) = 0; 

    b_tr = (1 - 1 ./ in.Transformer(:,5)) .* (1 ./ z_tr);                   % transformer shunt susceptance on the opposite tap side
    b_tr(isnan(b_tr)) = 0;    
    
    Tr = [in.Transformer(:,1:2) y_tr b_tr_t b_tr];                          % transformer data matrix    
 else
    Tr = [];                                                                % if the transformer data not exist
 end
%--------------------------------------------------------------------------


%--------------------More Branches Between Two Buses-----------------------
 in.Br_f = [[in.Line(:,1:2) y_li b_li b_li]; Tr];                           % full branch data matrix 
 ft      = in.Br_f(:,1:2);                                                  % branch matrix from bus, to bus
 ft      = sort(ft, 2);                                                     % sort the matrix
 B       = in.Br_f(:, 3:end);                                               % admittance and susceptance matrix                                                   
  
 [same,~,idx] = unique(ft, 'rows');                                         % find unique conection between two buses
 num_s        = size(same, 1);                                              % number of unique conections
 Br_un        = zeros(num_s, size(B,2));                                    % preallocation

 for i = 1:num_s                
     Br_un(i,:) = sum(B(idx == i, :), 1);                                   % admittance and susceptance sum between two buses
 end
%--------------------------------------------------------------------------


%-------------------------Parameters of System-----------------------------
 in.fromBus = same(:,1);                                                    % branch goes from buses                                                            
 in.toBus   = same(:,2);                                                    % branch goes to buses
 in.Br      = [same Br_un];                                                 % branch data matrix (transmission line and transformer)

 in.Nbu = size(in.Bus, 1);                                                  % number of buses
 in.Nli = size(in.Line, 1);                                                 % number of transmission lines
 in.Ntr = size(Tr, 1);                                                      % number of transformers
 in.Nbr = num_s;                                                            % number of branches (transmission lines and transformers)
%--------------------------------------------------------------------------