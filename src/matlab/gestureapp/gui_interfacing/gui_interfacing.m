function [ output ] = ...
    gui_interfacing( widget_name, event, varargin )
%%GUI_INTERFACING 
%   provides interfacing between GUI actions and custom defined
%   scripts of the symbol recognition application
%   Inputs:
%       widgetName: the name of the GUI control which fired this request
%       event:      the type of action performed on the widget
%                   e.g. mouseClick, mousePressed, etc
%       varargin:   additional arguments specific to this request
%   Outputs:
%       output: a cell array containing arguments returned
%               by the specific handling of each request. The GUI
%               frontend making the call must know the semantics of
%               the returned output


%% Switching after the given widget name and event action
if strcmp(widget_name, 'symbolTestButton') && strcmp(event, 'mouseClick')
    if nargin == 4
        track_data = varargin{1};
        hmm_transition_model = varargin{2};
        
        % set the path
        addpath(genpath('../../'));
        
        % get the function name
        function_name = 'symbol_recognize';
        fun = str2func(function_name);
        
        [candidate_symbol, ll_vector] = ...
            fun(track_data, hmm_transition_model);
        
        output = {candidate_symbol, ll_vector};
    else
        error_string = ...
            strcat('Incorrect number of input args in call to ',...
                widget_name, '::', event);
        error(error_string);
    end
else
    error_string = ...
        strcat('No handle defined for widget', widget_name);
    error(error_string);
end

end

