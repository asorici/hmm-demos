function hmm_test(label, code_file)
% executes specific tests for the hmm octave library
%
% usage : hmm_test()
%         hmm_test(label)
%         hmm_test(label, code_file)
%
% HMM_TEST executes the test identified by LABEL for the lines of code extracted
% from CODE_FILE. It is a wrapper over the more general TEST_CODE from the same
% folder. It is intended to be used in the form HMM_TEST(LABEL) if all files are
% in the right place.
%
% Input args:
% label :           key used to identify the test (and also the code region)
% code_file:        string containing the path to the file containing the code
%                   to be tested
%
% Authors: Alexandru Sorici, Tudor Berariu / August 2012

%% Load tests information
load('hmm/.tests/test_scripts.mat','tests');

%% Check label
if nargin() < 1
    fprintf('Please choose a test to run!\n');
    fprintf('Type \"list\" to list all available tests.\n');
    fprintf('Type \"quit\" to exit this tester.\n');
    label = input('Test: ','s');
end

while ~isfield(tests, label)
    if strcmpi(label,'quit')
	return;
    elseif strcmpi(label,'list')
        labels = fieldnames(tests);
	labels_count = size(labels,1);
        for i = 1:labels_count
	    crt_label = labels{i};
	    fprintf('%s  -  %s\n',crt_label,tests.(crt_label).description);
	end
    else
        fprintf('ERROR: Test \"%s\" not found!\n', label);
        fprintf('Please choose a test to run!\n');
        fprintf('Type \"list\" to list all available tests.\n');
        fprintf('Type \"quit\" to exit this tester.\n');
    end
    label = input('Test: ','s');
    label = tolower(label);
end

%% Check if test file exists
default_file = strcat(tests.(label).path, tests.(label).file,'.m');
test_file = strcat(tests.(label).path, '.tests/test_', tests.(label).file, ...
            '_', label, '.m');

if ~exist(test_file,'file')
    error('Could not find test file. Please check current directory.\n');
end

%% Check code file
if nargin() < 2
    fprintf('Choose file to test code from!\n');
    fprintf('Press RET for %s\n', default_file);
    code_file = input('File: ', 's');
end

alt_code_file = strcat(tests.(label).path, code_file);

while size(code_file,2) == 0 || ...
        ~(exist(code_file,'file') || exist(alt_code_file, 'file'))
    if strcmpi(code_file, 'quit')
        return;
    elseif size(code_file,2) == 0
        code_file = default_file;
        alt_code_file = default_file;
    else
        fprintf('ERROR: file %s not found!\n', code_file);
        fprintf('Choose file to test code from!\n');
        fprintf('Press RET for %s\n', default_file);
        code_file = input('File: ', 's');
        alt_code_file = strcat(tests.(label).path, code_file);
    end
end

if ~exist(code_file, 'file')
    code_file = alt_code_file;
end

%% Execute test
fprintf('\nRunning test...\n');
correct = test_code(code_file, test_file, label);
if correct == 1
    fprintf('Test completed OK!\n');
else
    fprintf('Test failed!\n');
end
