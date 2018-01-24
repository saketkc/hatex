%%%% "signal_HW1.mat" has two elements:
% x - test signal
% N - length of x
load signal_HW1.mat;

% Generates two N x N matrices (block-based DCT and Haar bases):
%   - T_haar(k,:)' is the k-th Haar basis vector
%   - T_dct(k,:)' is the k-th DCT basis vector
[T_dct, T_haar] = GenerateBases(N);



%%%% Part 1: Compute and plot the DFT


%%%% Part 2: Check that this is a basis


%%%% Part 3: Check orthogonality


%%%% Part 4: Compute the projection onto each basis vector
% Projections are given by inner products c(n) = < T_haar(n,:)', x >


%%%% Part 5: Compute a time-frequency diagram for each basis

% You can just use the means of the Heisenberg boxes
% Let b is a basis vector and B = fft(b,N), then compute as: 
%   - mu_t = sum( n.*abs(b).^2 ); % where n = [0, 1, ..., N-1]
%   - mu_f = sum( k.*abs(B(1:N/2)).^2 ); % where k = [0, 1, ..., N/2-1]
%   - sigma_t = sqrt( sum( (n-mu_t).^2.*abs(b).^2 ) );
%   - sigma_f = sqrt( sum( (k-mu_f).^2.*abs(B(1:N/2)).^2 ) );


% Given the vectors mu_t, mu_f and c, you can plot a T-F diagram 
% using standard plot functions, some examples being:
%   - plot3(mu_t, mu_f, c.^2, 'o');
%   - scatter(mu_t, mu_f, c.^2);view(0,90)
%   - scatter(mu_t, mu_f, 10, c.^2);view(0,90);colorbar



%%%% Part 6: Interpret your results


%%%% Part 7: Construct your own basis (e.g., variable block sizes for DCT,
%%%% windowed fourier transforms, other wavelet bases)