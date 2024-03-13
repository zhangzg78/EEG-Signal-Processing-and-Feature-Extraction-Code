function ChooseComp(data,irrelate,maxComp,nolinear)

[coeff, score, latent] = PRINCOMP(data);
for comp = 2:maxComp
    comp
    X=score(:,1:comp)';
    [sR,step]=icassoEst('both', X,irrelate, 'lastEig', comp, 'g', nolinear, ...
        'approach', 'symm');
    %%
    New_sR.mode = sR.mode;
    New_sR.signal = sR.signal;
    New_sR.fasticaoptions = sR.fasticaoptions;
    New_sR.index = sR.index((step<100),:);
    New_sR.A = sR.A(step<100);
    New_sR.W = sR.W(step<100);
    New_sR.whiteningMatrix = sR.whiteningMatrix;
    New_sR.dewhiteningMatrix = sR.dewhiteningMatrix;
    New_sR.cluster = sR.cluster;
    New_sR.projection = sR.projection;
    %%
    sR=icassoExp(sR);
    [iq,A,W,S] = icassoShow(sR,'L',20,'colorlimit',[.8 .9]);
    Iqcount(comp,1) = nanmean(iq);
    Iqcount(comp,2) = nanstd(iq);
    StepCount(comp,1) = nanmean(step);
    StepCount(comp,2) = nanstd(step);
    all(comp) = size(step);
end


