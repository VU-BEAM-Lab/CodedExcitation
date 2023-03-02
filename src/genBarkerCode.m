function code = genBarkerCode(N)
%genBarkerCode   Generate a binary Barker code sequence satisfying the
%ideal autocorrelation property that the sidelobes are no higher than 1/N.
%
%   INPUT:
%       length: Length of Barker code to generate. If invalid length is given,
%           NaN is returned. Valid lengths include 3, 5, 7, 11, 13.
%   OUTPUT: 
%       code: A row vector of either 1 or -1 corresponding to the Barker
%           code defined by the input length.
%
%   Copyright 2023 Emelina Vienneau (emelina@vienneau.io)

if N == 3
    code = [1, 1, -1];
elseif N == 5
    code = [1 1 1 -1 1];
elseif N == 7
    code = [1 1 1 -1 -1 1 -1];
elseif N == 11
    code = [1 1 1 -1 -1 -1 1 -1 -1 1 -1];
elseif N == 13
    code = [1 1 1 1 1 -1 -1 1 1 -1 1 -1 1];
else
    print('Unsupported length!')
    code = NaN;
end