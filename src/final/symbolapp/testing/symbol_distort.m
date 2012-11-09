function [recognized_symbol, ll_vector] = ...
    symbol_distort(symbols, track_data, hmm_transition_model, ...
                        symbol_codebook_filename, ...
                        symbol_config_filename)
%%SYMBOL_RECOGNIZE test the given input track for being one of the
%   known symbols
%   Input args:
%       symbols: 
%           a vector of strings naming the symbols for which
%           recognition is attempted
%       track_data:
%           a sequence of mouse positions together 
%           with their time annotation
%       transition_model:   
%           the type of transition model used for
%           recognition. Choices: {bakis, ergodic}
%       symbol_codebook_filename: 
%           the name of the file containing the codebook vectors
%           for the symbols contained in the `symbols' input
%       symbol_config_filename
%           the name of the configuration file containing 
%           the FFT feature extraction parameters
%
%
%   Output args:
%       recognized_symbol:  
%           the name of the recognized symbol or 
%           'unknown' if no symbol could be detected
%       ll_vector:          
%           the log likelihood values given by the
%           trained HMM models for each symbol
%
% Author: Alexandru Sorici

%% Initialization 

% read in the symbols, FFT feature extraction parameters and
% codebook vectors from the configuration files

% check for the existance of symbol_config.mat
if (~exist(symbol_config_filename, 'file'))
    error('symbol_recognize:config', ... 
          'The file symbol_config.mat is not on the MATLAB path.');
end

% check for the existance of symbol_feature_codebook.mat
if (~exist(symbol_codebook_filename, 'file'))
    error('symbol_recognize:config', ... 
          'The file symbol_feature_codebook.mat is not on the MATLAB path.');
end

% get symbol strings
symbol_strings = char(symbols);

% load feature_extraction_parameters
load(symbol_config_filename, 'feature_extraction_parameters');
resample_interval = feature_extraction_parameters.resample_interval;
hamming_window_size = feature_extraction_parameters.hamming_window_size;
hamming_window_step = feature_extraction_parameters.hamming_window_step;

% load codebook feature vectors
load(symbol_codebook_filename, 'x_codebook', 'y_codebook');

%% Recognition
% we want to return the log likelihood of the sequence for each symbol
% so we will store the values in the ll_vector
ll_vector = zeros(1, size(symbol_strings, 1));
most_likely_symbol_idx = 1;
max_ll = -Inf;
% Write below

for s=1:size(symbol_strings, 1)
    symbol_name = symbol_strings(s, :);

    hmm_data_filename = strcat(symbol_name, '_hmm_', ...
                                hmm_transition_model, '.mat');

    % load the codebook vectors and the hmm parameters 
    % for the alleged symbol
    load(hmm_data_filename, 'Pi', 'A', 'B');

    O = symbol_get_feature_sequence(track_data, ...
            x_codebook, y_codebook, ...
            resample_interval, ...
            hamming_window_size, hamming_window_step);

    [Prob, ~, ~, ~] = forward_backward_multi_disc(O, Pi, A, B);
    ll_vector(1, s) = Prob;

    if ll_vector(1, s) > max_ll
        max_ll = ll_vector(1, s);
        most_likely_symbol_idx = s;
    end
end

% load recognition threshold for best symbol so far
candidate_symbol_name = symbol_strings(most_likely_symbol_idx, :);
hmm_data_filename = strcat(candidate_symbol_name, '_hmm_', ...
                                hmm_transition_model, '.mat');
load(hmm_data_filename, 'symbol_rec_threshold');


if max_ll >= symbol_rec_threshold
    recognized_symbol = strtrim(candidate_symbol_name);
else
    recognized_symbol = 'unknown';
end

% Write above

end

