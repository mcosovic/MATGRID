 function diary_on(user, case_in)

%--------------------------------------------------------------------------
% Saves display data in txt-file.
%
% If the flag is 1, the function starts to record the display data.
%--------------------------------------------------------------------------
%  Inputs:
%	- user: user input list data
%	- case_in: name of the load power system
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-04
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%------------------------------Turn on Diary-------------------------------
 if ismember('save', user)
    cd('experiments') 
	diary(strcat(case_in, datestr(now,'_dd-mm-yy','local'),'_', datestr(now,'hh-MM-ss','local'), '.txt'))
    cd('../') 
 end
%--------------------------------------------------------------------------