function [answer, message] = matrices_are_equal(A, B, error)
% test if two matrices are equal
%
% usage : [answer, message] = matrices_are_equal(A, B, error)
%
% MATRICES_ARE_EQUAL tests if matrix A has the same size and the same values
% as matrix B. The relative error allowed is given in the third argument.
%
% Authors: Alexandru Sorici, Tudor Berariu / August 2012

if nargin < 2
    fprintf('usage: [answer, message] = matrices_are_equal(A, B)\n');
    fprintf('usage: [answer, message] = matrices_are_equal(A, B, error)\n');
    error('Incorrect number of arguments');
end

if nargin < 3
    error = 1e-10;
end

if ~all(size(size(A)) == size(size(B)))
    % different number of dimensions
    answer = 0;
    message = 'different number of dimensions';
elseif ~all(size(A) == size(B))
    % different size
    answer = 0;
    message = 'different size';
else
    D = abs(A - B) ./ abs(A + error);
    if ~all((D(:) < error))
        % incorrect values
        answer = 0;
        message = 'incorrect values';
    else
        answer = 1;
        message = 'ok';
    end
end

end