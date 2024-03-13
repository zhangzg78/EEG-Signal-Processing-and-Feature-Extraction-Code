function ratio = f_explainedVariance (latent)

lambda_sum = sum(latent);
NumLambda  =  length(latent);
for lambdaNum = 1:NumLambda
    
    temp = sum(latent(1:lambdaNum));
    
    ratio(lambdaNum) = 100*temp./lambda_sum;
    
end

