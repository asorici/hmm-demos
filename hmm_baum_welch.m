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

E = ones(M, N, R) / M;

% --------------------------------------

epsi = 1e-10;
LL = [];
lik = 0;
ct = 1;

L = zeros(1, P);
for p=1:P
    L(1, p) = size(OL{1, p}, 1);
end
Lmax = max(L);

while ct <= maxiter
    % ----------------------------------------------------------------
    % estimate xi and gama from all observations using the precomputed
    % forward and backward variables
    
    obs = 0;
    
    gamma_all_init = zeros(1, N);
    gamma_all_sum = zeros(1, N);
    gamma_all_k_sum = zeros(M, N, R);
    scale_all = zeros(1, Lmax);
    xi_all = zeros(N, N);
    
    for p = 1:P
        [alfa, beta, scale] = hmm_forward_backward(OL{1, p}, T, E, pi);
        
        gamma = zeros(L(p), N);
        gamma_k_sum = zeros(M, N, R);
        
        %disp(alfa)
        %disp(beta)
        %pause;
        
        % ---- compute gamma variable
        gamma = (alfa .* beta) + epsi;
        for t = 1:L(p)
            gamma(t, :) = gamma(t, :) / sum(gamma(t, :));
        end
        gammasum = sum(gamma);
        
        % ---- compute gammak - add gammas where the observed index k appears
        for r = 1 : R
            for t = 1 : L(p)
                %m = find([1:M] == OL{1, p}(t, r));
                m = OL{1, p}(t, r);
                
                %for i = 1 : N
                %    gamma_k_sum(m, r, i) = gamma_k_sum(m, r, i) + gamma(t, i);
                %end
                gamma_k_sum(m, :, r) = gamma_k_sum(m, :, r) + gamma(t, :);
            end
        end
        
        % ---- compute xi-s
        for t = 1 : L(p) - 1
            xi_t = zeros(N, N);
            obs_t = 0;
            
            for i = 1:N
                for j = 1:N
                    idx_symbols = OL{1, p}(t + 1, :);
                    %em_j = E(:, :, j);
                    %idx = sub2ind(size(em_j), idx_symbols, 1:R);
                    
                    prod_r = 1;
                    for r = 1 : R
                        prod_r = prod_r * E(idx_symbols(1, r), j, r);
                    end
                    
                    %xi_t(i, j) = alfa(t, i) * T(i, j) * prod(em_j(idx)) * beta(t + 1, j);
                    xi_t(i, j) = alfa(t, i) * T(i, j) * prod_r * beta(t + 1, j);
                    obs_t = obs_t + xi_t(i, j);
                end
            end
            
            xi_t = xi_t / obs_t;
            
            %disp(t);
            %disp(xi_t);
            %pause;
            
            xi_all = xi_all + xi_t;
        end
        
        gamma_all_init = gamma_all_init + gamma(1, :);
        gamma_all_sum = gamma_all_sum + gammasum;
        gamma_all_k_sum = gamma_all_k_sum + gamma_k_sum;
        
        for t = 1 : L(p)
            scale_all(1, t) = scale_all(1, t) + log(scale(1, t));
        end
        
    end
    
    % -------------- compute new parameter estimates ---------------
    pi = gamma_all_init / sum(gamma_all_init);
    
    for i = 1 : N
        T(i, :) = xi_all(i, :) / sum(xi_all(i, :));
    end
    
    for r = 1 : R
        for i = 1 : N
            E(:, i, r) = gamma_all_k_sum(:, i, r) / gamma_all_sum(1, i);
        end
    end
    
    %disp(T);
    %disp(E);
    %disp(pi);
    %disp(obs);
    %pause;
    
    prev_lik = lik;
    lik = sum(scale_all);
    LL = [LL lik];
    fprintf('\ncycle %i log likelihood = %f ',ct, lik); 
    
    if ct <= 2
        likbase = lik
    elseif (lik<(prev_lik - 1e-6))     
        fprintf('vionum_binstion');
    elseif ((lik-likbase) < (1 + mindiff) * (prev_lik - likbase) || ~isfinite(lik))
        fprintf('\nend\n');    
        break;
    end
    
    %if ct >= 3 && abs(obs - prev_val) <= mindiff
    %    break;
    %end
    
    ct = ct + 1;
end