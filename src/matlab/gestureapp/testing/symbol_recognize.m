function [ recognized_symbol, ll_vector] = ...
    symbol_recognize( track_data, hmm_transition_model )
%%SYMBOL_RECOGNIZE test the given input track for being one of the
%   known symbols
%   Inputs
%       track_data:         a sequence of mouse positions together 
%                           with their time annotation
%       transition_model:   the type of transition model used for
%                           recognition. Choices: {bakis, ergodic}
%
%   Outputs
%       recognized_symbol:  the name of the recognized symbol or 
%                           'unknown' if no symbol could be detected
%       ll_vector:          the log likelihood values given by the
%                           trained HMM models for each symbol
    
symbols = {'left_arrow' 'right_arrow' 'circle' 'square' 'infinity'};
symbol_strings = char(symbols);

% load codebook feature vectors
codebook_filename = 'symbol_feature_codebook.mat';
load(codebook_filename, 'x_codebook', 'y_codebook');

% load the feature extraction parameters
feature_param_file = 'feature_extraction_parameters.mat';
load(feature_param_file, 'resample_interval', ...
                         'hamming_window_size', ...
                         'hamming_window_step');

ll_vector = zeros(1, size(symbol_strings, 1));
most_likely_symbol_idx = 1;
max_ll = -Inf;


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

    [Prob, Alpha, Beta, Scale] = forward_backward(O, Pi, A, B);
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

end

