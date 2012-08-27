%% Test for the backward variables computation

Beta_Correct = 1;
error = 1e-10;

for i=1:10
    
    %% Build random HMM
    N = randi(20,1,1);
    M = randi(10,1,1);
    
    Pi = rand(1, N);
    Pi = Pi / sum(Pi);
    
    A = rand(N, N);
    A = A .* repmat((1.0 ./ sum(A,2)), [1 N]);
    
    B = rand(N, M);
    B = B .* repmat((1.0 ./ sum(A,2)), [1 M]);
    
    %% Create random observed sequence
    
    T = randi(30,1,1);
    O = randi(M,1,T);
    
    %% Compute Alpha and Scale
    
    Scale = zeros (1, T); % Scale is an 1 x T matrix
    Alpha = zeros (T, N); % Alpha is a T x N matrix
    Beta = ones (T, N); % Beta is a T x N matrix
    Beta_ = ones (T, N);
    
    Alpha(1,:) = Pi .* B(:, O(1))';
    Scale(1) = sum(Alpha(1, :));
    Alpha(1,:) = Alpha(1, :) / Scale(1);

    for t = 2:T
        Alpha(t,:) = (Alpha(t-1,:) * A) .* B(:, O(t))';
        Scale(t) = 1 / sum(Alpha(t, :));
        Alpha(t, :) = Alpha(t, :) * Scale(t);
    end

    %% Compute Beta
    
    %%%--REPLACE-THIS--%%%
    
    %% Compute correct Beta
    
    Beta_(T, :) = Beta_(T, :) * Scale(T);
    for t = (T-1):-1:1
        Beta_(t,:) = A * (B(:,O(t+1)) .* Beta_(t+1,:)');
        Beta_(t, :) = Beta_(t, :) * Scale(t);
    end
    
    %% Check results
    
    Beta_Check = abs(Beta_ - Beta) ./ Beta_;
    
    if ~all(all(Beta_Check < error))
        Beta_Correct = 0;
        break;
    end
end

if Beta_Correct == 1
    fprintf('Beta is correct\\n')
else
    fprintf('Beta is incorrect\\n')
end

Correct = Beta_Correct;