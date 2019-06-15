clear;
clc;



dicet=0;
for i=1:15
%       original=imread('training/train001.tif');
%       groundtruth=imread('training/manseg_train001.tif');
    if (i<=9)
        original=imread("training/train00"+i+".tif");
        groundtruth=imread("training/manseg_train00"+i+".tif");
    else
        original=imread("training/train0"+i+".tif");
        groundtruth=imread("training/manseg_train0"+i+".tif");
    end
    
    original(original<72)=0;
    original(original>180)=250;
    
    figure;
    imshow(original);

    figure;
    imshow(groundtruth);
    %k-means segmantation to 5 clusters
    numberOfClusters = 5;
    [L,Centers] = imsegkmeans(original,numberOfClusters );

    %use only 2nd and fourth clusters
    BW=logical(zeros(size(original,1),size(original,2)));
    for cnumber=1:numberOfClusters 
        if bwarea(L==cnumber)<numel(original)/10
            BW = BW | (L==cnumber);
           % fprintf("%d",cnumber);
        end
    end

%     figure;
%     imshow((L==1));
%     figure;
%     imshow((L==2));
%     figure;
%     imshow((L==3));
%     figure;
%     imshow((L==4));
%     figure;
%     imshow((L==5));
%     
    
%     figure;
%     imshow(BW);

    %remove areas that are smaller than 300 pixels
    BW2 = bwareaopen(BW, 200);
%     figure;
%     imshow(BW2);
    

    %fill holes
    BW3 = imfill(BW2,'holes');
    
%     figure;
%     imshow(BW3);

%     %close areas
    se = strel('disk',26);
    BW4 = imclose(BW3,se);
% 
% %     figure;
% %     imshow(BW3);
    figure;
    imshow(BW4);
%     
% 
% 
    similarity = dice(groundtruth,BW4);
    dicet = dicet + similarity ;
%         fprintf("Image #%d, dice similarity: %.2f \n",i,similarity);
       
%         

end
% fprintf("setting %d %d %d dice similarity: %.2f \n",iic,iih,iia,dicet);

