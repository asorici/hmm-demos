function [x_vectors, y_vectors] = symbol_vq_vectors(symbol, resample_interval, ...
                         hamming_window_size, hamming_window_step)
%%  gets the training feature vectors that are to be quantized
%   for a given gesture type, in order to be added to the 
%   feature codebook
%
%   Inputs:
%     symbol:              a string naming the gesture
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
%   <symbol>.mat containing several instances of gesture sequences 
%   of the type <symbol>


%%  Initialization
x_vectors = [];
y_vectors = [];

filename = strcat(symbol, '.mat');
load(filename, 'raw_track_values');

% 3/4 training data randomly chosen
len_total = size(raw_track_values, 2);
randomized_idx = randperm(len_total);

len_td = floor(3 * len_total / 4);
training_track_values = ...
    raw_track_values(randomized_idx(1:len_td));

%% Processing
for i=1:len_td
    %resampled_training_values = resample_track_data(training_track_values{i}, resample_interval, 0);
    %resampled_training_values = resample_track_data(training_track_values{i}, resample_interval, 2 * size(training_track_values{i}, 1));
    %resampled_training_values = resample_track_data(training_track_values{i}, resample_interval, 128);
    [x_fft_vectors, y_fft_vectors] = ...
        symbol_preprocess_fft(training_track_values{i}, ...
                              resample_interval, hamming_window_size, ...
                              hamming_window_step);
    
    x_vectors = [x_vectors; x_fft_vectors];
    y_vectors = [y_vectors; y_fft_vectors];
end


