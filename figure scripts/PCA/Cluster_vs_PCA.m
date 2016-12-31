%%
% run this again, use M_0 instead of CellResp (stimrange)
M = getappdata(hfig,'M'); % load A0.7
gIX = getappdata(hfig,'gIX');
numClus = length(unique(gIX));

M_0 = getappdata(hfig,'M_0');
tic;
[coeff,score,latent,tsquared,explained,mu] = pca(M_0); % ~52 sec on linux
toc

im = coeff;
im = im.*repmat(explained',size(coeff,1),1);
figure;
imagesc(im(:,1:numClus))
topPCs = coeff(:,1:numClus);

%% GLM fit

clusmeans = FindClustermeans(gIX,M);
C_betas = cell(1,2);
C_rsq = cell(1,2);
C_bases = {clusmeans,topPCs'};

M_this = M_0;%M;

for i_model = 1:2
    bases = C_bases{i_model};
    range_cell = 1:size(M_this);%1:100:size(M_0,1);
    M_betas = zeros(140,length(range_cell));
    M_rsq = zeros(1,length(range_cell));
    tic
    for i_count = 1:length(range_cell),
        i_cell = range_cell(i_count);
        X = [ones(size(bases,2),1),bases'];
        y = M_this(i_cell,:)';
        
        [b,~,~,~,stat] = regress(y,X);
        M_betas(:,i_count) = b;
        M_rsq(:,i_count) = stat(1);
    end
    toc
    C_betas{i_model} = M_betas;
    C_rsq{i_model} = M_rsq;
end

%% plot betas, given cluster rank
im = M;
[~,I_clus] = sort(gIX);
im = im(I_clus,:);

figure;
m = [];

for i = 1:2
    M_betas = C_betas{i};
%     M_rsq = C_rsq{i};
%     m{i} = M_betas(:,find(M_rsq > thres_rsq));
%     [~,IX] = sort(max(m{i},[],1),'descend');
%     m_srt{i} = m{i}(:,IX);
%     [~,IX] = sort(max(m_srt{i},[],2),'descend');
%     m_srt{i} = m_srt{i}(IX,:);
    
    subplot(1,2,i)
    imagesc(M_betas(:,I_clus))
    colormap jet
end

%% plot max beta trace, given cluster rank

figure;

for i = 1:2
    M_betas = C_betas{i};
    A = M_betas(:,I_clus);
    [~,IX] = max(abs(A),[],1);
    subplot(1,2,i)
    plot(IX,'.')
end

%% rank cells based on max beta only! (not knowing cluster assignment)

figure;
m = [];

for i = 1:2
    M_betas = C_betas{i};
%     M_rsq = C_rsq{i};
    %     m{i} = M_betas(:,find(M_rsq > thres_rsq));
    [~,IX_raw] = max(abs(M_betas),[],1);
    [a,b]=sort(IX_raw);
    
    subplot(1,2,i)
    imagesc(M_betas(:,b))
    colormap jet
end




% A = M_betas(:,I_clus);
% A2 = A;
% for i=1:length(gIX),
%     T(i) = A2(gIX_srt(i),i);% = 100;
% end
% figure;imagesc(A)
% colormap jet
% 
% [~,IX] = max(A,[],1);
