 function varargout = start(varargin)

 
 
%--------------------------------------------------------------------------
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @start_OpeningFcn, ...
                       'gui_OutputFcn',  @start_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
       gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
       [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
       gui_mainfcn(gui_State, varargin{:});
    end
%--------------------------------------------------------------------------


%-------------Executes just before FIGURE is made visible------------------
 function start_OpeningFcn(hObject, ~, handles, varargin)
    clc
    movegui(gcf,'center')  
    folder = fileparts(which(mfilename)); 
    addpath(genpath(folder));
    tmp = matlab.desktop.editor.getActive;
    cd(fileparts(tmp.Filename));  
    currentFolder = pwd;
    
    set(handles.power,'Value',1)
    set(handles.user,'Value',0)
    
    cd input_data/a1_ac/power_flow;    
    s = what;                                                    
    matfiles = s.mat;
    cd(currentFolder)                      
    handles.matfiles = matfiles;
    set(handles.listbox1, 'string', matfiles)
    
    handles.output = hObject;
    guidata(hObject, handles);
      
 function varargout = start_OutputFcn(~, ~, handles) 
    varargout{1} = handles.output;
%--------------------------------------------------------------------------


%-----------------------------Button Run-----------------------------------
 function pushbutton1_Callback(hObject, ~, handles)                         %#ok<DEFNU>
    clc 
    choose{3} = get(handles.power,'Value');
    choose{4} = get(handles.user,'Value');
    choose{5} = get(handles.listbox1,'Value');
    choose{6} = handles.matfiles;
        
    col = get(hObject,'backg');  
    set(hObject,'str','Running','backg',uint8([153 204 255]))
    pause(.01)  
    
    set(hObject,'Enable','off') 
    leeloo(choose);
    
    set(hObject,'Enable','on')
    set(hObject,'str','Run','backg',col)  
%--------------------------------------------------------------------------

 

%---------------------------Radio Button power-----------------------------
 function power_Callback(hObject, ~, handles)                               %#ok<DEFNU>
    power = get(hObject,'Value');
    set(handles.power,'Value',1);
    currentFolder = pwd;
    switch power
        case 1 
             set(handles.user,'Value',0)
             
             set(handles.listbox1,'Value',1);
             cd input_data/a1_ac/power_flow;
             s = what;                                                    
             matfiles = s.mat;
             cd(currentFolder)                      
             handles.matfiles = matfiles;
             set(handles.listbox1, 'string', matfiles)
             guidata(hObject, handles);
         case 0
             set(handles.user,'Value',0)
    end      
%--------------------------------------------------------------------------


%----------------------------Radio Button user-----------------------------
 function user_Callback(hObject, ~, handles)                               %#ok<DEFNU>
    user = get(hObject,'Value');
    set(handles.user,'Value',1);
    currentFolder = pwd;
    
    switch user
        case 1 
             set(handles.power,'Value',0)
 
             set(handles.listbox1,'Value',1);
                cd input_data/a1_ac/user_data;
             s = what;                                                    
             matfiles = s.m;
             cd(currentFolder)                      
             handles.matfiles = matfiles;
             set(handles.listbox1, 'string', matfiles)
             guidata(hObject, handles);
        case 0
             set(handles.power,'Value',0)
    end      
%--------------------------------------------------------------------------
