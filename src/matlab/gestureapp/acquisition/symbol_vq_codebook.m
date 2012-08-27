function symbol_vq_codebook(symbol, nr_clusters, resample_interval, ...
                            window_size, window_step)
%%  generates the codebook vectors for a given gesture type
%   Inputs:
%       gesture - a string naming the gesture
%       nr_clusters - the number of codebook vectors for this gesture
%       resample_interval - this argument defines the resampling 
%                           time interval to be used on the raw track
%                           sequences
%       window_size - defines the window size in seconds for the FFT window
%       window_step - defines the size in seconds of the FFT window shift
%                     parameter
%   
%   This function assumes the existance of the file with the name
%   <gesture>.mat containing several instances of gesture sequences of
%   the type <gesture>


%%  Initialization
symbols = {'left_arrow' 'right_arrow' 'circle' 'square'};

% define the name of the codebook output file
codebook_filename = strcat(symbol, '_codebook.mat');
x_vectors = [];
y_vectors = [];

filename = strcat(symbol, '.mat');
load(filename, 'raw_track_values');

% 3/4 training data
len_td = floor(3 * size(raw_track_values, 2) / 4);
training_track_values = raw_track_values(1:len_td);

%% Processing
for i=1:len_td
    v1 = training_track_values{i}(1, 3);
    training_track_values{i}(:,3) = training_track_values{i}(:, 3) - v1;
    %resampled_training_values = resample_track_data(training_track_values{i}, resample_interval, 0);
    %resampled_training_values = resample_track_data(training_track_values{i}, resample_interval, 2 * size(training_track_values{i}, 1));
    %resampled_training_values = resample_track_data(training_track_values{i}, resample_interval, 128);

    [x_fft_vectors, y_fft_vectors] = ...
        symbol_preprocess_fft(training_track_values{i}, ...
                              resample_interval, window_size, ...
                              window_step);
    
    x_vectors = [x_vectors; x_fft_vectors];
    y_vectors = [y_vectors; y_fft_vectors];
end


% use LBG kmeans to compute codebook vectors
[x_codebook, esq, J_x] = kmeanlbg(x_vectors, nr_clusters);
[y_codebook, esq, J_y] = kmeanlbg(y_vectors, nr_clusters);

%x_codebook
%y_codebook

save(codebook_filename, 'x_codebook', 'y_codebook');