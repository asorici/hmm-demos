% script that saves the info about the test files
% it saves a variable tests with a field for each test in a file named
% 'test_scripts.mat'
%
% Authors: Alexandru Sorici, Tudor Berariu / August 2012
tests = struct( ...
    'alpha_disc', struct( ...
        'path', 'hmm/', 'file', 'forward_backward_disc', ...
        'description', 'forward variables for the discrete case', ...
        'ttype', 'lines'), ...
    'beta_disc', struct( ...
        'path', 'hmm/', 'file', 'forward_backward_disc', ...
        'description', 'backward variables for the discrete case', ...
        'ttype', 'lines'), ...
    'prob_disc', struct( ...
        'path', 'hmm/', 'file', 'forward_backward_disc', ...
        'description', 'probability of the observation sequence', ...
        'ttype', 'lines'), ...
    'phi_psi_disc', struct( ...
        'path', 'hmm/', 'file', 'viterbi_disc', ...
        'description', 'phi and psi matrices from viterbi', ...
        'ttype', 'lines'), ...
    'path_disc', struct( ...
        'path', 'hmm/', 'file', 'viterbi_disc', ...
        'description', 'best explaining path (viterbi)', ...
        'ttype', 'lines'), ...
    'maximization_disc', struct( ...
        'path', 'hmm/', 'file', 'baum_welch_disc', ...
        'description', 'reestimation (A,B matrices) in baum_welch', ...
        'ttype', 'lines'), ...
    'precomp_b_disc', struct( ...
        'path', 'hmm/', 'file', 'baum_welch_multi_disc', ...
        'description', 'precompute the B matrix for the multidim case', ...
        'ttype', 'lines'), ...
    'symbolrec', struct( ...
        'path', 'hmm/', 'file', 'todo', ...
        'description', 'get a sequence and do something', ...
        'ttype', 'function') ...
    );

save('tester/test_scripts.mat','tests','-v6');
