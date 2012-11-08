function [x_fft_vectors, y_fft_vectors] = symbol_preprocess_fft(track_data, ...
                    resample_interval, hamming_window_size, hamming_window_step)
%%  process a raw track of the mouse movement sequence by generating
%   a FFT representation of the sequence to be used as feature vector
%
%   Input args:
%       track_data - the raw sequence of (x,y,t) coordinates of a
%                    mouse movement sequence
%       resample_interval - this argument defines the resampling 
%                           time interval to be used on the raw track
%                           sequence
%       hamming_window_size - defines the window size in seconds 
%                             for the FFT window
%       hamming_window_step - defines the size in seconds of the 
%                             FFT window shift parameter


%% processing
NFFT = floor(hamming_window_size / resample_interval);

% step 1: time starts at zero
track_data(:, 3) = track_data(:, 3) - track_data(1, 3);

% step 2: resample the raw track data at even resample_interval delays using 
% linear interpolation
resampled_track_data = resample_track_data(track_data, resample_interval, 0);

% step 3: bbox_resize
resampled_track_data = bbox_resize(resampled_track_data);

% step 4: FFT coefficient computation
low_t = 0;
high_t = hamming_window_size;
end_t = resampled_track_data(end, 3);

data_lines = 1 + floor( (end_t - high_t) / hamming_window_step );
x_fft_vectors = zeros(data_lines, NFFT);
y_fft_vectors = zeros(data_lines, NFFT);

% perform fft analysis
%while high_t <= end_t
for i = 1 : data_lines
    % get values in window
    idx = find(resampled_track_data(:, 3) >= low_t & resampled_track_data(:, 3) < high_t);
    
    xvals = resampled_track_data(idx, 1);
    yvals = resampled_track_data(idx, 2);

    % compute fft in window
    xvals_fft = fft(xvals, NFFT) / NFFT;
    yvals_fft = fft(yvals, NFFT) / NFFT;
    
    x_fft_vectors(i, :) = abs(xvals_fft);
    y_fft_vectors(i, :) = abs(yvals_fft);
    
    % move window
    low_t = low_t + hamming_window_step;
    high_t = high_t + hamming_window_step;
end


function [bbox_track_data] = bbox_resize(track_data)
bbox_track_data = zeros(size(track_data));
len_seq = size(track_data, 1);
    
% determine bounding box of symbol sequence
x_min = min(track_data(:, 1));
x_max = max(track_data(:, 1));

y_min = min(track_data(:, 2));
y_max = max(track_data(:, 2));

% and resize sequence to bounding box
bbox_track_data(:, 1) = ...
    (track_data(:, 1) - ones(len_seq, 1) * x_min) ./ (x_max - x_min);

bbox_track_data(:, 2) = ...
    (track_data(:, 2) - ones(len_seq, 1) * y_min) ./ (y_max - y_min);

bbox_track_data(:, 3) = track_data(:, 3);