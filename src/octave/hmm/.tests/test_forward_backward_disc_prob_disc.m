% test for the computation of the probability of the observed sequences
% given the HMM
% not to be executed directly
%
% Authors: Alexandru Sorici, Tudor Berariu / August 2012

Prob_Correct = 1;
max_error = 1e-10;

for i=1:10
    %% Build random HMM
    N = randi(20,1,1); % Number of states
    M = randi(10,1,1); % Size of symbol set
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
    T = randi(30,1,1);
    O = randi(M,1,T);

    %% Initialize Alpha, Beta, Scale
    Scale = zeros (1, T); % Scale is an 1 x T matrix
    Alpha = zeros (T, N); % Alpha is a T x N matrix
    Beta = ones (T, N); % Beta is a T x N matrix
    P = 0;
    P_ = 0;

    %% Compute Alpha and Scale
    Alpha(1,:) = Pi .* B(:, O(1))';
    Scale(1) = 1 / sum(Alpha(1, :));
    Alpha(1,:) = Alpha(1, :) * Scale(1);

    for t = 2:T
        Alpha(t,:) = (Alpha(t-1,:) * A) .* B(:, O(t))';
        Scale(t) = 1 / sum(Alpha(t, :));
        Alpha(t, :) = Alpha(t, :) * Scale(t);
    end

    %% Compute Probability

    try
%%%--REPLACE-THIS--%%%
    catch
        fprintf('%s\n',lasterror.message);
        Correct = 0;
	return;
    end

    %% Compute correct Probability
    % Do not optimize, use definition. (Tudor)

    P_ =  1/prod(Scale);

    %% Check results
    if Prob_Correct == 1
	[Prob_Correct, Prob_Message] = ...
	    matrices_are_equal(P_, P, max_error);
        if Prob_Correct == 0
            break;
        end
    end
end

if Prob_Correct == 1
    fprintf('Probability correct\n');
else
    fprintf('Probability incorrect: %s\n',Prob_Message);
end

Correct = Prob_Correct;
