%%%% "signal_HW1.mat" has two elements:
% x - test signal
% N - length of x
load signal_HW1.mat;

% Generates two N x N matrices (block-based DCT and Haar bases):
%   - T_haar(k,:)' is the k-th Haar basis vector
%   - T_dct(k,:)' is the k-th DCT basis vector
[T_dct, T_haar] = GenerateBases(N);



%%%% Part 1: Compute and plot the DFT
% Compute DFT
y_dft = fft(x);
% Amplitude
amp_dft = abs(y_dft);
% Phase
phase_dft = unwrap(angle(y_dft));
freq_dft  = (1/length(y_dft))*(0:length(y_dft)-1)*100;

subplot(2,1,1)
y_reconstructed = real(ifft(fft(x)));
t = 1:length(x);
original = plot(t,x, '-.b');
hold on;
reconstructed = plot(t,y_reconstructed,':r');
leg = legend([original, reconstructed], {'Original', 'Reconstructed via ifft'},'location','northeast','orientation','horizontal');
%set(leg, 'Position', [0.4 0.4 0.2 0.2])
xlabel('Time (s)')

subplot(2,1,2);
plot(freq_dft, amp_dft);
title('Magnitude');
xlabel('Frequency (Hz)')

%subplot(3,1,3);
%plot(freq_dft, phase_dft*180/pi);
%title('Phase');
%xlabel('Angle (degree)')



print('fft','-dpng','-r300');



%%%% Part 2: Check that this is a basis

% Check for full rank
assert(rank(T_dct) == N, 'Error: rank < N');
assert(rank(T_haar) == N, 'Error: rank < N');


%%%% Part 3: Check orthogonality
% Check if the resulting matrix is identity
epsilon = 1e-6;
T_dct_prod = T_dct * transpose(T_dct);
T_haar_prod = T_haar * transpose(T_haar);

%assert(sum(sum(T_dct_prod - eye(size(T_dct_prod,1)) < epsilon)) == 0);
%assert(sum(sum(T_haar_prod - eye(size(T_haar_prod,1)) < epsilon)) == 0);



%%%% Part 4: Compute the projection onto each basis vector
% Projections are given by inner products c(n) = < T_haar(n,:)', x >
%c_dct = zeros(N, N, N);
%c_haar = zeros(N, N, N);
%i=1;
%while i<=N
%    c_dct(i, :, :) = dot(T_dct(i,:).', x);
%    c_haar(i, :, :) = dot(T_haar(i,:).', x);
%    i = i+1;
%end


c_dct = zeros(1, N);
c_haar = zeros(1, N);
i=1;
while i<=N
    c_dct(1, i) = dot(T_dct(i,:), x.');
    c_haar(1, i) = dot(T_haar(i,:), x.');
    i = i+1;
end

close all;
plot(c_dct);
xlabel('Time');
ylabel('Magnitude');
title('Projection(DCT)');
print('projection_dct', '-dpng', '-r300');

close all;
plot(c_haar);
xlabel('Time');
ylabel('Magnitude');
title('Projection(Haar)');
print('projection_haar', '-dpng', '-r300');



%%%% Part 35: Compute a time-frequency diagram for each basis

% You can just use the means of the Heisenberg boxes
% Let b is a basis vector and B = fft(b,N), then compute as: 
n = 0:N-1;
b = T_dct;
B = fft(b,N);
k = 0:N/2-1;
mu_t = sum( n.*abs(b).^2 ); % where n = [0, 1, ..., N-1]
%mu_f = sum( k.*abs(B(1:N/2)).^2 ); % where k = [0, 1, ..., N/2-1]
%mu_f = sum(transpose(k.*abs(B(:,1:N/2) )));

mu_f = sum(k.'.*abs(B(1:N/2,:)).^2);
sigma_t = sqrt( sum( (n-mu_t).^2.*abs(b).^2 ) );
%sigma_f = sqrt( sum( (k-mu_f).^2*abs(B(:,1:N/2)).^2 ) );


% Given the vectors mu_t, mu_f and c, you can plot a T-F diagram 
% using standard plot functions, some examples being:
close all;
c = c_dct;
%plot3(mu_t, mu_f, c.^2, 'o'); hold on;
scatter(mu_t, mu_f, c.^2);
%view(0,90); hold on;
%scatter(mu_t, mu_f, 10, c.^2);view(0,90);colorbar;
print('time_freq_dct', '-dpng', '-r300');

close all;

n = 0:N-1;
b = T_haar;
B = fft(b,N);
k = 0:N/2-1;
mu_t = sum( n.*abs(b).^2 ); % where n = [0, 1, ..., N-1]
%mu_f = sum( k.*abs(B(1:N/2)).^2 ); % where k = [0, 1, ..., N/2-1]
%mu_f = sum(transpose(k.*abs(B(:,1:N/2) )));

mu_f = sum(k.'.*abs(B(1:N/2,:)).^2);
sigma_t = sqrt( sum( (n-mu_t).^2.*abs(b).^2 ) );
c = c_haar;
%plot3(mu_t, mu_f, c.^2, 'o');
%hold on;
scatter(mu_t, mu_f, c.^2);
%view(0,90); hold on;
%scatter(mu_t, mu_f, 10, c.^2);view(0,90);colorbar;
print('time_freq_haar', '-dpng', '-r300');

%%%% Part 6: Interpret your results


%%%% Part 7: Construct your own basis (e.g., variable block sizes for DCT,
%%%% windowed fourier transforms, other wavelet bases)
