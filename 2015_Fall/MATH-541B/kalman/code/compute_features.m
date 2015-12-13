function dF = compute_features(dx, featureMean, featureStd, coeff, featCount)

size(dx);

intr = dx * dx';

size(intr(:));
size([dx ; intr(:)]);

dF = ([dx ; intr(:)] - featureMean') ./ featureStd';

dF = coeff(:,1:featCount)'*dF;



end
