% test for the computation of the Xi values given A,B,Pi,Alpha,Beta,Scale
% ! not to be executed directly
%
% Authors: Alexandru Sorici, Tudor Berariu / August 2012

Xi_Correct = 1;
max_error = 1e-10;

for i=1:10
    %% Build random HMM
    N = randi(20,1,1); % Number of states
    M = randi(10,1,1); % Size of symbol set
    L = randi(10,1,1); % Number of observed sequences
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
    O = randi(M,L,T);

    %% Initialize Alpha, Beta, Scale, LogP
    Alpha = zeros (L, T, N); % Alpha is a T x N matrix
    Beta = ones (L, T, N); % Beta is a T x N matrix
    LogP = zeros(1,L);
    Scale = ones(L, TMax);
    
    for l=1:L
        [LogP(l), Alpha(l, 1:T, :), Beta(l, 1:T, :), Scale(l, 1:T)] = ...
            forward_backward_multi_disc(O(l,1:T(l)), Pi, A, B);
    end

    %% Compute Xi

    Xi = zeros(L,T-1,N,N);
    Xi_ = Xi;
    try
%%%--REPLACE-THIS--%%%
    catch
        fprintf('%s\n',lasterror.message);
        Correct = 0;
	return;
    end

    %% Compute correct Xi
    % Do not optimize, use definition. (Tudor)

    for l = 1:L
        for t = 1:(T-1)
            s_ = 0;
            for i = 1:N
                for j = 1:N
                    Xi_(l,t,i,j) = Alpha(l,t,i)*A(i,j)*B(j,O(l,t+1))*Beta(l,t+1,j);
                    s_ = s_ + Xi(l,t,i,j);
                end
            end
            Xi_(l,t,:,:) = Xi_(l,t,:,:) ./ s_;
        end
    end

    %% Check results
    if Xi_Correct == 1
	[Xi_Correct, Xi_Message] = ...
	    matrices_are_equal(Xi_, Xi, max_error);
        if Xi_Correct == 0
            break;
        end
    end
end

if Xi_Correct == 1
    fprintf('Xi correct\n');
else
    fprintf('Xi incorrect: %s\n',Xi_Message);
end

Correct = Xi_Correct;
