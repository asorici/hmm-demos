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
    
    [T, E, pi] = hmm_baum_welch(OL, 6, 256, 2, 0.001, 50);
    hmms{s, 1} = T;
    hmms{s, 2} = E;
    hmms{s, 3} = pi;
end
