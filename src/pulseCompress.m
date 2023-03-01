function decodedData = pulseCompress(data, decodingFilter, fs, fsUpsamp)
%pulseCompress   Perform coded excitation pulse compression/decoding on the
%input data using the provided decoding filter. The data can optionally be
%upsampled for pulse compression. 
%
%   INPUT:
%       data: Real ultrasound channel or RF data to be decoded. Ensure that
%           the first dimension of data is the axial/depth dimension. 
%           Consider calling this function in a parfor loop through one of 
%           the data dimensions.
%       decodingFilter: The L-tap FIR decoding filter defined by the code, 
%           decoding chip, and upsample factor, i.e., the output of
%           genDecodingFilter. Should be a column vector.
%       fs: The axial sampling frequency of data in Hz.
%       fsUpsamp: The sampling frequency in Hz at which to perform the
%           decoding. Generally fsUpsamp = fs, but if a higher sampling
%           frequency is desired, it should be an integer multiple of fs. 
%
%   OUTPUT: 
%       decodedData: The decoded data with its original sampling frequency 
%           and size.
%
%   Copyright 2021 Emelina Vienneau (emelina@vienneau.io)

if fs ~= fsUpsamp
    L = length(data);
    data = interp1((0:L-1)/fs, data, 0:1/fsUpsamp:L/fs-1/fsUpsamp, 'spline', 0);
end
decodedData = flip(convn(flip(data), decodingFilter, 'same'));
if fs ~= fsUpsamp
    decodedData = interp1(0:1/fsUpsamp:length(decodedData)/fsUpsamp-1/fsUpsamp, decodedData, 0:1/fs:L/fs-1/fs, 'spline', 0);
end