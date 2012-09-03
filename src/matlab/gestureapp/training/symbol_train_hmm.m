function [Pi, A, B] = symbol_train_hmm(symbol, transition_model)
%%  Trains the HMM model for the specified symbol
%   The function assumes the existance of two files:
%       - <symbol>.mat contains the raw mouse track sequences of which
%         3/4 are used for training
%       - <symbol>_codebook.mat contains the codebook vectors defined
%         for the symbol <symbol>
%
%   Inputs: symbol - a string denoting the symbol name to train the HMM
%                    parameters for
%
%   Outputs: the learned HMM parameters
%               A - the transition matrix
%               B - the emission matrix
%               Pi - the initial state probabilities

%% Initialization
% build filenames
symbol_track_file = strcat(symbol, '.mat');
symbol_codebook_file = 'symbol_feature_codebook.mat';

% load raw_track and codebook variables
load(symbol_track_file, 'raw_track_values');
load(symbol_codebook_file, 'x_codebook', 'y_codebook');

% 3/4 training data randomly chosen
len_total = size(raw_track_values, 2);
randomized_idx = randperm(len_total);

len_td = floor(3 * len_total / 4);
training_track_values = ...
    raw_track_values(randomized_idx(1:len_td));

% auxiliary variables
OL = cell(1, len_td);   % stores the indexes of the codebook elements
                        % that are used as entries for the B matrix
R = 2;                  % there are two dimensions: x and y
TMax = 0;

% load FFT feature extraction parameters from file
feature_param_file = 'feature_extraction_parameters.mat';
load(feature_param_file, 'resample_interval', ...
                         'hamming_window_size', ...
                         'hamming_window_step');

for l = 1 : len_td
    ol = symbol_get_feature_sequence(training_track_values{l}, ...
                x_codebook, y_codebook, ...,
                resample_interval, ...,
                hamming_window_size, ...,
                hamming_window_step);
    
    if TMax > size(ol, 2)
        TMax = size(ol, 2);
    end
    
    OL{1, l} = ol;
end

% build O matrix as required by baum_welch_discrete_multidim
O = zeros(len_td, R, TMax);
T = zeros(1, len_td);
for l = 1 : len_td
    T(l) = size(OL{1, l}, 2);  % T marks the length of this sequence
    O(l, :, 1:T(l)) = OL{1, l};
end

%% Training
N = 8;                      % number of states to consider
M = size(x_codebook, 1);    % M is the number of codebook vectors
max_iter = 50;              % consider at most 50 iterations of the 
                            % learning algorithm
                            
[Pi, A, B] = ... 
    baum_welch_discrete_multidim(O, T, N, M, ...
                        transition_model, max_iter);