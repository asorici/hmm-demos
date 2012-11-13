% test for the computation best path in the backwards phase of the
% Viterbi algorithm
% ! not to be executed directly
%
% Authors: Alexandru Sorici, Tudor Berariu / August 2012

Q_Correct = 1;
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
    % logarithms of A and B
    logA = log(A); 
    logB = log(B); 

    %% Create random observed sequence
    T = randi2(30,1,1);
    O = randi2(M,1,T);

    %% Initialize Alpha, Beta, Scale
    logP = 0;
    logP_ = 0;

    %% Initialize Psi and Phi
    Q = zeros(1, T); % Q is a 1 x T matrix (see above)

    Psi = zeros(T, N); % Psi is  a T x N matrix
    Phi = zeros(T, N); % Phi(t,i) = max{log P(q1,...,qt,o1,...,ot|A,B,Pi)}
    
    Phi(1, :) = log(Pi) + logB(:, O(1))'; % Initialization for Phi (t = 1)
    
    %% Recursion
    for t=2:T
        [Phi(t,:), Psi(t,:)] = max(repmat(Phi(t-1,:)',1,N) + logA);
        Phi(t,:) = Phi(t,:) + logB(:,O(t))';
    end

    %% logP
    [logP, Q(T)] = max(Phi(T, :));

    Q_ = Q;

    %% Compute Q

    
%%%--REPLACE-THIS--%%%
    

    %% Compute correct Q
    % Do not optimize, use definition. (Tudor)
    for t=(T-1):-1:1
        Q_(t) = Psi(t+1,Q_(t+1));
    end

    %% Check results
    if Q_Correct == 1
	[Q_Correct, Q_Message] = ...
	    matrices_are_equal(Q_, Q, max_error);
    end
    if Q_Correct == 0 && Q_Correct == 0
        break;
    end
end

if Q_Correct == 1
    fprintf('Q correct\n');
else
    fprintf('Q incorrect: %s\n',Q_Message);
end

Correct = Q_Correct;

