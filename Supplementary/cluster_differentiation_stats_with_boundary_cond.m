function [files]=cluster_count_with_boundary_reject(file_loc)
   
    files=dir(file_loc); %Read all files in the directory
    
    for file=files' %Loop through all files in the Output/masks directory created from RCNN 
        
        cfp=file.name;
        yfp=cfp(1:find(cfp=='_')-1);
        yfp_loc=strcat('/Users/piyushnanda/Documents/PhD_MurrayLab/EMC/Data/eEMC014/Output/YFP/',yfp,'_w4Camera YFP.tif');

        mean_list=[];
        state_ratios=[];
        idx_flag=[];
        [X,cmap1] = imread(file.name); %Read the TIF file
        [yfp,cmap2]=imread(yfp_loc);
        [L,n]=bwlabel(X); %Label cells in the image 
        sz=size(X,1);
        % X=imfill(X,"holes"); %Fill holes in the object 
        
        stats=regionprops(X,'Centroid'); %Identify the centroid of the objects
        centroid=cat(1,stats.Centroid);
        idx=dbscan(centroid,100,1); %Use DBSCAN spatial clustering to segment clusters
        
        for i=1:length(centroid);
            if((centroid(i,1)<50 || centroid(i,1)>sz-50) || (centroid(i,2)<50 || centroid(i,2)>sz-50))
                idx_flag(end+1)=idx(i);
            end
        end
        
        thrs=mean(yfp((L==0)))+10;
        yellow_on=zeros(length(centroid),1);
        
        for i=1:length(centroid)
            m=mean(yfp(L==i));
            mean_list(i)=m;
            if (m>=thrs)
                yellow_on(i)=1;
            end
        end
        
        idx_correct=idx(~(ismember(idx,idx_flag)));
        yellow_on_correct=yellow_on(~(ismember(idx,idx_flag)));
        
        tab = table();
        tab.ids=idx_correct;
        tab.yellow=yellow_on_correct;
        tab_counts=groupsummary(tab,'ids','sum');
        ratios=tab_counts.sum_yellow./tab_counts.GroupCount;
        state_ratios=cat(1,state_ratios,ratios);

        arr=table();
        arr.counts=state_ratios;
        tab_name=file.name(~ismember(file.name,'.tif'))+"_counts.csv";
        writetable(arr,tab_name)
    end
    
end