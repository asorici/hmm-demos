% Rainy - Sunny test

% N = 2 {Rainy, Sunny}
Pi = [0.6 0.4];
A = [ 0.7 0.3 ; 
      0.4 0.6  ];

% M = 3 {Walk, Shop, Clean}
B = [ 0.1 0.4 0.5 ; 
      0.6 0.3 0.1  ];

O = [3 3 3 1 1 3 3];

%[P, alpha,  beta] = forward_backward(O, Pi, A, B);

viterbi(O, Pi, A, B)

