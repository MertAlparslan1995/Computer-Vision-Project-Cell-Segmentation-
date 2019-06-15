clear;
clc;



for i=1:19

    if (i<=9)
        original=imread("test/test00"+i+".tif");
    else
        original=imread("test/test0"+i+".tif");
    end
    original(original<72)=0;
    original(original>180)=250;
    figure;
    imshow(original);


    %k-means segmantation to 5 clusters
    numberOfClusters = 5;
    [L,Centers] = imsegkmeans(original,numberOfClusters );

    %use only 2nd and fourth clusters
    BW=logical(zeros(size(original,1),size(original,2)));
    for cnumber=1:numberOfClusters 
        if bwarea(L==cnumber)<numel(original)/(numberOfClusters*2)
            BW = BW | (L==cnumber);
        end
    end

    %remove areas that are smaller than 200 pixels
    BW2 = bwareaopen(BW, 200);

    %fill holes
    BW3 = imfill(BW2,'holes');

    %close areas
    se = strel('disk',26);
    BW4 = imclose(BW3,se);

    % figure;
    % imshow(BW3);
    figure;
    imshow(BW4);
    




    if (i<=9)
        imwrite(BW4,"results/_segresult_test00"+i+".tif");
    else
        imwrite(BW4,"results/_segresult_test0"+i+".tif");
    end        
        

end


