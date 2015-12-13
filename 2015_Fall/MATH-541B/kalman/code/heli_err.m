function meanE = heli_err(M, target_hover_state, model, idx, dt, ...
    noise_F_T, noise_obs, featureMean, featureStd, coeff, featCount)

for g=1:size(noise_obs,3)    
    E(g) = 0;    
    x(:,1) = target_hover_state;
    for t=1:300
        % control law:
        dx = compute_dx(target_hover_state, x(:,t));
        E(g) = E(g) + norm(dx);
        if (E(g) > 1e12)
            meanE = 1e12;
            return;
        end
        dx(1:end-1) = dx(1:end-1) + noise_obs(:,t,g);
        delta_u = M*compute_features(dx, featureMean, featureStd, coeff, featCount);
        % simulate:
        [x(:,t+1)] = f_heli(x(:,t), delta_u, dt, model, idx, noise_F_T(:,t,g));
    end
    
end

meanE = mean(E);

end
