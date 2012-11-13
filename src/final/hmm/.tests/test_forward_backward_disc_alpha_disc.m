% test for the forward variables computation
% not to be executed directly
%
% Authors: Alexandru Sorici, Tudor Berariu / August 2012

Alpha_Correct = 1;
Scale_Correct = 1;
max_error = 1e-10;

for i=1:10
    %% Build random HMM
    N = randi2(20,1,1); % Number of states
    M = randi2(10,1,1); % Size of symbol set
    % Initial state probabilities
    Pi = rand(1, N);
    Pi = Pi / sum(Pi);
    % State transition probabilities
    A = rand(N, N);
    A = A .* repmat((1.0 ./ sum(A,2)), [1 N]);
    % Emission probabilities
    B = rand(N, M);
    B = B .* repmat((1.0 ./ sum(A,2)), [1 M]);

    %% Create random observed sequence
    T = randi2(30,1,1);
    O = randi2(M,1,T);

    %% Initialize Alpha, Beta, Scale
    Scale = zeros (1, T); % Scale is an 1 x T matrix
    Alpha = zeros (T, N); % Alpha is a T x N matrix
    Beta = ones (T, N); % Beta is a T x N matrix
    Scale_ = zeros (1, T);
    Alpha_ = zeros (T, N);
    Beta_ = ones (T, N);

    %% Compute Alpha

    
%%%--REPLACE-THIS--%%%
    

    %% Compute correct Alpha and Scale
    Alpha_(1,:) = Pi .* B(:, O(1))';
    Scale_(1) = 1 / sum(Alpha_(1, :));
    Alpha_(1,:) = Alpha_(1, :) * Scale_(1);

    for t = 2:T
        Alpha_(t,:) = (Alpha_(t-1,:) * A) .* B(:, O(t))';
        Scale_(t) = 1 / sum(Alpha_(t, :));
        Alpha_(t, :) = Alpha_(t, :) * Scale_(t);
    end

    %% Check results
    if Alpha_Correct == 1
	[Alpha_Correct, Alpha_Message] = ...
	    matrices_are_equal(Alpha_, Alpha, max_error);
    end
    if Scale_Correct == 1
	[Scale_Correct, Scale_Message] = ...
	    matrices_are_equal(Scale_, Scale, max_error);
    end
    if Alpha_Correct == 0 && Scale_Correct == 0
        break;
    end
end

if Alpha_Correct == 1
    fprintf('Alpha correct\n');
else
    fprintf('Alpha incorrect: %s\n',Alpha_Message);
end
if Scale_Correct == 1
    fprintf('Scale correct\n');
else
    fprintf('Scale incorrect: %s\n',Scale_Message);
end

Correct = Alpha_Correct * Scale_Correct;
