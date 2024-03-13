function [Patameter comp] = ChooseComp(data,runs,Comp,Result_file,Method)
% data: the data(Row<Column) to be processed,
% runs: the runs of fastICA
% maxComp: max component we set to run ICA
% nolinear: nolinear function choose
File = Result_file;
mkdir(File);
%%
[coeff, score, latent] = princomp(data);
%%
%x0 = bsxfun(@minus,data,mean(data,1));
%[n,p] = size(x0);
%[U,sigma,coeff] = svd(x0,0);
%sigma = diag(sigma);
%score = U;
%sigma = sigma./sqrt(n-1);
%latent = sigma;
%%
save([File 'PCA'],'coeff','score','latent','-v7.3');
mkdir([File 'Iq/']);
mkdir([File 'sR/']);
mkdir([File 'A/']);
mkdir([File 'W/']);
mkdir([File 'S/']);
mkdir([File 'step/']);
for comp = Comp
    X=score(:,1:comp)';
%       X=score(1:comp,:)';
    switch Method
        case 'FastICA'
        [sR,step]=icassoEst('both', X,runs, 'lastEig', comp, 'g','tanh', ...
        'approach', 'symm');
        case 'InfomaxICA'
        [sR step]=icassoEst_infomaxICA('both',X ,runs, 'lastEig', comp, 'g', 'tanh', ...
             'approach', 'symm');
        otherwise 
            disp('Unknow method.');
    end
    %%
%     New_sR.mode = sR.mode;
%     New_sR.signal = sR.signal;
%     New_sR.fasticaoptions = sR.fasticaoptions;
%     tmp = sum(step<100);
%     New_sR.index = sR.index(1:comp*tmp,:);
%     New_sR.A = sR.A(step<100);
%     New_sR.W = sR.W(step<100);
%     New_sR.whiteningMatrix = sR.whiteningMatrix;
%     New_sR.dewhiteningMatrix = sR.dewhiteningMatrix;
%     New_sR.cluster = sR.cluster;
%     New_sR.projection = sR.projection;
    %%
%     if sum(step<100)>0
        sR=icassoExp(sR);
        [iq,A,W,S] = icassoShow(sR,'L',comp,'colorlimit',[.8 .9]);
        save([File 'sR/',int2str(comp)],'sR');
        save([File 'A/',int2str(comp)],'A');
        save([File 'W/',int2str(comp)],'W');
        save([File 'S/',int2str(comp)],'S');
        save([File 'step/',int2str(comp)],'step');
        save([File 'Iq/',int2str(comp)],'iq');
        Patameter(comp,1) = nanmean(iq);
        Patameter(comp,2) = nanstd(iq);
        Patameter(comp,3) = nanmean(step(step<100));
        Patameter(comp,4) = nanstd(step(step<100));
        Patameter(comp,5) = size(step(step<100),2);
        Patameter(comp,6) = sum(latent(1:comp))/sum(latent);
%     else
%         break;
%     end
end
