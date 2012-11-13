function [correct] = test_code(user_file_name, test_file_name, label)
% tests lines of code written by the user with a given tester
%
% usage: [correct] = test_code(user_file_name, test_file_name, label)
%
% TEST_CODE creates an .m file by extracting lines of code from the file
% USER_FILE_NAME and inserting them in the file TEST_FILE_NAME.
% USER_FILE_NAME must contain a section delimited by the following markers:
% LABEL-start and LABEL-end. All lines between the two are being used to replace
% the "REPLACE-THIS" line in TEST_FILE_NAME. The resulted code is executed and
% the result is returned in the output variable CORRECT. In case of any error
% TEST_CODE returns false.
%
% Input args:
% user_file_name :  string containing the path to the file containing the code
%                   to be tested
% test_file_name :  string containing the path to the tester
% label :           marker used to identify the code region
%
% Output args:
% correct :  boolean value
%
% Authors: Alexandru Sorici, Tudor Berariu / August 2012

%% Check arguments
if nargin < 3
    u = 'usage: [correct] = test_code(user_file_name, test_file_name, label)\n';
    error(u);
end

%% New function name

function_name = sprintf('test%d',randi2(10000,1,1));
function_file_name = sprintf('%s.m',function_name);

%% Labels to identify the lines of code in user's file
start_label = sprintf('%s-start',label);
end_label = sprintf('%s-end',label);

%% Open files

user_file = fopen(user_file_name,'r');
test_file = fopen(test_file_name,'r');

if user_file < 0
    error('Could not open %s. \n',user_file_name);
end
%C_user = onCleanup(@()fclose(user_file));

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

to_replace = 1;
labels_found = 0;

test_line = fgets(test_file);
while ischar(test_line)
    if (to_replace == 1) && ...
           ~isempty(strfind(test_line, '%%%--REPLACE-THIS--%%%'))
        to_replace = 0;
        user_line = fgets(user_file);
        while ischar(user_line)
            if strfind(user_line, start_label)
                break;
            end
            user_line = fgets(user_file);
        end
        while ischar(user_line)
            if strfind(user_line, end_label)
                labels_found = 1;
                break;
            end
            fprintf(function_file,'%s',user_line);
            user_line = fgets(user_file);
        end
    else
        fprintf(function_file,'%s',test_line);
    end
    test_line = fgets(test_file);
end

fclose(function_file);
fclose(user_file);
fclose(test_file);

if to_replace == 1
    error('Test file has no REPLACE-THIS section.\n')
end

if labels_found == 0
    error('Labels missing from user file.\n')
end

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
delete(function_file_name);

end
