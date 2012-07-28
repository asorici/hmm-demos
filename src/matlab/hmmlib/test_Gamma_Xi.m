%% test Gamma, Xi - nu se comite :)

M = ceil(rand()*20)
N = ceil(rand()*15)
T = ceil(rand()*30)


V = 1:M;
O = randi(M,1,T);

Pi = rand(1,N);
Pi = Pi/ sum(Pi);

A = rand(N,N);
A = A ./ repmat(sum(A,2),1,N);

B = rand(N,M);
B = B ./ repmat(sum(B,2),1,M);

[P, Alpha, Beta, Scale] = forward_backward(O, Pi, A, B);

Gamma = zeros(T,N);

Alpha_3D = repmat(Alpha(1:(T-1),:),[1 1 N]);
A_3D = permute(repmat(A,[1 1 (T-1)]), [3 1 2]);
B_3D = permute(repmat(B(:,O(2:T)),[1 1 N]), [2 3 1]);
Beta_3D = permute(repmat(Beta(2:T,:), [1 1 N]), [1 3 2]);


Xi = Alpha_3D .* A_3D .* B_3D .* Beta_3D / P;
%Gamma(1:(T-1),:) = sum(Xi,3);
%Gamma(T,:)= Alpha(T,:) .* Beta(T,:) / P;
Gamma = Alpha .* Beta / P;

correctGamma = 1;
correctXi = 1;

for t = 1:T
    for i = 1:N
        val = Alpha(t,i) * Beta(t,i) / P;
        if Gamma(t,i) ~= val
            correctGamma = 0;
            fprintf('Gamma(%d,%d): %f ~= %f',t,i,Gamma(t,i),val)
        end
    end
end



for t = 1:(T-1)
    for i = 1:N
        for j = 1:N
            val = Alpha(t,i) * A(i,j) * B(j,O(t+1)) * Beta(t+1,j) / P;
            if Xi(t,i,j) ~= val
                correctXi = 0;
                fprintf('Xi(%d,%d,%d): %f ~= %f',t,i,j,Xi(t,i,j),val)
            end
        end
    end
end

if correctGamma == 1
    disp 'Gamma correct'
else
    disp 'Gamma incorrect'
end

if correctXi == 1
    disp 'Xi correct'
else
    disp 'Xi incorrect'
end
