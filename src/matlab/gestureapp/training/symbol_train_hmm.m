function [A, B, Pi] = symbol_train_hmm(symbol)
%%  Trains the HMM model for the specified symbol
%   The function assumes the existance of two files:
%       - <symbol>.mat contains the raw mouse track sequences of which
%         3/4 are used for training
%       - <symbol>_codebook.mat contains the codebook vectors defined
%         for the symbol <symbol>
%
%   Inputs: symbol - a string denoting the symbol name to train the HMM
%                    parameters for
%
%   Outputs: the learned HMM parameters
%               A - the transition matrix
%               B - the emission matrix
%               Pi - the initial state probabilities