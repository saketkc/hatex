clear all;
rng(1);
data = load('hw5_blob.mat');
blob = data.points;
K = 3;
N = size(blob,1);
LL_iter = {};
clusters_new = [];
clusters_assigned = {};
for i=1:5
    loglik =0;
    LL= [];
    [clusters, mu] = kmeans(blob, K);
    if (i==5)
        gamma = [];
       for t=1:3
           gamma(t) = sum((clusters==t))/length(clusters);
      end
     %gamma
    else
        r = rand(1,3);
        gamma = r/sum(r);
   end
    variances = {};
    for j=1:K
        indices = find(clusters == j);
        v = bsxfun(@minus, blob(indices, : ), mu(j,:));
        points = blob(indices,:);
        variances{j} =  v'*v;
    end
    newmu = mu;
    mu = mu/2;
    iter=0;
    while (newmu~=mu)
        iter=iter+1;
        loglik =0;
        mu = newmu;
        p = zeros(N,K);
        for k=1:K
            %p(x_n|z_n=k)
            p(:,k) = gaussian(blob,mu(k,:), variances{k});
        end
        [M, clusters_new] = max(p,[],2);
        %p_w
        p_w = bsxfun(@times, p, gamma);
        W = bsxfun(@rdivide, p_w, sum(p_w,2));
        for k=1:K
            gamma(k) = mean(W(:,k),1);
            newmu(k,:) = (W(:,k)'*blob)./(sum(W(:,k),1));
            var_k = zeros(2,2);
            blob_m = bsxfun(@minus, blob, newmu(k,:));
            for (ii=1:N)
                var_k = var_k + W(ii,k).*(blob_m(ii,:)'*blob_m(ii,:));
            end
            variances{k} = var_k ./sum(W(:, k),1);
        end
        loglik = zeros(1,N);
        for zz=1:N
            for k=1:K
                loglik(zz) = loglik(zz) + (p_w(zz,k));
            end
        end
        LL(end+1) = sum(log((loglik)));
    end
    clusters_assigned{i} = clusters_new;
    LL_iter{i} = LL;
end
%length(LL_iter{1})
%plot(1:1:length(LL_iter{1}), LL_iter{1}, 'r', 1:length(LL_iter{2}), LL_iter{2}, 'g', 1:length(LL_iter{3}), LL_iter{3}, 'b', 1:length(LL_iter{4}), LL_iter{4}, 'y', 1:length(LL_iter{5}), LL_iter{5}, 'k');

h1=plot(1:1:length(LL_iter{1}), LL_iter{1}, 'r');
hold on;%
h2=plot(1:length(LL_iter{2}), LL_iter{2}, 'g');
hold on;
h3=plot(1:length(LL_iter{3}), LL_iter{3}, 'b');
hold on;
h4=plot(1:length(LL_iter{4}), LL_iter{4}, 'm');
hold on;
h5=plot(1:length(LL_iter{5}), LL_iter{5}, 'k');
hold off;

legend([h1,h2,h3,h4,h5],{'1','2','3','4','5(Best)'});
print('ll','-dpng');


disp('Best run in terms of maximum log likelihood: 5');

scatter(blob(:,1), blob(:,2), [], clusters_assigned{1}, 'filled');
print('ll-scatter', '-dpng');
