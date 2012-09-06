%% Define parameters for quantization and FFT feature extraction
symbols = {'left_arrow' 'right_arrow' 'circle' 'square' 'infinity'};
resample_interval = 0.02;
hamming_window_size = 0.16;
hamming_window_step = 0.08;
nr_clusters = 256;

% store the FFT feature extraction parameters in a file
feature_param_file = 'feature_extraction_parameters.mat';
save(feature_param_file, 'resample_interval', ...
                         'hamming_window_size', ...
                         'hamming_window_step', ...
                         'nr_clusters');

symbol_strings = char(symbols);
all_x_vectors = [];
all_y_vectors = [];


%% Compute code vectors and store them
for s=1:size(symbol_strings, 1)
    symbol_name = symbol_strings(s, :);
    [x_vectors, y_vectors] = ...
        symbol_vq_vectors(symbol_name, resample_interval, ...
                       hamming_window_size, hamming_window_step);
    
    all_x_vectors = [all_x_vectors; x_vectors];
    all_y_vectors = [all_y_vectors; y_vectors];
    
    fprintf('Retrieved quantization feature vectors for symbol: %s\n', strtrim(symbol_name));
end

disp 'Computing codebooks ...';

% use LBG kmeans to compute codebook vectors
[x_codebook, esq, J_x] = kmeanlbg(all_x_vectors, nr_clusters);
[y_codebook, esq, J_y] = kmeanlbg(all_y_vectors, nr_clusters);

codebook_filename = 'symbol_feature_codebook.mat';
save(codebook_filename, 'x_codebook', 'y_codebook');
fprintf('Created codebook for all symbols.\n');