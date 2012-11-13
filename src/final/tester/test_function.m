function [correct] = test_function(test_file_name)
% tests function written by the user with a given tester
%
% usage: [correct] = test_function(test_file_name)
%
% TEST_FUNCTION creates an .m file from the file TEST_FILE_NAME.
% The resulted code is executed and
% the result is returned in the output variable CORRECT. In case of any error
% TEST_CODE returns false.
%
% Input args:
% test_file_name :  string containing the path to the tester
%
% Output args:
% correct :  boolean value
%
% Authors: Alexandru Sorici, Tudor Berariu / August 2012

%% Check arguments
if nargin < 1
    u = 'usage: [correct] = test_function(test_file_name)\n';
    error(u);
end

%% New function name

function_name = sprintf('test%d',randi2(10000,1,1));
function_file_name = sprintf('%s.m',function_name);

%% Open files

test_file = fopen(test_file_name,'r');

if test_file < 0
    error('Could not open %s. \n',test_file_name);
end
%C_test = onCleanup(@()fclose(test_file));

function_file = fopen(function_file_name,'w');
if function_file < 0
    error('Could not open %s. \n',function_file_name);
end
%C_temp = onCleanup(@()delete(function_file_name));


%% Write new file

fprintf(function_file,'function [Correct] = %s(x)\n\n',function_name);

test_line = fgets(test_file);
while ischar(test_line)
    fprintf(function_file,'%s',test_line);
    test_line = fgets(test_file);
end

fclose(function_file);
fclose(test_file);


%% Execute test function
test_function = str2func(function_name);
if ~exist(function_name,'file')
    error('Could not find %s.\n',function_name);
end

% The current folder should be already in path, but just in case...
%current_path = path();
%cleanup_path = onCleanup(@()path(current_path));
%addpath('.');

correct = test_function(1);
%delete(function_file_name);

end
