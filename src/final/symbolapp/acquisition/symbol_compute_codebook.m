function [symbol_codebook_filename] = symbol_compute_codebook(symbols)
%% Define parameters for quantization and FFT feature extraction
symbol_config_filename = 'symbol_config.mat';

% check for the existance of symbol_config.mat
if (~exist(symbol_config_filename, 'file'))
    error('symbol_compute_codebook:config', ... 
          'The file symbol_config.mat is not on the MATLAB path.');
end

% load variable meta-data from symbol_config.mat
vars = whos('-file', symbol_config_filename);

% default feature extraction parameter values
resample_interval = 0.02;
hamming_window_size = 0.16;
hamming_window_step = 0.08;
nr_clusters = 256;

% override from config file if available
if (ismember('feature_extraction_parameters', {vars.name}))
    load(symbol_config_filename, 'feature_extraction_parameters');
    
    resample_interval = feature_extraction_parameters.resample_interval;
    hamming_window_size = feature_extraction_parameters.hamming_window_size;
    hamming_window_step = feature_extraction_parameters.hamming_window_step;
    nr_clusters = feature_extraction_parameters.nr_clusters;
end

%% Compute code vectors and store them
all_x_vectors = [];
all_y_vectors = [];

symbol_strings = char(symbols);

for s=1:size(symbol_strings, 1)
    symbol_name = symbol_strings(s, :);
    [x_vectors, y_vectors] = ...
        symbol_vq_vectors(symbol_name, resample_interval, ...
                       hamming_window_size, hamming_window_step);
    
    all_x_vectors = [all_x_vectors; x_vectors];
    all_y_vectors = [all_y_vectors; y_vectors];
    
    fprintf('Retrieved quantization feature vectors for symbol: %s\n', strtrim(symbol_name));
end

% check if we have enough data for the given number of clusters
if size(all_x_vectors, 1) < nr_clusters
    error('symbol_compute_codebook:nr_clusters', ... 
          'The expected number of clustered observation values (%i)\n exceeds the number of collected feature vectors (%i)', ...
          nr_clusters, size(all_x_vectors, 1));
end

disp 'Computing codebook ...';
% use LBG kmeans to compute codebook vectors
[x_codebook, esq, J_x] = kmeanlbg(all_x_vectors, nr_clusters);
[y_codebook, esq, J_y] = kmeanlbg(all_y_vectors, nr_clusters);

%suffix = randi2(10000, 1, 1);
%filename = sprintf('symbol_feature_codebook_%i.mat', suffix);
filename = 'symbol_feature_codebook.mat';

symbol_app_name = 'symbolapp';
symbol_app_folder = 'acquisition';

symbol_codebook_filename = ...
    strcat(symbol_app_name, filesep, ...
            symbol_app_folder, filesep, ...
            filename);

save(symbol_codebook_filename, 'x_codebook', 'y_codebook');
fprintf('Created codebook for all symbols in file %s.\n', symbol_codebook_filename);