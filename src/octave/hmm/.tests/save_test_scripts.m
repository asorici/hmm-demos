% script that saves the info about the test files
% it saves a variable tests with a field for each test in a file named
% 'test_scripts.mat'
%
% Authors: Alexandru Sorici, Tudor Berariu / August 2012
tests = struct( ...
    'alpha_disc', struct( ...
        'path', 'hmm/', 'file', 'forward_backward_disc', ...
        'description', 'forward variables for the discrete case'), ...
    'beta_disc', struct( ...
        'path', 'hmm/', 'file', 'forward_backward_disc', ...
        'description', 'backward variables for the discrete case'), ...
    'prob_disc', struct( ...
        'path', 'hmm/', 'file', 'forward_backward_disc', ...
        'description', 'probability of the observation sequence') ...
    );

save('hmm/.tests/test_scripts.mat','tests','-v6');
