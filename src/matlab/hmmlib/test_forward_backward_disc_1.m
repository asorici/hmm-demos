%% Test for the forward variables computation

Alpha_Correct = 1;
Scale_Correct = 1;
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
    
    %% Initialize Alpha, Beta, Scale
    
    Scale = zeros (1, T); % Scale is an 1 x T matrix
    Alpha = zeros (T, N); % Alpha is a T x N matrix
    Beta = ones (T, N); % Beta is a T x N matrix
    Scale_ = zeros (1, T);
    Alpha_ = zeros (T, N);
    Beta_ = ones (T, N);

    %% Compute Alpha
    
    %%%--REPLACE-THIS--%%%
    
    %% Compute correct Alpha and Scale
    
    Alpha_(1,:) = Pi .* B(:, O(1))';
    Scale_(1) = sum(Alpha_(1, :));
    Alpha_(1,:) = Alpha_(1, :) / Scale_(1);

    for t = 2:T
        Alpha_(t,:) = (Alpha_(t-1,:) * A) .* B(:, O(t))';
        Scale_(t) = 1 / sum(Alpha_(t, :));
        Alpha_(t, :) = Alpha_(t, :) * Scale_(t);
    end
    
    %% Check results
    
    Alpha_Check = abs(Alpha_ - Alpha) ./ Alpha_;
    Scale_Check = abs(Scale_ - Scale) ./ Scale_;
    
    if ~all(all(Alpha_Check < error))
        Alpha_Correct = 0;
    end
    if ~all(all(Scale_Check < error))
        Scale_Correct = 0;
    end
    if Alpha_Correct == 0 && Scale_Correct == 0
        break;
    end
end

if Alpha_Correct == 1
    fprintf('Alpha correct\\n')
else
    fprintf('Alpha incorrect\\n')
end
if Scale_Correct == 1
    fprintf('Scale correct\\n')
else
    fprintf('Scale incorrect\\n')
end

Correct = Alpha_Correct * Scale_Correct;