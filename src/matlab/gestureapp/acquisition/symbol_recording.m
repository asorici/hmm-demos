function varargout = symbol_recording(varargin)
% SYMBOL_RECORDING MATLAB code for symbol_recording.fig
%      SYMBOL_RECORDING, by itself, creates a new SYMBOL_RECORDING or raises the existing
%      singleton*.
%
%      H = SYMBOL_RECORDING returns the handle to a new SYMBOL_RECORDING or the handle to
%      the existing singleton*.
%
%      SYMBOL_RECORDING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SYMBOL_RECORDING.M with the given input arguments.
%
%      SYMBOL_RECORDING('Property','Value',...) creates a new SYMBOL_RECORDING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before symbol_recording_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to symbol_recording_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help symbol_recording

% Last Modified by GUIDE v2.5 03-Sep-2012 17:01:18

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
% End initialization code - DO NOT EDIT

% global variables
global nr_points
nr_points = 64;


% --- Executes just before symbol_recording is made visible.
function symbol_recording_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to symbol_recording (see VARARGIN)

% Choose default command line output for symbol_recording
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes symbol_recording wait for user response (see UIRESUME)
% uiwait(handles.symbol_recording);


% --- Outputs from this function are returned to the command line.
function varargout = symbol_recording_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on mouse press over axes background.
function symbol_pad_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to symbol_pad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button = get(gcbf, 'SelectionType');

if strcmpi(button, 'normal')
    set(gcbf, 'WindowButtonMotionFcn', @motionfcn);
elseif strcmpi(button, 'alt')
    cla;
end

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function symbol_recording_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to symbol_recording (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcbf, 'WindowButtonMotionFcn', '');


function motionfcn(hObject, eventdata)
%axes_list = findall(hObject,'type','axes');
%padH = axes_list(1,1);
h = guidata(hObject);
padH = h.symbol_pad;
mousePositionData = get(padH, 'CurrentPoint');

t = clock;
t_mark = t(4) * 3600 + t(5) * 60 + t(6);

current_track = get(padH, 'UserData');
set(padH, 'UserData', [current_track; mousePositionData(1,1) mousePositionData(1,2) t_mark]);

hold on;
plot(mousePositionData(1,1), mousePositionData(1,2), 'r*');
hold off;


% --- Executes on selection change in symbol_select.
function symbol_select_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns symbol_select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from symbol_select


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


% --- Executes on button press in symbol_save.
function symbol_save_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
padH = handles.symbol_pad;
track_data = get(padH, 'UserData');
set(padH, 'UserData', []);

cla;
len_track = size(track_data, 1);

global nr_points
if len_track > nr_points
    % clear symbol pad from old plots
    %axes(padH);
    track_data = bbox_resize(track_data);
    
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
    
    symbol_sel_names = get(handles.symbol_select, 'String');
    symbol_sel_index = get(handles.symbol_select, 'Value');
    if iscell(symbol_sel_names)
        symbol_choice = symbol_sel_names{symbol_sel_index};
    else
        symbol_choice = symbol_sel_names(symbol_sel_index, :);
    end
    
    % store raw data to selected symbol file
    filename = strcat(symbol_choice, '.mat');

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


function [bbox_track_data] = bbox_resize(track_data)
bbox_track_data = zeros(size(track_data));
len_seq = size(track_data, 1);
    
% determine bounding box of symbol sequence
x_min = min(track_data(:, 1));
x_max = max(track_data(:, 1));

y_min = min(track_data(:, 2));
y_max = max(track_data(:, 2));

% and resize sequence to bounding box
bbox_track_data(:, 1) = ...
    (track_data(:, 1) - ones(len_seq, 1) * x_min) ./ (x_max - x_min);

bbox_track_data(:, 2) = ...
    (track_data(:, 2) - ones(len_seq, 1) * y_min) ./ (y_max - y_min);

bbox_track_data(:, 3) = track_data(:, 3);