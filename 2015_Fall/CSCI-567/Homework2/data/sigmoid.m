function [ sigma ] = sigmoid( X )
%UNTITLED21 Summary of this function goes here
%   Detailed explanation goes here

sigma = zeros(length(X),1);
sigma = (1.0)./(1.0+exp(-X));
end

