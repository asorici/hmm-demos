function [x_vectors, y_vectors] = symbol_vq_vectors(symbol, resample_interval, ...
                         hamming_window_size, hamming_window_step)
%%  gets the training feature vectors that are to be quantized
%   for a given symbol type, in order to be added to the 
%   feature codebook
%
%   Inputs:
%     symbol:              a string naming the symbol
%     resample_interval:   this argument defines the resampling 
%                          time interval to be used on the 
%                          raw track sequences
%     hamming_window_size: defines the window size in seconds for the FFT window
%     hamming_window_step: defines the size in seconds of the FFT window shift
%                          parameter
%   
%   Outpus:
%     x_vectors: the x-dimension feature vectors for the symbol
%     y_vectors: the y-dimension feature vectors for the symbol  
%
%
%   This function assumes the existance of the file with the name
%   <symbol>_train.mat containing several instances of symbol sequences 
%   of the type <symbol>. If not found, this function will fail silently.


%%  Initialization
x_vectors = [];
y_vectors = [];

filename = strcat(symbol, '_train.mat');
% return empty vectors if no training file exists
if (~exist(filename, 'file'))
    return;
end

% read the training set
load(filename, 'raw_track_values');
training_track_values = raw_track_values;
len_td = size(training_track_values, 2);

%% Processing
for i=1:len_td
    [x_fft_vectors, y_fft_vectors] = ...
        symbol_preprocess_fft(training_track_values{i}, ...
                              resample_interval, hamming_window_size, ...
                              hamming_window_step);
    
    x_vectors = [x_vectors; x_fft_vectors];
    y_vectors = [y_vectors; y_fft_vectors];
end


