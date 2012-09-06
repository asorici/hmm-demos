function test_feature_extraction(symbol)

feature_param_file = 'feature_extraction_parameters.mat';
load(feature_param_file, 'resample_interval', ...
                         'hamming_window_size', ...
                         'hamming_window_step');

raw_track_filename = strcat(symbol, '_train.mat');
load(raw_track_filename, 'raw_track_values');

len_train = size(raw_track_values, 2);

%{
rem_ct = zeros(1, 4);

for i = 1 : len_train
    track_data = raw_track_values{i};
    v1 = track_data(1, 3);
    track_data(:,3) = track_data(:, 3) - v1;

    resampled_track_data = ...
        resample_track_data(track_data, resample_interval, 0);
    
    low_t = 0;
    high_t = hamming_window_size;
    end_t = resampled_track_data(end, 3);
    
    remainder = mod((end_t - high_t), hamming_window_step);
    fprintf('window remainder: %0.4f from %0.4f\n', ...
        remainder, hamming_window_step);
    
    rem_idx = floor(remainder / resample_interval + 1);
    rem_ct(rem_idx) = rem_ct(rem_idx) + 1;
end

rem_ct
%}

sample_idx = 5;
track_data = raw_track_values{sample_idx};
v1 = track_data(1, 3);
track_data(:,3) = track_data(:, 3) - v1;

resampled_track_data = ...
    resample_track_data(track_data, resample_interval, 0);

low_t = 0;
high_t = hamming_window_size;
end_t = resampled_track_data(end, 3);

data_lines = 1 + floor( (end_t - high_t) / hamming_window_step );
NFFT = floor(hamming_window_size / resample_interval);

for i = 1 : data_lines
    % get values in window
    idx = find(resampled_track_data(:, 3) >= low_t & resampled_track_data(:, 3) < high_t);
    
    xvals = resampled_track_data(idx, 1);
    yvals = resampled_track_data(idx, 2);
    
    xvals_reversed = xvals(end:-1:1);
    yvals_reversed = yvals(end:-1:1);
    
    % compute fft in window
    xvals_fft = fft(xvals, NFFT) / NFFT;
    yvals_fft = fft(yvals, NFFT) / NFFT;
    
    xvals_fft_reversed = fft(xvals_reversed, NFFT) / NFFT;
    yvals_fft_reversed = fft(yvals_reversed, NFFT) / NFFT;
    
    fprintf('direct y-dim fft amplitude vals: ');
    disp(abs(yvals_fft'));
    
    fprintf('reverse y-dim fft amplitude vals: ');
    disp(abs(yvals_fft_reversed'));

    fprintf('\n');
    % move window
    low_t = low_t + hamming_window_step;
    high_t = high_t + hamming_window_step;
end
