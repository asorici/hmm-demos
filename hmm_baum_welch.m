function [T, E, pi] = hmm_baum_welch(OL, N, M, R, mindiff, maxiter)
% the function performes the Baum-Welch parameter estimation algorithm for
% HMMs using the list of observed sequences OL
%
% OL is a cell array of length P, having L x R matrices as elements where:
%
% L - length of a single observation sequence
% R - number of dimensions for the observation vector
% N - number of hidden states
% M - number of codebook symbols for each dimension of the observation
%     vector

P = size(OL, 2);

% ---- initialization of parameters ----
T = rand(N);
st = sum(T, 2);
for j = 1:N
    T(:, j) = T(:, j) ./ st;
end

pi = rand(1, N);
pi = pi / sum(pi);

E = ones(M, R, N) / M;

% ---- compute alfa-s and beta-s for all the observation sequences ----
%{
alfas = cell(1, P);
betas = cell(1, P);
xis = cell(1, P);
gamas = cell(1, P);
obs = cell(1, P);
pis = cell(1, P);
%}

prev_val = 0;
ct = 1;

T
E
pi

pause;

while ct <= maxiter
    % ----------------------------------------------------------------
    % estimate xi and gama from all observations using the precomputed
    % forward and backward variables
    
    obs_transition = 0;
    obs = 0;
    
    for p = 1:P
        L = size(OL{1, p}, 1);
        
        %alfas = hmm_forward(OL{1, p}, T, E, pi);
        %betas = hmm_backward(OL{1, p}, T, E, pi);
        [alfas, betas] = hmm_forward_backward(OL{1, p}, T, E, pi);
        
        xis = zeros(N, N);
        gamas = zeros(1, N);
        pis = zeros(1, N);
        emissions = zeros(M, R, N);
        
        %disp(alfas)
        %disp(betas)
        %pause;
        
        for t = 1:L-1
            xi_t = zeros(N, N);
            obs_t = 0;
            
            for i = 1:N
                for j = 1:N
                    idx_symbols = OL{1, p}(t + 1, :);
                    em_j = E(:, :, j);
                    idx = sub2ind(size(em_j), idx_symbols, 1:R);
                    
                    xi_t(i, j) = alfas(t, i) * T(i, j) * prod(em_j(idx)) * betas(t + 1, j);
                    obs_t = obs_t + xi_t(i, j);
                end
            end
            
            xi_t = xi_t / obs_t;
            gama_t = sum(xi_t, 2)';
            
            %disp(t);
            %disp(xi_t);
            %disp(gama_t);
            %pause;
            
            for i = 1 : N
                for r = 1 : R
                    sr = OL{1, p}(t, r);
                    emissions(sr, r, i) = emissions(sr, r, i) + gama_t(i);
                end
            end
            
            xis = xis + xi_t;
            obs_transition = obs_transition + obs_t;
            obs = obs + obs_t;
            
            %gamas{1, p} = gamas{1, p} + gama_t;
            gamas = gamas + gama_t;
            
            if t == 1
                for i = 1 : N
                    pis(i) = pis(i) + gama_t(i);
                end
            end
        end
        
        
        % take into account the L-th state as well, as it has not been
        % covered in the transitions
        gama_L = zeros(1, N);
        normalizer = alfas(L, :) * betas(L, :)';
        obs = obs + normalizer;
        
        for i = 1 : N
            gama_L(i) = alfas(L, i) * betas(L, i) / normalizer;
            for r = 1 : R
                sr = OL{1, p}(L, r);
                emissions(sr, r, i) = emissions(sr, r, i) + gama_L(i);
            end
        end
    end
    
    % -------------- compute new parameter estimates ---------------
    pi = pis / P;
    T = xis / obs_transition;
    E = emissions / obs;
    
    disp(T);
    disp(E);
    disp(pi);
    disp(obs);
    pause;
    
    if ct >= 3 && abs(obs - prev_val) <= mindiff
        break;
    end
    
    prev_val = obs;
    ct = ct + 1;
end

disp('Best likelihood: ');
disp(prev_val);