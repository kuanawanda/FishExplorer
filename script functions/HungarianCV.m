function [score,im1,cIX_int,gIX_A,gIX_B] = HungarianCV(cIX1,cIX2,gIX1,gIX2,isPlotFig,name)
numClus1 = length(unique(gIX1));
numClus2 = length(unique(gIX2));

% CV by matching cell ID's
CostMat = zeros(numClus1,numClus2);
for i = 1:numClus1,
    for j = 1:numClus2,
        A = cIX1(gIX1==i);
        B = cIX2(gIX2==j);
        CostMat(i,j) = -length(intersect(A,B));
    end
end

assignment1 = munkres(CostMat);
range = 1:numClus1;
IX = find(assignment1>0);
im1 = -CostMat(range(IX),assignment1(IX));

if exist('isPlotFig','var'),
    if isPlotFig,
        figure;
        imagesc(im1)
        if exist('name','var'),
            title(name);
        end
        colormap(bluewhitered)
        axis equal; axis tight;axis xy
    end
end

score = trace(im1)/sum(sum(im1));

%%
I = range(IX);
J = assignment1(IX);

cIX_int = [];
gIX_A = [];
gIX_B = [];

for i = 1:length(I),
    for j = 1:length(J),
        if CostMat(I(i),J(j))~=0,
            
            A = cIX1(gIX1==I(i));
            B = cIX2(gIX2==J(j));
            C = intersect(A,B);
            cIX_int = [cIX_int;C]; %#ok<*AGROW>
            gIX_A = [gIX_A;I(i)*ones(size(C))];
            gIX_B = [gIX_B;J(j)*ones(size(C))];
        end
    end
end

end

%% 
% set(gcf,'Position',[50,100,250,250])
% axis xy
% title('Cross-validation')
% xlabel('PT+OMR clusters')
% ylabel('OMR clusters')