function [correct] = test_code(user_file_name, test_file_name, label)
% TEST_CODE creates an .m file combining the original test file and the
% lines of code written by the user and executes it.

%% New function name

function_name = sprintf('test%d',randi(10000,1,1));
function_file_name = sprintf('%s.m',function_name);

%% Labels to identify the lines of code in user's file
start_label = sprintf('%s-start',label);
end_label = sprintf('%s-end',label);

%%

user_file = fopen(user_file_name,'r');
test_file = fopen(test_file_name,'r');
if user_file < 0
    error('Could not open %s \n',user_file_name);
end

if test_file < 0
    error('Could not open %s \n',test_file_name);
end

function_file = fopen(function_file_name,'w');
if function_file < 0
    error('Could not open %s \n',function_file_name);
end


fprintf(function_file,'function [Correct] = %s()\n\n',function_name);

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
            fprintf(function_file,user_line);
            user_line = fgets(user_file);
        end
    else
        fprintf(function_file,test_line);
    end
    test_line = fgets(test_file);
end

fclose(user_file);
fclose(test_file);
fclose(function_file);

if to_replace == 1
    delete(function_file_name);
    error('Test file has no REPLACE-THIS section.\n')
end

if labels_found == 0
    delete(function_file_name);
    error('Labels missing from user file.\n')
end

%% Execute test function
test_function = str2func(function_name);
if ~exist(function_name,'file')
    delete(function_file_name);
    error('Could not find %s.\n',function_name);
end
correct = test_function();

%% Delete .m file
delete(function_file_name);