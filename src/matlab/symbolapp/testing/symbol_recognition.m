function varargout = symbol_recognition(varargin)
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

% Last Modified by GUIDE v2.5 08-Nov-2012 17:50:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @symbol_recognition_OpeningFcn, ...
                   'gui_OutputFcn',  @symbol_recognition_OutputFcn, ...
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


% --- Executes during object creation, after setting all properties.
function symbol_recognition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to symbol_recognition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

global nr_points
nr_points = 64;

global symbol_codebook_filename symbol_config_filename
symbol_config_filename = 'symbol_config.mat';
symbol_codebook_filename = 'symbol_feature_codebook.mat';


% --- Executes just before symbol_recognition is made visible.
function symbol_recognition_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to symbol_recognition (see VARARGIN)

% Choose default command line output for symbol_recognition
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes symbol_recognition wait for user response (see UIRESUME)
% uiwait(handles.symbol_recognition);


% --- Outputs from this function are returned to the command line.
function varargout = symbol_recognition_OutputFcn(hObject, eventdata, handles) 
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
% get which mouse button was pressed
button = get(gcbf, 'SelectionType');

if strcmpi(button, 'normal')
    set(gcbf, 'WindowButtonMotionFcn', @motionfcn);
elseif strcmpi(button, 'alt')
    set(handles.symbol_pad, 'UserData', []);
    cla;
end


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function symbol_recognition_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to symbol_recognition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcbf, 'WindowButtonMotionFcn', '');


function motionfcn(hObject, eventdata)
%padH = gca;
h = guidata(hObject);
padH = h.symbol_pad;
mousePositionData = get(padH, 'CurrentPoint');

t = clock;
t_mark = t(4) * 3600 + t(5) * 60 + t(6);

current_track = get(padH, 'UserData');
set(padH, 'UserData',[current_track; mousePositionData(1,1) mousePositionData(1,2) t_mark]);

hold on;
plot(mousePositionData(1,1), mousePositionData(1,2), 'r*');
hold off;


% --- Executes on button press in button_test_symbol.
function button_test_symbol_Callback(hObject, eventdata, handles)
% hObject    handle to button_test_symbol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global symbol_codebook_filename symbol_config_filename
global nr_points

% get stored track data and then clear the userdata value
padH = handles.symbol_pad;
track_data = get(padH, 'UserData');
set(padH, 'UserData', []);

hmm_model_index = get(handles.hmm_model_select, 'Value');
hmm_model_types = get(handles.hmm_model_select, 'String');
if iscell(hmm_model_types)
    hmm_model_choice = hmm_model_types{hmm_model_index};
else
    hmm_model_choice = hmm_model_types(hmm_model_index, :);
end

% get symbols in symbol_selected_listbox
selected_symbol_contents = cellstr(...
    get(handles.symbol_selected_listbox, 'String'));

if isempty(selected_symbol_contents)
    set(handles.text_likelihood_data, 'String', ...
        'NO SYMBOLS IN SELECTED LIST!');
    return;
end

symbol_strings = char(selected_symbol_contents);

if size(track_data, 1) > nr_points
    track_data = bbox_resize(track_data);
    sampled_track_data = track_data;
    
    [candidate_symbol_name, ll] = ...
        symbol_recognize(selected_symbol_contents, ...
                sampled_track_data, hmm_model_choice, ...
                symbol_codebook_filename, ...
                symbol_config_filename);
    
    set(handles.text_detected_symbol, ...
        'String', candidate_symbol_name);
    
    ll_text = [];
    for s = 1 : size(ll, 2)
        str = sprintf('Symbol %s = %0.5f \n', strtrim(symbol_strings(s, :)), ll(1, s));
        ll_text = [ll_text str];
    end
    
    set(handles.text_likelihood_data, 'String', ll_text);
    
else
    set(handles.text_likelihood_data, 'String', 'NOT ENOUGH POINTS SAMPLED. MOVE SLOWER!');
end



