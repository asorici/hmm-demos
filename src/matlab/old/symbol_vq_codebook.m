function symbol_vq_codebook(nr_clusters)

symbols = {'left_arrow' 'right_arrow' 'circle' 'square'};
symbol_strings = char(symbols);

codebook_filename = 'codebook.mat';
x_vectors = [];
y_vectors = [];

for s=1:size(symbol_strings, 1)
    symbol_name = symbol_strings(s, :);
    filename = strcat(symbol_name, '.mat');
    load(filename, 'raw_track_values');

    % 3/4 training data
    len_td = floor(3 * size(raw_track_values, 2) / 4);
    training_track_values = raw_track_values(1:len_td);

    window_size = 0.32;
    window_step = 0.16;
    resample_interval = 0.02;
    NFFT = floor(window_size / resample_interval);

    for i=1:len_td
        v1 = training_track_values{i}(1, 3);
        training_track_values{i}(:,3) = training_track_values{i}(:, 3) - v1;
        resampled_training_values = resample_track_data(training_track_values{i}, resample_interval, 0);
        %resampled_training_values = resample_track_data(training_track_values{i}, resample_interval, 2 * size(training_track_values{i}, 1));
        %resampled_training_values = resample_track_data(training_track_values{i}, resample_interval, 128);

        low_t = 0;
        high_t = window_size;
        end_t = resampled_training_values(end, 3);

        %disp(size(resampled_training_values));

        while high_t <= end_t
            % get values in window
            idx = find(resampled_training_values(:, 3) >= low_t & resampled_training_values(:, 3) < high_t);

            xvals = resampled_training_values(idx, 1);
            yvals = resampled_training_values(idx, 2);

            %disp(size(idx));

            %L = size(xvals, 1);
            %NFFT = 2^nextpow2(L);

            % compute fft in window
            xvals_fft = fft(xvals, NFFT) / NFFT;
            yvals_fft = fft(yvals, NFFT) / NFFT;

            x_vectors = [x_vectors; abs(xvals_fft)'];
            y_vectors = [y_vectors; abs(yvals_fft)'];

            % move window
            low_t = low_t + window_step;
            high_t = high_t + window_step;
        end

        %disp(size(x_vectors));
    end
end

% use LBG kmeans to compute codebook vectors
disp(size(x_vectors));

[x_codebook, esq, J_x] = kmeanlbg(x_vectors, nr_clusters);
[y_codebook, esq, J_y] = kmeanlbg(y_vectors, nr_clusters);

%x_codebook
%y_codebook

save(codebook_filename, 'x_codebook', 'y_codebook');