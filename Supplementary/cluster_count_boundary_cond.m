function [files]=cluster_count_boundary_cond(file_loc)

    files=dir(file_loc); %Read all files in the directory
    
        
    for file=files' %Loop through all files in the Output/masks directory created from RCNN 
       	cell_counts=[]
	idx_flag=[];       
        [X,cmap] = imread(file.name); %Read the TIF file
        X=imfill(X,"holes"); %Fill holes in the object 
        sz=size(X,1);
        stats=regionprops(X,'Centroid'); %Identify the centroid of the objects
        centroid=cat(1,stats.Centroid); 
        idx=dbscan(centroid,100,1); %Use DBSCAN spatial clustering to segment clusters
	
	if(size(centroid,1)>1)
        	for i=1:length(centroid);
            		if((centroid(i,1)<50 || centroid(i,1)>sz-50) || (centroid(i,2)<50 || centroid(i,2)>sz-50))
    				idx_flag(end+1)=idx(i);
        	    	end
        	end
	end
       
        idx_correct=idx(~(ismember(idx,idx_flag)));
        counts=groupcounts(idx_correct); %count number of cells in each cluster
        cell_counts=cat(1,cell_counts,counts);
    
    	arr=table()
    	arr.counts=cell_counts
    	tab_name=file.name(~ismember(file.name,'.tif'))+"_counts.csv"
    	writetable(arr,tab_name)
    end
    
end
