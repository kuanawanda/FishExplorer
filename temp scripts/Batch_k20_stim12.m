% batch template
global hm1;
hObject = hm1;

data_masterdir = GetCurrentDataDir();

range_fish =  8:13;
% M_ClusGroup = [2,2,2,2];
% M_Cluster = [1,1,1,1];
const_ClusGroup = 2;
const_Cluster = 2;
% M_fish_set = [1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2]; 

%%
for i = 1:length(range_fish),
    i_fish = range_fish(i);
    disp(i_fish);

    LoadFullFish(hfig,i_fish,1);
    absIX = getappdata(hfig,'absIX');
    
    %% Cluster indexing
    i_ClusGroup = const_ClusGroup;% M_ClusGroup(i);
    i_Cluster = const_Cluster;% M_Cluster(i);
    ClusGroup = VAR(i_fish).ClusGroup{i_ClusGroup};
    numK = ClusGroup(i_Cluster).numK;
    gIX = ClusGroup(i_Cluster).gIX;    
    cIX_abs = ClusGroup(i_Cluster).cIX_abs; % convert absolute index to index used for this dataset
    [~,cIX] = ismember(cIX_abs,absIX);
    
    setappdata(hfig,'cIX',cIX);
            
    for k = 1:2,% stimrange
        setappdata(hfig,'stimrange',k);
        UpdateTimeIndex(hfig);
        f.UpdateIndices(hfig,cIX,gIX,numK);
        
        %% main
        f.edit_kmeans_Callback(hObject);
        clusgroupID = 2;
        name = ['k20_' num2str(k)];
        f.SaveCluster_Direct(hfig,cIX,gIX,name,clusgroupID)
        
    end
end