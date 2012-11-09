function [Pi, A, B] = symbol_train_hmm(symbol, transition_model, ...
                          x_codebook, y_codebook, resample_interval, ...
                          hamming_window_size, hamming_window_step)
%%  Trains the HMM model for the specified symbol
%   The function assumes the existance of two files:
%       - <symbol>_train.mat contains the raw mouse track sequences
%       
%   Inputs: 
%       symbol - a string denoting the symbol name to train the
%               HMM parameters for
%
%   Outputs: 
%       the learned HMM parameters
%       A - the transition matrix
%       B - the emission matrix
%       Pi - the initial state probabilities

%% Initialization
% build filenames
training_track_filename = strcat(symbol, '_train.mat');
if (~exist(training_track_filename, 'file'))
    error('symbol_train_hmm:config', ... 
          'The file %s is not on the MATLAB path.', ...
          training_track_filename);
end

% load raw_track and codebook variables
load(training_track_filename, 'raw_track_values');

training_track_values = raw_track_values;
len_td = size(training_track_values, 2);

% auxiliary variables
OL = cell(1, len_td);   % stores the indexes of the codebook elements
                        % that are used as entries for the B matrix
R = 2;                  % there are two dimensions: x and y
TMax = 0;


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
    baum_welch_multi_disc(O, T, N, M, transition_model, ...
                                max_iter);
                    
end