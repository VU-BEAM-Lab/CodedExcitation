function [pulseCode, encodingChip, Tp] = genPulseCode(fClock, f0, binaryCode, numCycles)
%genPulseCode   Generate a pulse code description of a tri-state coded 
%excitation waveform for programming the transmit waveform on the Verasonics.
% 
%   INPUT:
%       fclock: The clock rate in Hz (e.g., 250e6).
%       f0: The transmit center frequency in Hz.
%       binaryCode: A vector of +1's and -1's (no zeros) defining the 
%           binary code for designing the coded excitation waveform (e.g., 
%           the output of genBarkerCode or genCompoundBarkerCode).
%       numCycles: The number of cycles to be used for the chip pulse.
%   OUTPUT:
%       pulseCode: The matrix describing the tri-state coded excitation 
%           waveform in terms of clock cycles which is used to program the 
%           Verasonics transmit waveform.
%       encodingChip: Optional output of the encoding chip waveform.
%       Tp: Optional output of the length of the encodingChip which is
%           useful for designing the decoding filter.
%
%   Copyright 2023 Emelina Vienneau (emelina@vienneau.io)

% number of clock cycles that define half the period of a sinusoid at the transmit center frequency
halfPeriod =  round((fClock/f0)/2);
% encodingChip and Tp may be needed for later processing
encodingChip = repmat([ones(1, halfPeriod), -1*ones(1, halfPeriod)], 1, numCycles);
Tp = length(encodingChip);
% basic unit to define the tri-state pulseCode in terms of the number of
% clock cycles for each component of the pulse (zeros and poles)
baseCode = [0, halfPeriod, 0, -halfPeriod, numCycles]; % [Z1, P1, Z2, P2, R] (zeros, pulse, zeros, pulse, repetitions)
pulseCode = repmat(baseCode, length(binaryCode), 1);
% invert polarity of pulses based on bits of the binary code
pulseCode(:, 2) = pulseCode(:, 2).*binaryCode(:);
pulseCode(:, 4) = pulseCode(:, 4).*binaryCode(:);
