function [x_fft_vectors, y_fft_vectors] = symbol_preprocess_fft(track_data, ...
                    resample_interval, hamming_window_size, hamming_window_step)
%%  process a raw track of the mouse movement sequence by generating
%   a FFT representation of the sequence to be used as feature vector
%
%   Inputs:
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

% resample the raw track data at even resample_interval delays using 
% linear interpolation
v1 = track_data(1, 3);
track_data(:,3) = track_data(:, 3) - v1;

resampled_track_data = resample_track_data(track_data, resample_interval, 0);
low_t = 0;
high_t = hamming_window_size;
end_t = resampled_track_data(end, 3);

%x_vectors = [];
%y_vectors = [];

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
    
    %{
    % give them a sense of direction (increasing vs decreasing)
    % compute phases
    x_phase = atan2(imag(xvals_fft'), real(xvals_fft'));
    y_phase = atan2(imag(yvals_fft'), real(yvals_fft'));
    
    sign_xvals = sign(sum(sign(x_phase(1:(NFFT / 2)))));
    sign_yvals = sign(sum(sign(y_phase(1:(NFFT / 2)))));
    
    x_fft_vectors(i, :) = abs(xvals_fft) * sign_xvals;
    y_fft_vectors(i, :) = abs(yvals_fft) * sign_yvals;
    %}
    
    %x_vectors = [x_vectors; abs(xvals_fft)'];
    %y_vectors = [y_vectors; abs(yvals_fft)'];
    x_fft_vectors(i, :) = abs(xvals_fft);
    y_fft_vectors(i, :) = abs(yvals_fft);
    
    % move window
    low_t = low_t + hamming_window_step;
    high_t = high_t + hamming_window_step;
end
