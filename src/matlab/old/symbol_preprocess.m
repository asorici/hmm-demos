function [pattern_x, pattern_y, pattern_x_idx, pattern_y_idx] = symbol_preprocess(track_data)

codebook_filename = 'codebook.mat';
load(codebook_filename, 'x_codebook', 'y_codebook');

window_size = 0.32;
window_step = 0.16;
resample_interval = 0.02;
NFFT = floor(window_size / resample_interval);

% resample the raw track data at even resample_interval delays using linear
% interpolation
v1 = track_data(1, 3);
track_data(:,3) = track_data(:, 3) - v1;

resampled_track_data = resample_track_data(track_data, resample_interval, 0);
low_t = 0;
high_t = window_size;
end_t = resampled_track_data(end, 3);

x_vectors = [];
y_vectors = [];

% perform fft analysis
while high_t <= end_t
    % get values in window
    idx = find(resampled_track_data(:, 3) >= low_t & resampled_track_data(:, 3) < high_t);
    
    xvals = resampled_track_data(idx, 1);
    yvals = resampled_track_data(idx, 2);

    % compute fft in window
    xvals_fft = fft(xvals, NFFT) / NFFT;
    yvals_fft = fft(yvals, NFFT) / NFFT;

    x_vectors = [x_vectors; abs(xvals_fft)'];
    y_vectors = [y_vectors; abs(yvals_fft)'];

    % move window
    low_t = low_t + window_step;
    high_t = high_t + window_step;
end

dx = disteusq(x_vectors, x_codebook);
dy = disteusq(y_vectors, y_codebook);

[~, ix] = max(dx, [], 2);
[~, iy] = max(dy, [], 2);

pattern_x = x_codebook(ix, :);
pattern_y = y_codebook(iy, :);
pattern_x_idx = ix;
pattern_y_idx = iy;
