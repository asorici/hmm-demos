function [symbol_rec_threshold] = symbol_validate_hmm(symbol_name, ...
                          x_codebook, y_codebook, ...
                          resample_interval, ...
                          hamming_window_size, hamming_window_step, ...
                          Pi, A, B)
%%  Validates the HMM model for the specified symbol
%   The function assumes the existance of two files:
%       - <symbol>_train.mat contains the raw mouse track sequences
%       
%   Inputs: 
%       symbol - a string denoting the symbol name to train the
%                HMM parameters for
%       x_codebook - the codebook feature vectors for the x signal
%       y_codebook - the codebook feature vectors for the y signal
%       resample_interval - this argument defines the resampling 
%                           time interval to be used on the 
%                           raw track sequences
%       hamming_window_size - window size in seconds for the FFT window
%       hamming_window_step - size in seconds of the FFT window shift 
%                             parameter 
%       Pi, A, B - the HMM parameters for the current symbol model
%
%   Outputs:
%       symbol_rec_threshold - the threshold log likelihood value for
%                              detection of the current symbol

validation_track_filename = strcat(symbol_name, '_validate.mat');

if (~exist(validation_track_filename, 'file'))
    error('symbol_validate_hmm:config', ... 
          'The file %s is not on the MATLAB path.', ...
          validation_track_filename);
end

load(validation_track_filename, 'raw_track_values');
len_vl = size(raw_track_values, 2);
validating_track_values = raw_track_values;

sumlik = 0;
minlik = Inf;

% first compute recognition threshold
for j = 1 : len_vl
    track_data = validating_track_values{j};
    O = symbol_get_feature_sequence(track_data, ...
            x_codebook, y_codebook, ...
            resample_interval, ...
            hamming_window_size, hamming_window_step);

    [Prob, ~, ~, ~] = forward_backward_multi_disc(O, Pi, A, B);

    lik = Prob;
    if lik < minlik
        minlik = lik;
    end
    sumlik = sumlik + lik;

    fprintf('%s likelihood: %0.5f\n', symbol_name, lik);
end

symbol_rec_threshold = 2.0 * sumlik / len_vl;
fprintf('*************************************************\n');
fprintf('Validation performed for symbol %s.\nDetection log likelihood threshold set at: %f\n', ... 
         strtrim(symbol_name), symbol_rec_threshold);
fprintf('*************************************************\n\n');

end

