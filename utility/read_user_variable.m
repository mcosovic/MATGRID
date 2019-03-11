 function [user] = read_user_variable()

%--------------------------------------------------------------------------
% Forms the variable 'user' from inputs.
%
% The function reads user inputs given as the struct variables. Latter,
% different check functions are expecting struct variables: 'flow',
% 'estimation', 'legvariance', 'legset', 'pmuvariance', 'pmuset'.
%
%  Outputs power flow:
%	- user: all user inputs in one struct variable
%
% Main function which is used in all different modules.
%--------------------------------------------------------------------------


%---------------------------Read User Variables----------------------------
 var  = evalin('base','who');
 user = struct;

 for i = 1:numel(var)
	 aa = evalin('base', var{i});
	 if isstruct(aa)
		names = fieldnames(aa);
		for j = 1:numel(names)
			user.(strcat(names{j},'_',var{i})) = aa.(names{j});
		end
	 end
 end
%--------------------------------------------------------------------------