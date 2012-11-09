
symbols = {'left_arrow_zero', 'right_arrow_zero', ...
	   'circle_zero', 'square_zero', 'infinity_zero'};
symbol_codebook_filename = 'symbol_feature_codebook_zero.mat';
model = 'ergodic';
symbol_config_filename = 'symbol_config_zero.mat';

RS_Correct = 1;
LL_Correct = 1;
max_error = 1e-10;

for i=1:5
    
    filename = strcat(symbols{i}, '_test.mat');
    load(filename, 'raw_track_values');
    track_data = raw_track_values{1};
    
    try
        [recognized_symbol, ll_vector] = symbol_recognize( ...
            symbols, track_data, model, symbol_codebook_filename, ...
            symbol_config_filename);
    catch lasterror
        fprintf('%s\n',lasterror.message);
        Correct = 0;
	return;
    end

    %% Compute correct values
    
    [recognized_symbol_, ll_vector_] = symbol_distort( ...
        symbols, track_data, model, symbol_codebook_filename, ...
        symbol_config_filename);
    
    %% Check results
    if RS_Correct == 1
        RS_Correct = strcmpi(recognized_symbol, recognized_symbol_);
        if RS_Correct == 0
            RS_Message = 'Wrong symbol';
        end
    end
    if LL_Correct == 1
	[LL_Correct, LL_Message] = ...
	    matrices_are_equal(ll_vector_, ll_vector, max_error);
    end
    if RS_Correct == 0 && LL_Correct == 0
        break;
    end
end

if RS_Correct == 1
    fprintf('Recognized symbol correct\n');
else
    fprintf('Recognized symbol incorrect: %s\n',RS_Message);
end
if LL_Correct == 1
    fprintf('Log likelihood values correct\n');
else
    fprintf('Log likelihood values incorrect: %s\n',Scale_Message);
end

Correct = RS_Correct * LL_Correct;

   
  	      