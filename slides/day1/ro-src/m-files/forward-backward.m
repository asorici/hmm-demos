N = size(Pi, 2); % The number of states
T = size(O, 2); % The number of observations

Scale = zeros (1, T); % Scale is an 1 x T matrix
Alpha = zeros (T, N); % Alpha is a T x N matrix
Beta = ones (T, N); % Beta is a T x N matrix

%% Forward variables
% alpha_disc-start - Write code below

% alpha_disc-end - Write code above