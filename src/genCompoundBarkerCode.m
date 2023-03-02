function code = genCompoundBarkerCode(N)
%genCompoundBarkerCode   Generate a compound Barker code sequence of length
%N from standard Barker codes.
%
%   INPUT:
%       N: Length of compound Barker code to generate. N must be factorized by 
%           only by odd length Barker code lengths. If invalid length is given,
%           NaN is returned. 
%   OUTPUT: 
%       code: A row vector of either 1 or -1 corresponding to the compound Barker
%           code defined by the input length.
%
%   Copyright 2023 Emelina Vienneau (emelina@vienneau.io)

barkerCodeLengths = [3, 5, 7, 11, 13]; % Barker codes lengths from which to create the compound Barker code

fac = factor(N);
if all(ismember(fac, barkerCodeLengths))
    code = 1;
    for k = 1:length(fac)
        code = kron(code, genBarkerCode(fac(k)));
    end
else
    print('Invalid length!')
    code = NaN;
    return
end