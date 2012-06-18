function test_training()

symbols = {'left_arrow' 'right_arrow' 'circle' 'square'};
symbol_strings = char(symbols);

hmms = cell(4,3);

for s=1:size(symbol_strings, 1)
    symbol_name = symbol_strings(s, :);
    filename = strcat(symbol_name, '.mat');
    load(filename, 'raw_track_values');
    
    % 3/4 training data
    len_td = floor(3 * size(raw_track_values, 2) / 4);
    training_track_values = raw_track_values(1:len_td);
    
    OL = cell(1, len_td);
    for p = 1 : len_td
        track_data = training_track_values{p};
        [~, ~, idx, idy] = symbol_preprocess(track_data);
        OL{1, p} = [idx idy];
    end
    
    [T, E, pi] = hmm_baum_welch(OL, 6, 256, 2, 0.00001, 50);
    hmms{s, 1} = T;
    hmms{s, 2} = E;
    hmms{s, 3} = pi;
end

% ---------------------------- testing ----------------------------
s = 2;
symbol_name = symbol_strings(s, :);
filename = strcat(symbol_name, '.mat');
load(filename, 'raw_track_values');

len_td = floor(3 * size(raw_track_values, 2) / 4);
len_tot = size(raw_track_values, 2);
len_test = len_tot - len_td;

training_track_values = raw_track_values(1:len_td);
testing_track_values = raw_track_values(len_td + 1 : len_tot);
sumlik = 0;
minlik = Inf;
T = hmms{s,1};
E = hmms{s,2};
pi = hmms{s,3};
N = size(T, 1);

for j = 1 : len_td
    track_data = training_track_values{j};
    [~, ~, idx, idy] = symbol_preprocess(track_data);
    [alfa, ~, ~] = hmm_forward_backward([idx idy], T, E, pi);
    alfa(end, :)
    lik = 0;
    for i = 1 : N
        lik = lik + alfa(end, i);
    end
    lik = log(lik);
    
    if lik < minlik
        minlik = lik;
    end
    sumlik = sumlik + lik;
end

gesture_rec_threshold = 2.0 * sumlik / len_td;

fprintf('\n\n********************************************************************\n');
fprintf('Testing %i sequences for a log likelihood greater than %f\n',len_test, gesture_rec_threshold);
fprintf('********************************************************************\n\n');

recs = 0;
tLL = zeros(len_test, 1);
for j = 1 : len_test
    track_data = testing_track_values{j};
    [~, ~, idx, idy] = symbol_preprocess(track_data);
    [alfa, ~, ~] = hmm_forward_backward([idx idy], T, E, pi);
    lik = 0;
    for i = 1 : N
        lik = lik + alfa(end, i);
    end
    lik = log(lik);
    
    tLL(j,1) = lik;
    if lik >= gesture_rec_threshold
        recs = recs + 1;
        fprintf('Log likelihood: %f > %f (threshold) -- FOUND %s GESTURE!\n',lik, gesture_rec_threshold, symbol_name);
    else
        fprintf('Log likelihood: %f < %f (threshold) -- NO %s GESTURE.\n',lik, gesture_rec_threshold, symbol_name);
    end
end

fprintf('Recognition success rate: %f percent\n',100*recs/len_test);