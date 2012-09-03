%% Define parameters for quantization and FFT feature extraction
symbols = {'left_arrow' 'right_arrow' 'circle' 'square'};
resample_interval = 0.02;
hamming_window_size = 0.32;
hamming_window_step = 0.16;
nr_clusters = 64;

% store the FFT feature extraction parameters in a file
feature_param_file = 'feature_extraction_parameters.mat';
save(feature_param_file, 'resample_interval', ...
                         'hamming_window_size', ...
                         'hamming_window_step', ...
                         'nr_clusters');

symbol_strings = char(symbols);

%% Compute code vectors and store them
for s=1:size(symbol_strings, 1)
    symbol_name = symbol_strings(s, :);
    symbol_vq_codebook(symbol_name, nr_clusters, ...
                       resample_interval, ...
                       hamming_window_size, hamming_window_step);
    fprintf('Created codebook for symbol: %s\n', strtrim(symbol_name));
end