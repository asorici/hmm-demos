function resampled_track_data = resample_track_data(track_data, interval, fixed_length)

%track_data
end_time = track_data(end, 3);
t_vec = [0:interval:end_time];

x_vec = interp1(track_data(:,3), track_data(:,1), t_vec);
y_vec = interp1(track_data(:,3), track_data(:,2), t_vec);

resampled_track_data = [x_vec' y_vec' t_vec'];

if fixed_length > 0
    if size(t_vec, 2) > fixed_length
        resampled_track_data = resampled_track_data(1:fixed_length, :);
    else
        if size(t_vec, 2) < fixed_length
            gap = fixed_length - size(t_vec, 2);
            start_t = t_vec(1, end);
            
            gap_t_vec = zeros(1, gap);
            for i = 1:gap
                gap_t_vec(i) = start_t + i * interval;
            end
            
            gap_point_vec = repmat(resampled_track_data(end, 1:2), gap, 1);
            resampled_track_data = [resampled_track_data; gap_point_vec gap_t_vec'];
        end
    end
end