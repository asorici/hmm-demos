function symbol_compute_codebook()
%% Define parameters for quantization and FFT feature extraction

% check for the existance of symbol_config.mat
if (~exist('symbol_config.mat', 'file'))
    error('symbol_compute_codebook:config', ... 
          'The file symbol_config.mat is not on the MATLAB path.');
end

% load variable meta-data from symbol_config.mat
vars = whos('-file', 'symbol_config.mat');

% check the existence of symbols in symbol_config.mat
if (~ismember('symbols', {vars.name}))
    error('symbol_compute_codebook:symbols', ... 
          'No "symbols" variable found in symbol_config.mat. Nothing to compute.');
end

% load symbols from symbol_config.mat
load('symbol_config.mat', '-mat', 'symbols');

% default feature extraction parameter values
resample_interval = 0.02;
hamming_window_size = 0.16;
hamming_window_step = 0.08;
nr_clusters = 256;

% override from config file if available
if (ismember('feature_extraction_parameters', {vars.name}))
    resample_interval = feature_extraction_parameters.resample_interval;
    hamming_window_size = feature_extraction_parameters.hamming_window_size;
    hamming_window_step = feature_extraction_parameters.hamming_window_step;
    nr_clusters = feature_extraction_parameters.nr_clusters;
end

% store the FFT feature extraction parameters in a file
%feature_param_file = 'feature_extraction_parameters.mat';
%save(feature_param_file, 'resample_interval', ...
%                         'hamming_window_size', ...
%                         'hamming_window_step', ...
%                         'nr_clusters');

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

disp 'Computing codebook ...';

% use LBG kmeans to compute codebook vectors
[x_codebook, esq, J_x] = kmeanlbg(all_x_vectors, nr_clusters);
[y_codebook, esq, J_y] = kmeanlbg(all_y_vectors, nr_clusters);

codebook_filename = 'symbol_feature_codebook.mat';
save(codebook_filename, 'x_codebook', 'y_codebook');
fprintf('Created codebook for all symbols.\n');