% --- Executes on button press in button_clear_symbol.
function button_clear_symbol_Callback(hObject, eventdata, handles)
% hObject    handle to button_clear_symbol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla;
set(handles.symbol_pad, 'UserData', []);
set(handles.text_likelihood_data, 'String', '');
set(handles.text_detected_symbol, 'String', '');



function text_likelihood_data_Callback(hObject, eventdata, handles)
% hObject    handle to text_likelihood_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_likelihood_data as text
%        str2double(get(hObject,'String')) returns contents of text_likelihood_data as a double


% --- Executes during object creation, after setting all properties.
function text_likelihood_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_likelihood_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in hmm_model_select.
function hmm_model_select_Callback(hObject, eventdata, handles)
% hObject    handle to hmm_model_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns hmm_model_select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from hmm_model_select


% --- Executes during object creation, after setting all properties.
function hmm_model_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hmm_model_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Auxiliary function to compute bounding box of the symbol
% sequence and resize the values of the sequence accordingly
function [track_data] = bbox_resize(track_data)
len_seq = size(track_data, 1);
    
% determine bounding box of symbol sequence
x_min = min(track_data(:, 1));
x_max = max(track_data(:, 1));

y_min = min(track_data(:, 2));
y_max = max(track_data(:, 2));

% and resize sequence to bounding box
track_data(:, 1) = ...
    (track_data(:, 1) - ones(len_seq, 1) * x_min) ./ (x_max - x_min);

track_data(:, 2) = ...
    (track_data(:, 2) - ones(len_seq, 1) * y_min) ./ (y_max - y_min);

track_data(:, 3) = track_data(:, 3) - track_data(1, 3);

% --- Executes during object creation, after setting all properties.
function button_test_symbol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to button_test_symbol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function button_clear_symbol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to button_clear_symbol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_detected_symbol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_detected_symbol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in symbol_existing_listbox.
function symbol_existing_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_existing_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns symbol_existing_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from symbol_existing_listbox


% --- Executes during object creation, after setting all properties.
function symbol_existing_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to symbol_existing_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% load all symbols from symbol config
global symbol_config_filename
if (~exist(symbol_config_filename, 'file'))
    error('symbol_recognition:symbol_listing', ... 
          'The file symbol_config.mat is not on the MATLAB path.');
end

load(symbol_config_filename, 'symbols');
set(hObject, 'String', symbols);


% --- Executes on selection change in symbol_selected_listbox.
function symbol_selected_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_selected_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns symbol_selected_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from symbol_selected_listbox


% --- Executes during object creation, after setting all properties.
function symbol_selected_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to symbol_selected_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in symbol_add_button.
function symbol_add_button_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_add_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get existing items and the one selected
existing_symbol_contents = cellstr(...
    get(handles.symbol_existing_listbox, 'String'));
selected_symbol = ...
    existing_symbol_contents{get(handles.symbol_existing_listbox, 'Value')};

% get already selected contents
selected_symbol_contents = cellstr(...
    get(handles.symbol_selected_listbox, 'String'));

% add new symbol name if not contained
if isempty(selected_symbol_contents{end})
    selected_symbol_contents{end} = selected_symbol;
elseif ~ismember(selected_symbol, selected_symbol_contents)
    selected_symbol_contents{end + 1} = selected_symbol;
end

set(handles.symbol_selected_listbox, 'String', ...
            selected_symbol_contents);



% --- Executes on button press in symbol_remove_button.
function symbol_remove_button_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_remove_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get already selected contents
selected_symbol_contents = cellstr(...
    get(handles.symbol_selected_listbox, 'String'));

if isempty(selected_symbol_contents)
    return;
end

selected_symbol_idx = ...
    get(handles.symbol_selected_listbox, 'Value');

% remove selected symbol
selected_symbol_contents(selected_symbol_idx) = [];
value = selected_symbol_idx - 1;

if value < 1
    value = 1;
end

if isempty(selected_symbol_contents)
    selected_symbol_contents = {''};
end

% restore changed contents
set(handles.symbol_selected_listbox, ...
            'String', selected_symbol_contents, ...
            'Value', value);
