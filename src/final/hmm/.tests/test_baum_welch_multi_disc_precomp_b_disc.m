% test for the precomputed matrix B
%
% Authors: Alexandru Sorici, Tudor Berariu / August 2012

Bprod_Correct = 1;
max_error = 1e-10;

for i=1:10
    L = randi(10,1,1);
    R = 2 + randi(3,1,1);
    TMax = randi(30,1,1);
    
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
    B = ones(N, M, R) / M;
    
    T = ones(1, L) * TMax;
    O = randi(M, L, R, TMax);
    
    %% Compute B_prod

    B_prod = zeros(L, N, TMax);
    B_prod_ = B_prod;
    
    try
%%%--REPLACE-THIS--%%%
    catch lasterror
        fprintf('%s\n',lasterror.message);
        Correct = 0;
	return;
    end

    %% Compute correct Beta
    % Do not optimize, use definition. (Tudor)

    for l = 1 : L
        B_prod_(l, :, 1:T(l)) = ones(N, T(l));
        for t = 1 : T(l)
            obs_symbol_idx = O(l, :, t)';
            for r = 1 : R
                b_idx = sub2ind(size(B), 1:N, ...
                    repmat(obs_symbol_idx(r), 1, N), repmat(r, 1, N));
                B_prod_line = B(b_idx);
                B_prod_(l, :, t) = B_prod_(l, :, t) .* B_prod_line;
            end
        end
    end

    %% Check results
    if Bprod_Correct == 1
	[Bprod_Correct, Bprod_Message] = ...
	    matrices_are_equal(B_prod_, B_prod, max_error);
        if Bprod_Correct == 0
            break;
        end
    end
end

if Bprod_Correct == 1
    fprintf('B_prod correct\n');
else
    fprintf('B_prod incorrect: %s\n',Bprod_Message);
end

Correct = Bprod_Correct;
