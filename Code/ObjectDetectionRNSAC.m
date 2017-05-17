function obPC = ObjectDetectionRNSAC(pts, t, maxIt, IR)  
   iter = 1;
   inliners1 = [];
   InlinerRatio = 1;
   len = length(pts);
    while iter < maxIt && InlinerRatio > IR && length(pts) > 3    
      id = randperm(length(pts),3);
       p1 = pts(id(1),:); 
       p2 = pts(id(2),:); 
       p3 = pts(id(3),:); 
      
       AB = p2 - p1;
       AC = p3 - p1;
       N = cross(AB, AC);
       d = -p1*N';
       F = [ N, d];
       P = pts*N'+ d;
       P = abs(P./norm(N));
       count = 0;
       inliners = [];
      
       for i = 1:length(pts)
           FX = P(i,:);
           if( FX > t)
               inliners = [inliners; i];
               count = count + 1;
                
           end    
       end  
       if len > length(inliners)
           inliners1 = inliners;
           len = length(inliners);
       end    
       InlinerRatio =  count/length(pts);
       iter = iter + 1;
    end
    %obPC = inliners1;
    obPC = post_processing(inliners1, pts);
end


function final_idx = post_processing(inliners, pts)
    OB = [];
    if ~isempty(inliners)
     minpts = sort(pts(inliners,:));
     maxD = minpts(1,:) - minpts(end,:);
     maxD = sqrt(sum(maxD.^2));
     mean = sum(pts(inliners,:))/ size(inliners, 1);
     for i = 1:length(inliners)
        distance = norm(pts(inliners(i),:) - mean);
        if distance< 0.4* maxD
            OB = [OB; inliners(i)];
        end    
     end
    end
    indices = find(pts(:,3) < 1000);
    final_idx = intersect(indices, OB);
    
end


