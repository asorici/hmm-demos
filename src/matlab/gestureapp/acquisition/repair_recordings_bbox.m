function repair_recordings_bbox()
symbols = {'left_arrow' 'right_arrow' 'circle' 'square'};
symbol_strings = char(symbols);

for s=1:size(symbol_strings, 1)
    symbol_name = symbol_strings(s, :);
    symbol_track_file = strcat(symbol_name, '.mat');
    
    load(symbol_track_file, 'raw_track_values');
    len_total = size(raw_track_values, 2);
    
    for i = 1:len_total
        raw_track_values{i} = bbox_resize(raw_track_values{i});
    end
    
    save(symbol_track_file, 'raw_track_values');
end

function [track_data] = bbox_resize(track_data)
len_seq = size(track_data, 1);
    
% determine bounding box of symbol sequence
x_min = min(track_data(:, 1));
x_max = max(track_data(:, 1));

y_min = min(track_data(:, 2));
y_max = max(track_data(:, 2));

% and resize sequence to bounding box
track_data(:, 1) = ...
    (track_data(:, 1) - ones(len_seq, 1) * x_min) ./ (x_max - x_min);

track_data(:, 2) = ...
    (track_data(:, 2) - ones(len_seq, 1) * y_min) ./ (y_max - y_min);