function varargout = symbol_recording(varargin)
% SYMBOL_RECOGNITION MATLAB code for symbol_recognition.fig
%      SYMBOL_RECOGNITION, by itself, creates a new SYMBOL_RECOGNITION or raises the existing
%      singleton*.
%
%      H = SYMBOL_RECOGNITION returns the handle to a new SYMBOL_RECOGNITION or the handle to
%      the existing singleton*.
%
%      SYMBOL_RECOGNITION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SYMBOL_RECOGNITION.M with the given input arguments.
%
%      SYMBOL_RECOGNITION('Property','Value',...) creates a new SYMBOL_RECOGNITION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before symbol_recognition_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to symbol_recognition_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help symbol_recognition

% Last Modified by GUIDE v2.5 11-May-2012 20:04:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1; 
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @symbol_recording_OpeningFcn, ...
                   'gui_OutputFcn',  @symbol_recording_OutputFcn, ...
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

global nr_points
nr_points = 64;
% End initialization code - DO NOT EDIT


% --- Executes just before symbol_recognition is made visible.
function symbol_recording_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to symbol_recognition (see VARARGIN)

% Choose default command line output for symbol_recognition
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using symbol_recognition.
%{
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));
end
%}

% UIWAIT makes symbol_recognition wait for user response (see UIRESUME)
% uiwait(handles.main_figure);


% --- Outputs from this function are returned to the command line.
function varargout = symbol_recording_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.main_figure)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.main_figure,'Name') '?'],...
                     ['Close ' get(handles.main_figure,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.main_figure)

% --- Executes on button press in symbol_save.
function symbol_save_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get stored track data and then clear the userdata value
padH = gca;
track_data = get(padH, 'userdata');
set(padH, 'userdata', []);

cla;

global nr_points
if size(track_data, 1) > nr_points
    % clear symbol pad from old plots
    %axes(padH);
    
    
    step = double(size(track_data, 1)) / double(nr_points);
    sampled_track_data = [];
    index = 1;
    
    for i = 1:nr_points
        idx = floor(index);
        if idx >= size(track_data, 1)
            idx = size(track_data, 1);
        end
        sampled_track_data = [sampled_track_data; track_data(idx, :)];
        index = index + step;
    end
    
    disp(size(sampled_track_data));
    
    %h = guidata(hObject);
    %popup_sel_index = get(h.symbol_select, 'Value');
    %popup_sel_index = get(hObject, 'userdata');
    global popup_sel_index

    % store raw data to selected symbol file
    filename = '';
    switch popup_sel_index
        case 1
            filename = 'left_arrow.mat';
        case 2
            filename = 'right_arrow.mat';
        case 3
            filename = 'circle.mat';
        case 4
            filename = 'square.mat';
    end

    if ~strcmp(filename, '')
        if exist(filename, 'file') ~= 0
            load(filename, '-mat', 'raw_track_values');
            raw_track_values{end + 1} = sampled_track_data;
            save(filename, 'raw_track_values');
        else
            raw_track_values = {sampled_track_data};
            save(filename, 'raw_track_values');
        end
    end
    
else
    disp('NOT ENOUGH POINTS SAMPLED. MOVE SLOWER!');
end

% --- Executes on selection change in symbol_select.
function symbol_select_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns symbol_select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from symbol_select

contents = get(hObject,'String');
%symbol = contents{get(hObject,'Value')};
global popup_sel_index
popup_sel_index = get(hObject,'Value');
%set(handles.symbol_save, 'userdata', popup_sel_index);



% --- Executes during object creation, after setting all properties.
function symbol_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to symbol_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'left_arrow', 'right_arrow', 'circle', 'square'});



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over axes background to start tracking.
function symbol_pad_start_track(hObject, eventdata, handles)
% hObject    handle to symbol_pad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%set(hObject, 'ButtonDownFcn', @symbol_pad_stop_track);
button = get(gcbf, 'SelectionType');

if strcmpi(button, 'normal')
    set(gcbf, 'WindowButtonMotionFcn', @motionfcn);
elseif strcmpi(button, 'alt')
    cla;
end


% --- Executes on mouse press over axes background to stop tracking.
function main_figure_stop_track(hObject, eventdata, handles)
% hObject    handle to symbol_pad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%disp('HERE!!!!!!!!!!!!!!');
%set(hObject, 'ButtonDownFcn', {@symbol_pad_start_track, guidata(gcbf)});
%if get(gcbf, 'WindowButtonMotionFcn') ~= ''
%    set(gcbf, 'WindowButtonMotionFcn', '');
%end
set(gcbf, 'WindowButtonMotionFcn', '');



function motionfcn(hObject, eventdata)
%axes_list = findall(hObject,'type','axes');
%padH = axes_list(1,1);
padH = gca;

t = clock;
mousePositionData = get(padH,'CurrentPoint');
current_track = get(padH, 'userdata');
t_mark = t(4) * 3600 + t(5) * 60 + t(6);
set(padH, 'userdata',[current_track; mousePositionData(1,1) mousePositionData(1,2) t_mark]);
%axes(padH);

%hold(hObject, 'on');
hold on;
plot(mousePositionData(1,1), mousePositionData(1,2), 'r*');
%hold(hObject, 'off');
hold off;
