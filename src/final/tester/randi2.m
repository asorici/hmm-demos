function result = randi2(range, varargin)
s = cell2mat(varargin);
result = ceil(rand(s) * range);
