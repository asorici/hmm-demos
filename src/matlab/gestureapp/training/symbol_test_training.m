function symbol_test_training()

symbols = {'left_arrow' 'right_arrow' 'circle' 'square'};
symbol_strings = char(symbols);


% ---------------------------- training ---------------------------
disp '--------- Training HMM models ---------'
hmms = cell(4,3);
for s=1:size(symbol_strings, 1)
    symbol_name = symbol_strings(s, :);
    
    % we try training with a bakis model
    [Pi, A, B] = symbol_train_hmm(symbol_name, 'bakis');
    
    hmms{s, 1} = Pi;
    hmms{s, 2} = A;
    hmms{s, 3} = B;
end

disp '--------- Training Phase Over - HMM parameters learned ---------'
disp '--------- Test results --------'

% ---------------------------- testing ----------------------------

for s=1:size(symbol_strings, 1)
    symbol_name = symbol_strings(s, :);
    raw_track_filename = strcat(symbol_name, '.mat');
    codebook_filename = strcat(symbol_name, '_codebook.mat');
    hmm_data_filename = strcat(symbol_name, '_hmm.mat');
    
    load(raw_track_filename, 'raw_track_values');
    load(codebook_filename, 'x_codebook', 'y_codebook');
    
    len_tot = size(raw_track_values, 2);
    len_td = floor(3 * len_tot / 4);
    len_test = len_tot - len_td;

    training_track_values = raw_track_values(1:len_td);
    testing_track_values = raw_track_values((len_td + 1):len_tot);

    sumlik = 0;
    minlik = Inf;

    Pi = hmms{s, 1};
    A = hmms{s, 2};
    B = hmms{s, 3};

    % first compute recognition threshold
    for j = 1 : len_td
        track_data = training_track_values{j};
        O = symbol_get_feature_sequence(track_data, ...
                x_codebook, y_codebook, 0.02, 0.16, 0.08);
        
        [Prob, Alpha, Beta, Scale] = forward_backward(O, Pi, A, B);
        
        %{
        lik = 0;
        for i = 1 : N
            lik = lik + alfa(end, i);
        end
        %}
        lik = log(Prob);

        if lik < minlik
            minlik = lik;
        end
        sumlik = sumlik + lik;
    end
    
    symbol_rec_threshold = 2.0 * sumlik / len_td;
    
    % SAVE HMM DATA FOR USE IN RECOGNITION
    save(hmm_data_filename, 'Pi', 'A', 'B', 'symbol_rec_threshold');
    
    
    fprintf('*************************************************\n');
    fprintf('Testing %i sequences of symbol %s for a log likelihood greater than %f\n', ... 
             len_test, strtrim(symbol_name), ...,
             symbol_rec_threshold);
    fprintf('*************************************************\n\n');
    
    % then perform accuracy measurements on hold out test data
    recs = 0;
    tLL = zeros(len_test, 1);
    for j = 1 : len_test
        track_data = testing_track_values{j};
        O = symbol_get_feature_sequence(track_data, ...
                x_codebook, y_codebook, 0.02, 0.16, 0.08);
        [Prob, Alpha, Beta, Scale] = forward_backward(O, Pi, A, B);
        
        tLL(j,1) = log(Prob);
        if tLL(j,1) >= symbol_rec_threshold
            recs = recs + 1;
            fprintf('Log likelihood: %f >= %f (threshold) -- FOUND %s GESTURE!\n', ...,
                lik, symbol_rec_threshold, strtrim(symbol_name));
        else
            fprintf('Log likelihood: %f < %f (threshold) -- NO %s GESTURE.\n',..., 
                lik, symbol_rec_threshold, strtrim(symbol_name));
        end
    end

    fprintf('Recognition success rate: %f percent\n',100*recs/len_test);
    fprintf('\n');
end
