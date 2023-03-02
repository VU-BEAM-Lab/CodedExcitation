function [g, C] = genDecodingFilter(code, decodingChip, M, L, Tpfs)
%genDecodingFilter   Generate an L-tap FIR filter approximation to the inverse
%of a coded excitation waveform.
% 
%   INPUT:
%       code: A binary code used for coded excitation, eg [1, 1, 1, -1, 1].
%           Must be a row vector. Note that this is not the upsampled code.
%       decodingChip: A sampled base pulse waveform, eg a single cycle 
%           sinusoid. Must be a row vector.
%       M: The number of points to use for the Fourier Transform of the
%           code. Must be greater than L.
%       L: The number of taps for the FIR filter. Generally powers of 2
%           are used. The longer the code, the more taps will be needed for
%           good results.
%       Tpfs: The upsample factor for the code. The filter is upsampled by
%           this value and convolved with the chip. Typically Tp is equal
%           to the length of the encoding chip and fs is the sampling 
%           frequency.
%   OUTPUT:
%       g: The L-tap FIR decoding filter defined by the code, decoding 
%           chip, and upsample factor. This filter serves as an inverse 
%           filter for the code and a matched filter for the decoding chip. 
%           It is a column vector and it is real. 
%       C:  Optional output of the Fourier transform of the binary code.
%
%   Copyright 2023 Emelina Vienneau (emelina@vienneau.io)

N = length(code);
n = 0:N-1;
f = linspace(-1/2, 1/2, M+1);
f = f(1:end-1);
W1 = exp(-1j*2*pi*f'*n);
C = W1*code'; % Eq. (4)
m = 0:M-1;
l = 0:L-1;
W2 = exp(-1j*2*pi*m'*l/M);
D = exp(-1j*pi*f*(L-1))./(C.'.*exp(1j*pi*f*N)); % Eq. (5)
h = W2'*D.'; % Eq. (6)
g = conv(upsample(real(h), Tpfs), flip(decodingChip), 'same'); % Eq. (7)
g = g*N/M;