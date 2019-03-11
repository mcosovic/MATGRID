 function [] = diary_on(flag, case_in)



%------------------------------Turn on Diary-------------------------------
 if flag == 1
	diary(strcat(case_in, datestr(now,'_dd-mm-yy','local'),'_', datestr(now,'hh-MM-ss','local'), '.txt'))
 end
%--------------------------------------------------------------------------