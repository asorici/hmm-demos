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

% Last Modified by GUIDE v2.5 08-Nov-2012 12:41:53

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


% --- Executes during object creation, after setting all properties.
function symbol_recording_CreateFcn(hObject, eventdata, handles)
% hObject    handle to symbol_recording (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% -------- global variables --------
global nr_points
nr_points = 64;

% GUI mode - will be a switch between {'browse', 'create'}
global BROWSE CREATE
BROWSE = 0;
CREATE = 1;

global gui_mode
gui_mode = CREATE;

global current_track_idx current_raw_track_values
current_track_idx = 1;
current_raw_track_values = {};

% feature extraction parameters
global resample_interval
global hamming_window_size
global hamming_window_step
global nr_clusters
resample_interval = 0.02;
hamming_window_size = 0.16;
hamming_window_step = 0.08;
nr_clusters = 256;

% configuration saving filename
symbol_app_name = 'symbolapp';
symbol_app_folder = 'acquisition';

global symbol_config_filename
symbol_config_filename = ...
    strcat(symbol_app_name, filesep, ...
            symbol_app_folder, filesep, ...
            'symbol_config.mat');


% --- Executes on mouse press over axes background.
function symbol_pad_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to symbol_pad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button = get(gcbf, 'SelectionType');

if strcmpi(button, 'normal')
    set(gcbf, 'WindowButtonMotionFcn', @motionfcn);
elseif strcmpi(button, 'alt')
    set(handles.symbol_pad, 'UserData', []);
    set(handles.symbol_messages, 'String', '');
    
    cla(handles.symbol_pad);
    cla(handles.symbol_x_func);
    cla(handles.symbol_y_func);
end

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function symbol_recording_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to symbol_recording (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcbf, 'WindowButtonMotionFcn', '');
padH = handles.symbol_pad;

track_data = get(padH, 'UserData');
len_track = size(track_data, 1);

global nr_points
global resample_interval

if len_track > nr_points
    cla;
    
    hold on;
    plot(handles.symbol_pad, ...
        track_data(:, 1),...
        track_data(:, 2), 'g*');
    hold off;
    
    to_resize_track_data = track_data;
    resized_track_data = bbox_resize(to_resize_track_data);
    
    sampled_track_data = ...
        resample_track_data(resized_track_data, resample_interval, 0);
    
    % now draw the x_plot and y_plot in their respective axes
    plot(handles.symbol_x_func, ...
        sampled_track_data(:,3)', ...
        sampled_track_data(:,1)', 'b');
    
    plot(handles.symbol_y_func, ...
        sampled_track_data(:,3)', ...
        sampled_track_data(:,2)', 'b');
else
    if (~isempty(track_data))
        set(handles.symbol_messages, 'String', ...
        'NOT ENOUGH POINTS SAMPLED. MOVE SLOWER!');
    end
end



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

% determine selected symbol filename
filename = get_symbol_filename(handles);

if exist(filename, 'file')
    load(filename, '-mat', 'raw_track_values');
    
    % print current number of raw_track sequences
    counter_str = sprintf('%i tracks', size(raw_track_values, 2));
    set(handles.symbol_browse_counter, 'String', counter_str);
else
    counter_str = '0 tracks';
    set(handles.symbol_browse_counter, 'String', counter_str);
end



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

% get symbols defined by user
symbol_selection_names = get(hObject, 'String');
if ~iscell(symbol_selection_names)
    symbol_selection_names = cellstr(symbol_selection_names);
end

nr_lines = size(symbol_selection_names, 1);
nr_cols = size(symbol_selection_names, 2);

% make it a row cell array
if nr_lines > nr_cols
    symbol_selection_names = reshape(symbol_selection_names, ...
                                [nr_cols nr_lines]);
end

% check for existence of symbol_config.mat file
global symbol_config_filename
global resample_interval
global hamming_window_size
global hamming_window_step
global nr_clusters

if (~exist(symbol_config_filename, 'file'))
    symbols = symbol_selection_names;
    feature_extraction_parameters.resample_interval = resample_interval;
    feature_extraction_parameters.hamming_window_size = hamming_window_size;
    feature_extraction_parameters.hamming_window_step = hamming_window_step;
    feature_extraction_parameters.nr_clusters = nr_clusters;
    
    save(symbol_config_filename, 'symbols', 'feature_extraction_parameters');
else
    % read the variables stored in the mat file
    vars = whos('-file', symbol_config_filename);
    
    symbols = symbol_selection_names;
    
    % if symbols already stored in config file, then update
    if (ismember('symbols', {vars.name}))
        load(symbol_config_filename, 'symbols');
        diff_idx = ~ismember(symbol_selection_names, symbols);
        symbols = [symbols symbol_selection_names(diff_idx)];
    end
    
    save(symbol_config_filename, 'symbols', '-append');
    set(hObject, 'String', symbols);
end


% --- Executes on selection change in symbol_purpose.
function symbol_purpose_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_purpose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns symbol_purpose contents as cell array
%        contents{get(hObject,'Value')} returns selected item from symbol_purpose
% determine selected symbol filename
filename = get_symbol_filename(handles);

if exist(filename, 'file')
    load(filename, '-mat', 'raw_track_values');
    
    % print current number of raw_track sequences
    counter_str = sprintf('%i tracks', size(raw_track_values, 2));
    set(handles.symbol_browse_counter, 'String', counter_str);
else
    counter_str = '0 tracks';
    set(handles.symbol_browse_counter, 'String', counter_str);
end


% --- Executes during object creation, after setting all properties.
function symbol_purpose_CreateFcn(hObject, eventdata, handles)
% hObject    handle to symbol_purpose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in symbol_clear.
function symbol_clear_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
padH = handles.symbol_pad;
set(padH, 'UserData', []);

set(handles.symbol_messages, 'String', '');
cla(handles.symbol_pad);
cla(handles.symbol_x_func);
cla(handles.symbol_y_func);


% --- Executes on button press in symbol_save.
function symbol_save_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
padH = handles.symbol_pad;
track_data = get(padH, 'UserData');
set(padH, 'UserData', []);

% clear symbol_pad and x and y signal axes
set(handles.symbol_messages, 'String', '');
cla(handles.symbol_pad);
cla(handles.symbol_x_func);
cla(handles.symbol_y_func);

len_track = size(track_data, 1);

global nr_points
if len_track > nr_points
    %track_data = bbox_resize(track_data); 
    sampled_track_data = track_data;
    
    % store raw data to selected symbol file
    %filename = strcat(symbol_choice, '_', symbol_purpose, '.mat');
    filename = get_symbol_filename(handles);
    
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
    
    set(handles.symbol_messages, 'String', ...
        'SYMBOL SAVED!');
    
    % print current number of raw_track sequences
    counter_str = sprintf('%i tracks', size(raw_track_values, 2));
    set(handles.symbol_browse_counter, 'String', counter_str);
else
    set(handles.symbol_messages, 'String', ...
        'NOT ENOUGH POINTS SAMPLED. MOVE SLOWER!');
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

bbox_track_data(:, 3) = track_data(:, 3) - track_data(1, 3);

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function CreateDataset_Callback(hObject, eventdata, handles)
% hObject    handle to CreateDataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global current_raw_track_values
current_raw_track_values = {};

global CREATE
switch_gui_mode(CREATE, handles);


% --------------------------------------------------------------------
function BrowseDataset_Callback(hObject, eventdata, handles)
% hObject    handle to BrowseDataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BROWSE
global current_raw_track_values

[dataset_filename] = uigetfile('*.mat','Select the dataset file');

if ~isequal(dataset_filename, 0)
    load(dataset_filename, 'raw_track_values');

    current_raw_track_values = raw_track_values;    
    switch_gui_mode(BROWSE, handles);
end




% --- Executes during object creation, after setting all properties.
function symbol_define_new_CreateFcn(hObject, eventdata, handles)
% hObject    handle to symbol_define_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function symbol_define_new_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_define_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of symbol_define_new as text
%        str2double(get(hObject,'String')) returns contents of symbol_define_new as a double


% --- Executes on button press in symbol_add_new_button.
function symbol_add_new_button_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_add_new_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global symbol_config_filename

% get symbol name from define new
new_symbol_name = get(handles.symbol_define_new, 'String');
if (~isempty(new_symbol_name))
    % get the existing symbol name selections
    symbol_sel_names = get(handles.symbol_select, 'String');
    
    % append new symbol name
    if iscell(symbol_sel_names)
        symbol_sel_names{end + 1} = new_symbol_name;
    else
        symbol_sel_names = char(symbol_sel_names, new_symbol_name);
    end
    
    % append new symbol name in config file as well
    load(symbol_config_filename, 'symbols');
    
    if (~ismember(new_symbol_name, symbols))
        symbols{end + 1} = new_symbol_name;
    end
    save(symbol_config_filename, 'symbols', '-append');
    
    set(handles.symbol_select, 'String', symbol_sel_names);
    set(handles.symbol_define_new, 'String', '');
end


% --- Executes on button press in symbol_browse_prev.
function symbol_browse_prev_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_browse_prev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global current_track_idx

if (current_track_idx > 1)
    current_track_idx = current_track_idx - 1;
    plot_browse_current_track(handles);
end



% --- Executes on button press in symbol_browse_next.
function symbol_browse_next_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_browse_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global current_track_idx 
global current_raw_track_values

if (current_track_idx < size(current_raw_track_values, 2))
    current_track_idx = current_track_idx + 1;
    plot_browse_current_track(handles);
end


function switch_gui_mode(mode, handles)
% switch between BROWSE and CREATE gui modes
global gui_mode
global CREATE
global BROWSE
global current_track_idx

if gui_mode ~= mode
    if mode == CREATE
        gui_mode = mode;
        
        % clear the pads
        padH = handles.symbol_pad;
        set(padH, 'UserData', []);
        set(handles.symbol_messages, 'String', '');
        cla(handles.symbol_pad);
        cla(handles.symbol_x_func);
        cla(handles.symbol_y_func);
        
        % disable browser buttons
        set(handles.symbol_browse_prev, 'Enable', 'off');
        set(handles.symbol_browse_next, 'Enable', 'off');
        
        % enable symbol name selection and creation
        set(handles.symbol_select, 'Enable', 'on');
        set(handles.symbol_purpose, 'Enable', 'on');
        set(handles.symbol_define_new, 'Enable', 'on');
        set(handles.symbol_add_new_button, 'Enable', 'on');
        set(handles.symbol_save, 'Enable', 'on');
        set(handles.symbol_clear, 'Enable', 'on');
        
        % clear symbol_browser_counter
        set(handles.symbol_browse_counter, 'String', '');
        
    elseif mode == BROWSE
        gui_mode = mode;
        
        % enable browser buttons
        set(handles.symbol_browse_prev, 'Enable', 'on');
        set(handles.symbol_browse_next, 'Enable', 'on');
        
        set(handles.symbol_select, 'Enable', 'off');
        set(handles.symbol_purpose, 'Enable', 'off');
        set(handles.symbol_define_new, 'Enable', 'off');
        set(handles.symbol_add_new_button, 'Enable', 'off');
        set(handles.symbol_save, 'Enable', 'off');
        set(handles.symbol_clear, 'Enable', 'off');
        
        % raw_track_values should already be loaded
        % so get first track and plot it
        current_track_idx = 1;
        
        plot_browse_current_track(handles);
    end
end


function plot_browse_current_track(handles)
global current_raw_track_values 
global current_track_idx
global resample_interval

current_track = current_raw_track_values{current_track_idx};

cla(handles.symbol_pad);
hold(handles.symbol_pad, 'on');

plot(handles.symbol_pad, ...
    current_track(:,1)', ...
    current_track(:,2)', 'g*');

hold(handles.symbol_pad, 'off');

current_track = bbox_resize(current_track);
current_track = ...
    resample_track_data(current_track, resample_interval, 0);
    
plot(handles.symbol_x_func, ...
    current_track(:,3)', ...
    current_track(:,1)', 'b');

plot(handles.symbol_y_func, ...
    current_track(:,3)', ...
    current_track(:,2)', 'b');

% print current track numbner
counter_str = sprintf('%i of %i tracks', ...
    current_track_idx, size(current_raw_track_values, 2));
set(handles.symbol_browse_counter, 'String', counter_str);


function [symbol_filename] = get_symbol_filename(handles)
% determine selected symbol name
symbol_sel_names = get(handles.symbol_select, 'String');
symbol_sel_index = get(handles.symbol_select, 'Value');
if iscell(symbol_sel_names)
    symbol_choice = symbol_sel_names{symbol_sel_index};
else
    symbol_choice = symbol_sel_names(symbol_sel_index, :);
end

% determine selected symbol purpose
symbol_sel_purposes = get(handles.symbol_purpose, 'String');
symbol_sel_index = get(handles.symbol_purpose, 'Value');
if iscell(symbol_sel_purposes)
    symbol_purpose = symbol_sel_purposes{symbol_sel_index};
else
    symbol_purpose = symbol_sel_purposes(symbol_sel_index, :);
end

symbol_app_name = 'symbolapp';
symbol_app_folder = 'acquisition';

symbol_filename = ...
    strcat(symbol_app_name, filesep, ...
           symbol_app_folder, filesep, ...
           symbol_choice, '_', symbol_purpose, '.mat');
