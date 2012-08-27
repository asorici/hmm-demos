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

% Last Modified by GUIDE v2.5 27-Aug-2012 23:11:43

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

global nr_points
nr_points = 64;


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


% --- Executes on button press in button_test_symbol.
function button_test_symbol_Callback(hObject, eventdata, handles)
% hObject    handle to button_test_symbol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get stored track data and then clear the userdata value
padH = gca;
track_data = get(padH, 'userdata');
set(padH, 'userdata', []);

symbols = {'left_arrow' 'right_arrow' 'circle' 'square'};
symbol_strings = char(symbols);

global nr_points
if size(track_data, 1) > nr_points
    % clear symbol pad from old plots
    
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
    
    ll = zeros(1, size(symbol_strings, 1));
    most_likely_symbol_idx = 1;
    max_ll = -Inf;
    
    for s=1:size(symbol_strings, 1)
        symbol_name = symbol_strings(s, :);
        codebook_filename = strcat(symbol_name, '_codebook.mat');
        hmm_data_filename = strcat(symbol_name, '_hmm.mat');
        
        % load the codebook vectors and the hmm parameters for the alleged symbol
        load(codebook_filename, 'x_codebook', 'y_codebook');
        load(hmm_data_filename, 'Pi', 'A', 'B');
        
        O = symbol_get_feature_sequence(sampled_track_data, ...
                x_codebook, y_codebook, 0.02, 0.16, 0.08);
        
        [Prob, ~, ~, ~] = forward_backward(O, Pi, A, B);
        ll(1, s) = log(Prob);
        
        if ll(1, s) > max_ll
            max_ll = ll(1, s);
            most_likely_symbol_idx = s;
        end
    end
    
    % load recognition threshold for best symbol so far
    candidate_symbol_name = symbol_strings(most_likely_symbol_idx, :);
    hmm_data_filename = strcat(candidate_symbol_name, '_hmm.mat');
    load(hmm_data_filename, 'symbol_rec_threshold');
    
    
    if max_ll >= symbol_rec_threshold
        set(handles.text_detected_symbol, 'String', candidate_symbol_name);
    else
        set(handles.text_detected_symbol, 'String', 'Unknown');
    end
    
    ll_text = [];
    for s = 1 : size(ll, 2)
        str = sprintf('Symbol %s = %0.5f \n', strtrim(symbol_strings(s, :)), ll(1, s));
        ll_text = [ll_text str];
    end
    
    set(handles.text_likelihood_data, 'String', ll_text);
    
else
    set(handles.text_likelihood_data, 'String', 'NOT ENOUGH POINTS SAMPLED. MOVE SLOWER!');
    disp('NOT ENOUGH POINTS SAMPLED. MOVE SLOWER!');
end



% --- Executes on button press in button_clear_symbol.
function button_clear_symbol_Callback(hObject, eventdata, handles)
% hObject    handle to button_clear_symbol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla;
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
