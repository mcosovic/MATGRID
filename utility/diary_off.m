 function diary_off(user)

%--------------------------------------------------------------------------
% Ends record display data in txt-file.
%
% If the flag is 1, the function ends to record the display data.
%--------------------------------------------------------------------------
%  Inputs:
%	- user: user input list data
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-04
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%------------------------------Turn off Diary------------------------------
 if ismember('save', user) 
	diary off
 end
%--------------------------------------------------------------------------