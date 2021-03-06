function symbol_performance_test(hmm_model, symbols, ...
            symbol_codebook_filename)
%% Performance tests for the trained symbol recognition HMM models

%% Initialization 

% read in the symbols, FFT feature extraction parameters and
% codebook vectors from the configuration files
symbol_config_filename = 'symbol_config.mat';

% check for the existance of symbol_config.mat
if (~exist(symbol_config_filename, 'file'))
    error('symbol_recognize:config', ... 
          'The file symbol_config.mat is not on the MATLAB path.');
end

% check for the existance of symbol_feature_codebook.mat
if (~exist(symbol_codebook_filename, 'file'))
    error('symbol_recognize:config', ... 
          'The file symbol_feature_codebook.mat is not on the MATLAB path.');
end

% load symbols and feature_extraction_parameters
load(symbol_config_filename, 'feature_extraction_parameters');
symbol_strings = char(symbols);
resample_interval = feature_extraction_parameters.resample_interval;
hamming_window_size = feature_extraction_parameters.hamming_window_size;
hamming_window_step = feature_extraction_parameters.hamming_window_step;

% load codebook feature vectors
load(symbol_codebook_filename, 'x_codebook', 'y_codebook');

%% Initialization of performance parameters
num_symbols = length(symbols);

% the performance parameters are like follows
% 1 - tp, 2 - fp, 3 - tn, 4 - fn
perf_param = zeros(num_symbols, 4);
num_sequences = zeros(1, num_symbols);

% build confusion matrix: +1 for the unknown category
confusion_matrix = zeros(num_symbols + 1, num_symbols + 1); 

% use the trained bakis model for tests
%hmm_model = 'bakis';
%hmm_model = 'ergodic';

%% Testing
disp '========= Testing trained HMM models ========'
for s = 1 : num_symbols
    symbol_name = symbol_strings(s, :);
    test_file = strcat(symbol_name, '_test.mat');
    load(test_file, 'raw_track_values');
    num_sequences(1, s) = size(raw_track_values, 2);
    
    for i = 1 : num_sequences(1, s)
        % classify sequence going over each symbol HMM
        
        ll = zeros(1, num_symbols);
        most_likely_symbol_idx = 1;
        max_ll = -Inf;
        
        for ts = 1 : num_symbols
            test_symbol = symbol_strings(ts, :);
            hmm_data_filename = ...
                strcat(test_symbol, '_hmm_', hmm_model, '.mat');
            
            load(hmm_data_filename, 'Pi', 'A', 'B');
            O = symbol_get_feature_sequence(raw_track_values{i}, ...
                x_codebook, y_codebook, ...
                resample_interval, ...
                hamming_window_size, hamming_window_step);
            
            [Prob, ~, ~, ~] = forward_backward(O, Pi, A, B);
            ll(1, ts) = Prob;
        
            if ll(1, ts) > max_ll
                max_ll = ll(1, ts);
                most_likely_symbol_idx = ts;
            end
        end
        
        candidate_symbol_name = ...
            symbol_strings(most_likely_symbol_idx, :);
        hmm_data_filename = strcat(candidate_symbol_name, '_hmm_', ...
                              hmm_model, '.mat');
        load(hmm_data_filename, 'symbol_rec_threshold');
        
        if max_ll >= symbol_rec_threshold
            % if the symbol was recognized
            
            if most_likely_symbol_idx == s
                perf_param(s, 1) = perf_param(s, 1) + 1;
            else
                % update fn for the current symbol
                perf_param(s, 4) = perf_param(s, 4) + 1;
                
                % update fp for the supposed most likely symbol
                perf_param(most_likely_symbol_idx, 2) = ...
                    perf_param(most_likely_symbol_idx, 2) + 1;
            end
            
            % update confusion matrix
            confusion_matrix(s, most_likely_symbol_idx) = ...
                confusion_matrix(s, most_likely_symbol_idx) + 1;
        else
            % update fn for the current symbol
            perf_param(s, 4) = perf_param(s, 4) + 1;
            
            % update confusion matrix by marking as unknown
            confusion_matrix(s,end) = confusion_matrix(s,end) + 1;
        end
    end
end

%% Display results
for s = 1 : num_symbols
    symbol_name = symbol_strings(s, :);
    fprintf('## Results for the model of symbol "%s":\n', strtrim(symbol_name));
    
    accuracy = (perf_param(s, 1) + perf_param(s, 3)) / ...
        (perf_param(s, 1) + perf_param(s, 3) + ...
         perf_param(s, 2) + perf_param(s, 4));
    
    fprintf('\tAccuracy: %0.5f\n', accuracy);
    
    precision = perf_param(s, 1) / ...
                (perf_param(s, 1) + perf_param(s, 2));
    fprintf('\tPrecision: %0.5f\n', precision);
    
    recall = perf_param(s, 1) / ...
                (perf_param(s, 1) + perf_param(s, 4));
    fprintf('\tRecall: %0.5f\n', recall);
    
    fprintf('\tConfusion matrix line: ');
    disp(confusion_matrix(s, :));
    fprintf('\n');
end