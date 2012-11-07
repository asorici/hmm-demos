% test for the computation of the logarithm of the probability of 
% the observed sequences given the HMM
% ! not to be executed directly
%
% Authors: Alexandru Sorici, Tudor Berariu / August 2012

Psi_Correct = 1;
Phi_Correct = 1;
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
    % logarithms of A and B
    logA = log(A); 
    logB = log(B); 

    %% Create random observed sequence
    T = randi(30,1,1);
    O = randi(M,1,T);

    %% Initialize Alpha, Beta, Scale
    logP = 0;
    logP_ = 0;

    %% Initialize Psi and Phi
    Q = zeros(1, T); % Q is a 1 x T matrix (see above)

    Psi = zeros(T, N); % Psi is  a T x N matrix
    Phi = zeros(T, N); % Phi(t,i) = max{log P(q1,...,qt,o1,...,ot|A,B,Pi)}
    
    Phi(1, :) = log(Pi) + logB(:, O(1))'; % Initialization for Phi (t = 1)
    
    Psi_ = Psi;
    Phi_ = Phi;
    

    %% Compute Psi and Phi

    try
%%%--REPLACE-THIS--%%%
    catch
        fprintf('%s\n',lasterror.message);
        Correct = 0;
	return;
    end

    %% Compute correct Psi and Phi
    % Do not optimize, use definition. (Tudor)
    for t=2:T
        [Phi_(t,:), Psi_(t,:)] = max(repmat(Phi_(t-1,:)',1,N) + logA);
        Phi_(t,:) = Phi_(t,:) + logB(:,O(t))';
    end
    
    %% Check results
    if Psi_Correct == 1
	[Psi_Correct, Psi_Message] = ...
	    matrices_are_equal(Psi_, Psi, max_error);
    end
    if Phi_Correct == 1
	[Phi_Correct, Phi_Message] = ...
	    matrices_are_equal(Phi_, Phi, max_error);
    end
    if Psi_Correct == 0 && Phi_Correct == 0
        break;
    end
end

if Psi_Correct == 1
    fprintf('Psi correct\n');
else
    fprintf('Psi incorrect: %s\n',Psi_Message);
end
if Phi_Correct == 1
    fprintf('Phi correct\n');
else
    fprintf('Phi incorrect: %s\n',Phi_Message);
end

Correct = Psi_Correct * Phi_Correct;

