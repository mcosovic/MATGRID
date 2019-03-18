 function [] = diary_on(flag, case_in)

%--------------------------------------------------------------------------
% Saves display data in txt-file.
%
% If the flag is 1, the function starts to record the display data.
%--------------------------------------------------------------------------
%  Inputs:
%	- flag: save display indicator
%	- case_in: name of the load power system
%--------------------------------------------------------------------------
% Export function which is used in all modules.
%--------------------------------------------------------------------------


%------------------------------Turn on Diary-------------------------------
 if flag == 1
	diary(strcat(case_in, datestr(now,'_dd-mm-yy','local'),'_', datestr(now,'hh-MM-ss','local'), '.txt'))
 end
%--------------------------------------------------------------------------