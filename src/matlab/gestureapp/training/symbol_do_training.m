function symbol_do_training(model, symbols)
%% perform symbol recognition training for the hmm model type
%
%   Inputs:
%       model - a string giving the HMM transition model to be used
%               one of {'ergodic', 'bakis'}
%       symbols - a vector of strings naming the symbols for which
%                 a HMM model should be trained

%symbols = {'left_arrow' 'right_arrow' 'circle' 'square' 'infinity'};
symbol_strings = char(symbols);

% check existance of required files
symbol_config_filename = 'symbol_config.mat';
symbol_codebook_filename = 'symbol_feature_codebook.mat';

if (~exist(symbol_config_filename, 'file'))
    error('symbol_do_training:config', ... 
          'The file symbol_config.mat is not on the MATLAB path.');
end

if (~exist(symbol_codebook_filename, 'file'))
    error('symbol_do_training:config', ... 
          'The file symbol_feature_codebook.mat is not on the MATLAB path.');
end


% load variable meta-data from symbol_config.mat
vars = whos('-file', 'symbol_config.mat');

% check the existence of feature_extraction_parameters
% structure in symbol_config.mat
if (~ismember('feature_extraction_parameters', {vars.name}))
    error('symbol_compute_codebook:feature_extraction_parameters', ... 
        'No "feature_extraction_parameters" variable found in symbol_config.mat. Nothing to compute.');
end


% load FFT feature extraction parameters from config file
load(symbol_config_filename, 'feature_extraction_parameters');
resample_interval = feature_extraction_parameters.resample_interval;
hamming_window_size = feature_extraction_parameters.hamming_window_size;
hamming_window_step = feature_extraction_parameters.hamming_window_step;
                         
% load symbol codebook from file
load(symbol_codebook_filename, 'x_codebook', 'y_codebook');

%% ---------------------------- training ---------------------------
disp '--------- Training HMM models ---------'
hmms = cell(4,3);
for s=1:size(symbol_strings, 1)
    symbol_name = symbol_strings(s, :);
    
    fprintf('-------- Training for symbol %s --------\n', ...
        strtrim(symbol_name));
    [Pi, A, B] = symbol_train_hmm(symbol_name, model);
    
    hmms{s, 1} = Pi;
    hmms{s, 2} = A;
    hmms{s, 3} = B;
end

disp '--------- Training Phase Over - HMM parameters learned ---------'
disp '--------- Validation results --------'

%% ---------------------------- validating ----------------------------

for s=1:size(symbol_strings, 1)
    symbol_name = symbol_strings(s, :);
    raw_track_filename = strcat(symbol_name, '_validate.mat');
    hmm_data_filename = strcat(symbol_name, '_hmm_', model, '.mat');
    
    load(raw_track_filename, 'raw_track_values');
    len_vl = size(raw_track_values, 2);
    validating_track_values = raw_track_values;
    
    sumlik = 0;
    minlik = Inf;

    Pi = hmms{s, 1};
    A = hmms{s, 2};
    B = hmms{s, 3};

    % first compute recognition threshold
    for j = 1 : len_vl
        track_data = validating_track_values{j};
        O = symbol_get_feature_sequence(track_data, ...
                x_codebook, y_codebook, ...
                resample_interval, ...
                hamming_window_size, hamming_window_step);
        
        [Prob, Alpha, Beta, Scale] = forward_backward(O, Pi, A, B);
        
        lik = Prob;
        if lik < minlik
            minlik = lik;
        end
        sumlik = sumlik + lik;
        
        fprintf('%s likelihood: %0.5f\n', symbol_name, lik);
    end
    
    symbol_rec_threshold = 2.0 * sumlik / len_vl;
    
    % SAVE HMM DATA FOR USE IN RECOGNITION
    save(hmm_data_filename, 'Pi', 'A', 'B', 'symbol_rec_threshold');
    
    
    fprintf('*************************************************\n');
    fprintf('Validation performed for symbol %s. Detection log likelihood threshold set at: %f\n', ... 
             strtrim(symbol_name), ...,
             symbol_rec_threshold);
    fprintf('*************************************************\n\n');
    
    %{
    % then perform accuracy measurements on hold out test data
    recs = 0;
    tLL = zeros(len_test, 1);
    for j = 1 : len_test
        track_data = testing_track_values{j};
        O = symbol_get_feature_sequence(track_data, ...
                x_codebook, y_codebook, ...
                resample_interval, ...
                hamming_window_size, hamming_window_step);
        
        [Prob, Alpha, Beta, Scale] = forward_backward(O, Pi, A, B);
        
        %tLL(j,1) = log(Prob);
        tLL(j,1) = Prob;
        if tLL(j,1) >= symbol_rec_threshold
            recs = recs + 1;
            fprintf('Log likelihood: %f >= %f (threshold) -- FOUND %s GESTURE!\n', ...,
                tLL(j, 1), symbol_rec_threshold, strtrim(symbol_name));
        else
            fprintf('Log likelihood: %f < %f (threshold) -- NO %s GESTURE.\n',..., 
                tLL(j, 1), symbol_rec_threshold, strtrim(symbol_name));
        end
    end

    fprintf('Recognition success rate: %f percent\n',100*recs/len_test);
    fprintf('\n');
    %}
end
