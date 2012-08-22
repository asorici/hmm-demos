function [ P, alpha, beta, scale ] = forward_backward( O, Pi, A, B )
%FORWARD_BACKWARD computes the probability ... 
%   Input args:
%   O - the observed sequence
%   Pi - initial state probabilities


%   N - the number of states
%   M - the number of possible values for each observed variable
%   T - the length of the observed sequence
%   R - the dimensionality of the observed sequence

%   Pi is an 1 x N matrix
%   A is an N x N matrix
%   B is an N x M matrix if R = 1 and an N x M x R matrix if R > 1
%   O is an R X T matrix

%   alpha is an T x N
%   beta is an T X N

%{  
    The function distinguishes programmatically between the uni-dimensional
    and multi-dimensional independent observation sequences
%}

%   initialization
N = size(Pi, 2);
M = size(B, 2);
T = size(O, 2);
R = size(O, 1);

scale = zeros (1, T);
alpha = zeros (T, N);
beta = ones (T, N);

%   check the equality in dimensions between O and B
if size(B, 3) ~= R
    error('forward_backward:dimensionCheck', ... 
          'The row dimension %d of O and ' + ... 
          'the depth dimension %d of B do not agree', R, size(B, 3));
end

%%  The uni-dimensional case
if R == 1
    alpha(1,:) = Pi .* B(:, O(1))';
    scale(1) = sum(alpha(1, :));
    alpha(1,:) = alpha(1, :) / scale(1);

    for t = 2:T
        alpha(t,:) = (alpha(t-1,:) * A) .* B(:, O(t))';
        scale(t) = sum(alpha(t, :));
        alpha(t, :) = alpha(t, :) / scale(t);
    end

    beta(T, :) = beta(T, :) / scale(T);
    for t = (T-1):-1:1
        beta(t,:) = A * (B(:,O(t+1)) .* beta(t+1,:)');
        beta(t, :) = beta(t, :) / scale(t);
    end
    %scale = ones(size(scale)) ./ scale;
    P = prod(scale);

else
%%  The multi-dimensional case
    obs_symbol_idx = O(:, 1)';
    B_prod = ones(1, N);
    
    % multiplication of independent observation dimension probabilities for
    % each state
    for r = 1 : R
        b_idx = sub2ind(size(B), 1:N, repmat(obs_symbol_idx(r), 1, N), repmat(r, 1, N));
        B_prod_line = B(b_idx);
        B_prod = B_prod .* B_prod_line;
    end
    
    alpha(1,:) = Pi .* B_prod;
    scale(1) = sum(alpha(1, :));
    alpha(1,:) = alpha(1, :) / scale(1);
    
    for t = 2:T
        % multiplication of independent observation dimension probabilities 
        % for each state
        obs_symbol_idx = O(:, t)';
        B_prod = ones(1, N);
        
        for r = 1 : R
            b_idx = sub2ind(size(B), 1:N, ...
                repmat(obs_symbol_idx(r), 1, N), repmat(r, 1, N));
            B_prod_line = B(b_idx);
            B_prod = B_prod .* B_prod_line;
        end
        
        alpha(t,:) = (alpha(t-1,:) * A) .* B_prod;
        scale(t) = sum(alpha(t, :));
        alpha(t, :) = alpha(t, :) / scale(t);
    end

    beta(T, :) = beta(T, :) / scale(T);
    for t = (T-1):-1:1
        % multiplication of independent observation dimension probabilities 
        % for each state
        obs_symbol_idx = O(:, t + 1)';
        B_prod = ones(1, N);
        
        for r = 1 : R
            b_idx = sub2ind(size(B), 1:N, ...
                repmat(obs_symbol_idx(r), 1, N), repmat(r, 1, N));
            B_prod_line = B(b_idx);
            B_prod = B_prod .* B_prod_line;
        end
        
        beta(t,:) = A * (B_prod' .* beta(t+1,:)');
        beta(t, :) = beta(t, :) / scale(t);
    end
    %scale = ones(size(scale)) ./ scale;
    P = prod(scale);
end