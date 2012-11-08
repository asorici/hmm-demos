% test for the computation of the Xi values given A,B,Pi,Alpha,Beta,Scale
% ! not to be executed directly
%
% Authors: Alexandru Sorici, Tudor Berariu / August 2012

logP_Correct = 1;
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

    %% Compute Alpha and Scale
    Alpha(1,:) = Pi .* B(:, O(1))';
    Scale(1) = 1 / sum(Alpha(1, :));
    Alpha(1,:) = Alpha(1, :) * Scale(1);

    for t = 2:T
        Alpha(t,:) = (Alpha(t-1,:) * A) .* B(:, O(t))';
        Scale(t) = 1 / sum(Alpha(t, :));
        Alpha(t, :) = Alpha(t, :) * Scale(t);
    end
    
    %% Backward variables
    Beta(T, :) = Beta(T, :) * Scale(T);
    for t = (T-1):-1:1
        Beta(t,:) = A * (B(:,O(t+1)) .* Beta(t+1,:)');
        Beta(t, :) = Beta(t, :) * Scale(t);
    end

    %% Compute logP

    try
%%%--REPLACE-THIS--%%%
    catch lasterror
        fprintf('%s\n',lasterror.message);
        Correct = 0;
	return;
    end

    %% Compute correct logP
    % Do not optimize, use definition. (Tudor)

    logP_ =  -sum(log(Scale));

    %% Check results
    if logP_Correct == 1
	[logP_Correct, Prob_Message] = ...
	    matrices_are_equal(logP_, logP, max_error);
        if logP_Correct == 0
            break;
        end
    end
end

if logP_Correct == 1
    fprintf('Probability correct\n');
else
    fprintf('Probability incorrect: %s\n',Prob_Message);
end

Correct = logP_Correct;
