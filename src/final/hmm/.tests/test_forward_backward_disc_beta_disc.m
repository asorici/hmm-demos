% test for the backward variables computation
% not to be executed directly
%
% Authors: Alexandru Sorici, Tudor Berariu / August 2012

Beta_Correct = 1;
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
    Beta_ = ones (T, N);

    %% Compute Alpha and Scale
    Alpha(1,:) = Pi .* B(:, O(1))';
    Scale(1) = 1 / sum(Alpha(1, :));
    Alpha(1,:) = Alpha(1, :) * Scale(1);

    for t = 2:T
        Alpha(t,:) = (Alpha(t-1,:) * A) .* B(:, O(t))';
        Scale(t) = 1 / sum(Alpha(t, :));
        Alpha(t, :) = Alpha(t, :) * Scale(t);
    end

    %% Compute Beta

    try
%%%--REPLACE-THIS--%%%
    catch
        fprintf('%s\n',lasterror.message);
        Correct = 0;
	return;
    end

    %% Compute correct Beta
    % Do not optimize, use definition. (Tudor)

    Beta_(T,:) = ones(1,N) * Scale(T);

    for t=(T-1):-1:1
        for i = 1:N
            Beta_(t,i) = 0;
            for j = 1:N
                Beta_(t,i) = Beta_(t,i) + A(i,j) * B(j,O(t+1)) * Beta_(t+1,j);
            end
	    Beta_(t,i) = Scale(t) * Beta_(t,i);
        end
    end

    %% Check results
    if Beta_Correct == 1
	[Beta_Correct, Beta_Message] = ...
	    matrices_are_equal(Beta_, Beta, max_error);
        if Beta_Correct == 0
            break;
        end
    end
end

if Beta_Correct == 1
    fprintf('Beta correct\n');
else
    fprintf('Beta incorrect: %s\n',Beta_Message);
end

Correct = Beta_Correct;
