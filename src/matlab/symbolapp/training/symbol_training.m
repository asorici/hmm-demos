function varargout = symbol_training(varargin)
% SYMBOL_TRAINING MATLAB code for symbol_training.fig
%      SYMBOL_TRAINING, by itself, creates a new SYMBOL_TRAINING or raises the existing
%      singleton*.
%
%      H = SYMBOL_TRAINING returns the handle to a new SYMBOL_TRAINING or the handle to
%      the existing singleton*.
%
%      SYMBOL_TRAINING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SYMBOL_TRAINING.M with the given input arguments.
%
%      SYMBOL_TRAINING('Property','Value',...) creates a new SYMBOL_TRAINING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before symbol_training_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to symbol_training_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help symbol_training

% Last Modified by GUIDE v2.5 08-Nov-2012 19:58:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @symbol_training_OpeningFcn, ...
                   'gui_OutputFcn',  @symbol_training_OutputFcn, ...
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


% --- Executes just before symbol_training is made visible.
function symbol_training_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to symbol_training (see VARARGIN)

% Choose default command line output for symbol_training
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes symbol_training wait for user response (see UIRESUME)
% uiwait(handles.symbol_training);


% --- Outputs from this function are returned to the command line.
function varargout = symbol_training_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function symbol_training_CreateFcn(hObject, eventdata, handles)
% hObject    handle to symbol_training (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

global symbol_codebook_filename symbol_config_filename
symbol_config_filename = 'symbol_config.mat';
symbol_codebook_filename = 'symbol_feature_codebook.mat';

global extraction_params_set 
extraction_params_set = 1;

global dataset_percentages_set
dataset_percentages_set = 1;

global codebook_computed;
codebook_computed = 0;

global MANUAL PERCENTAGE dataset_mode
PERCENTAGE = 1;
MANUAL = 2;
dataset_mode = PERCENTAGE;


function symbol_nr_clusters_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_nr_clusters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of symbol_nr_clusters as text
%        str2double(get(hObject,'String')) returns contents of symbol_nr_clusters as a double


% --- Executes during object creation, after setting all properties.
function symbol_nr_clusters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to symbol_nr_clusters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function symbol_resample_interval_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_resample_interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of symbol_resample_interval as text
%        str2double(get(hObject,'String')) returns contents of symbol_resample_interval as a double


% --- Executes during object creation, after setting all properties.
function symbol_resample_interval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to symbol_resample_interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function symbol_hamming_window_size_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_hamming_window_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of symbol_hamming_window_size as text
%        str2double(get(hObject,'String')) returns contents of symbol_hamming_window_size as a double


% --- Executes during object creation, after setting all properties.
function symbol_hamming_window_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to symbol_hamming_window_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function symbol_hamming_window_step_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_hamming_window_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of symbol_hamming_window_step as text
%        str2double(get(hObject,'String')) returns contents of symbol_hamming_window_step as a double


% --- Executes during object creation, after setting all properties.
function symbol_hamming_window_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to symbol_hamming_window_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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




function symbol_train_output_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_train_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of symbol_train_output as text
%        str2double(get(hObject,'String')) returns contents of symbol_train_output as a double


% --- Executes during object creation, after setting all properties.
function symbol_train_output_CreateFcn(hObject, eventdata, handles)
% hObject    handle to symbol_train_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in symbol_dataset_option.
function symbol_dataset_option_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_dataset_option (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns symbol_dataset_option contents as cell array
%        contents{get(hObject,'Value')} returns selected item from symbol_dataset_option


% --- Executes during object creation, after setting all properties.
function symbol_dataset_option_CreateFcn(hObject, eventdata, handles)
% hObject    handle to symbol_dataset_option (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in symbol_transition_type_selection.
function symbol_transition_type_selection_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_transition_type_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns symbol_transition_type_selection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from symbol_transition_type_selection


% --- Executes during object creation, after setting all properties.
function symbol_transition_type_selection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to symbol_transition_type_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in symbol_codebook_button.
function symbol_codebook_button_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_codebook_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global extraction_params_set codebook_computed
global symbol_codebook_filename

% verify that all feature extraction parameters exist
nr_clusters = str2double(get(handles.symbol_nr_clusters, 'String'));
resample_interval = str2double(get(handles.symbol_resample_interval, 'String'));
hamming_window_size = str2double(get(handles.symbol_hamming_window_size, 'String'));
hamming_window_step = str2double(get(handles.symbol_hamming_window_step, 'String'));

if isnan(nr_clusters) || isnan(resample_interval) || ...
   isnan(hamming_window_size) || ...
   isnan(hamming_window_step)
        
    codebook_computed = 0;
    extraction_params_set = 0;
    set(handles.symbol_train_output, 'String', ...
        'PLEASE SET ALL FEATURE EXTRACTION PARAMETERS CORRECTLY.');
    
    return;
end

if ~isequal(floor(nr_clusters), ceil(nr_clusters))
    codebook_computed = 0;
    extraction_params_set = 0;
    
    set(handles.symbol_train_output, 'String', ...
        'PLEASE SET ALL FEATURE EXTRACTION PARAMETERS CORRECTLY.');
    return;
end

% all parameters look ok
extraction_params_set = 1;

% get symbol_set
selected_symbol_contents = cellstr(...
    get(handles.symbol_selected_listbox, 'String'));

% call codebook computation
set(handles.symbol_train_output, 'String', ...
        'COMPUTING CODEBOOK FOR SELECTED SYMBOLS. PLEASE WAIT ...');
set(hObject, 'Enable', 'off');
pause(0.5);

try
    symbol_codebook_filename = symbol_compute_codebook(selected_symbol_contents);
catch lasterror
    set(handles.symbol_train_output, 'String', ...
        lasterror.message);
end
    
codebook_computed = 1;
set(handles.symbol_train_output, 'String', ...
        'CODEBOOK HAS BEEN COMPUTED.');
set(hObject, 'Enable', 'on');



% --- Executes on button press in symbol_train_button.
function symbol_train_button_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_train_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function symbol_percentage_train_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_percentage_train (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of symbol_percentage_train as text
%        str2double(get(hObject,'String')) returns contents of symbol_percentage_train as a double


% --- Executes during object creation, after setting all properties.
function symbol_percentage_train_CreateFcn(hObject, eventdata, handles)
% hObject    handle to symbol_percentage_train (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function symbol_percentage_validate_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_percentage_validate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of symbol_percentage_validate as text
%        str2double(get(hObject,'String')) returns contents of symbol_percentage_validate as a double


% --- Executes during object creation, after setting all properties.
function symbol_percentage_validate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to symbol_percentage_validate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function symbol_percentage_test_Callback(hObject, eventdata, handles)
% hObject    handle to symbol_percentage_test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of symbol_percentage_test as text
%        str2double(get(hObject,'String')) returns contents of symbol_percentage_test as a double


% --- Executes during object creation, after setting all properties.
function symbol_percentage_test_CreateFcn(hObject, eventdata, handles)
% hObject    handle to symbol_percentage_test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
