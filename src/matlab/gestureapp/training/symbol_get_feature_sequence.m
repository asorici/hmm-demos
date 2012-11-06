function [O] = symbol_get_feature_sequence(track_data, ... 
                    x_codebook, y_codebook, ...
                    resample_interval, ...
                    hamming_window_size, hamming_window_step)
%%  transform the raw observation sequence into a sequence of indexes
%   corresponding to the closest codebook vectors in feature space
%
%   %   Inputs:
%       track_data - the raw sequence of (x,y,t) coordinates of a
%                    mouse movement sequence
%       x_codebook, y_codebook - the codebook vectors for the 
%                                fft features
%       resample_interval - this argument defines the resampling 
%                           time interval to be used on the raw track
%                           sequence
%       hamming_window_size - defines the window size in seconds 
%                             for the FFT window
%       hamming_window_step - defines the size in seconds of the 
%                             FFT window shift parameter

[x_fft_vectors, y_fft_vectors] = ...
    symbol_preprocess_fft(track_data, ..., 
        resample_interval, hamming_window_size, hamming_window_step);
        
dx = disteusq(x_fft_vectors, x_codebook);
dy = disteusq(y_fft_vectors, y_codebook);

[~, ix] = max(dx, [], 2);
[~, iy] = max(dy, [], 2);

O = [ix iy]';