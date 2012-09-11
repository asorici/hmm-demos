symbols = {'left_arrow' 'right_arrow' 'circle' 'square' 'infinity'};
purposes = {'train' 'validate' 'test'};

symbol_strings = char(symbols);
purpose_strings = char(purposes);

for s=1:size(symbol_strings, 1)
    symbol_name = symbol_strings(s, :);
    
    for p = 1:size(purpose_strings, 1)
        purpose_name = purpose_strings(p, :);
        
        symbol_filename = strcat(symbol_name, '_', purpose_name, '.mat');
        load(symbol_filename, 'raw_track_values');
        
        nr_tracks = size(raw_track_values, 2);
        for t = 1 : nr_tracks
            raw_track_values{t}(:, 3) = ...
                raw_track_values{t}(:, 3) - raw_track_values{t}(1, 3);
        end
        
        save(symbol_filename, 'raw_track_values');
    end
end