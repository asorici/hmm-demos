function symbol_performance_test(hmm_model)
%% Performance tests for the trained symbol recognition HMM models

% define the symbol names
symbols = {'left_arrow' 'right_arrow' 'circle' 'square' 'infinity'};
symbol_strings = char(symbols);

% load FFT feature extraction parameters from file
feature_param_file = 'feature_extraction_parameters.mat';
load(feature_param_file, 'resample_interval', ...
                         'hamming_window_size', ...
                         'hamming_window_step');

% load symbol codebook from file
codebook_filename = 'symbol_feature_codebook.mat';
load(codebook_filename, 'x_codebook', 'y_codebook');

%% Initialization of performance parameters
num_symbols = size(symbols, 2);

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