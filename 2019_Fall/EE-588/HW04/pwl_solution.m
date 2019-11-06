pwl_fit_data;
m = length(x);


%knots = [1 2 3 4 5 6 7 8 9 10];
knots = [1 2 3 4 5];

x_plot = 0:0.0001:1;

m_plot = length(x_plot);

y_plot = [];
figure('DefaultAxesFontSize',20);
plot(x, y, 'r.', 'DisplayName', 'given');
hold on;
for k = knots
  a = [0:1/k:1]';

  %S = sparse(i,j,s,m,n,nzmax) uses vectors i, j, and s to generate an
  %  m-by-n sparse matrix such that S(i(k),j(k)) = s(k), with space
  %  allocated for nzmax nonzeros.  Vectors i, j, and s are all the same
  %  length.

  F = sparse(1:m, max(1, ceil(x*k)), 1, m, k);
  cvx_begin
    variables myalpha(k) mybeta(k);
    minimize(norm(diag(x)*F*myalpha + F*mybeta-y, 2))
    subject to  
    if (k>=2)
        myalpha(1:k-1).*a(2:k) + mybeta(1:k-1) == myalpha(2:k).*a(2:k) + mybeta(2:k)
        a(1:k-1) <= a(2:k)
    end
  cvx_end

  F_plot = sparse(1:m_plot, max(1, ceil(x_plot*k)), 1, m_plot, k);
  y_temp = diag(x_plot)*F_plot*myalpha + F_plot*mybeta;
  y_plot = [y_plot y_temp]; 
  plot(x_plot, y_temp, 'DisplayName', strcat('# knots=', int2str(k)));
  hold on;
end

hold off;
legend;



