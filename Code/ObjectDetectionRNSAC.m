function obPC = ObjectDetectionRNSAC(pts, t, maxIt, IR)  
   iter = 1;
   InlinerRatio = IR +5;
   while iter < maxIt && InlinerRatio >IR
       id = randperm(length(pts),3);
       p1 = pts(id(1),:); 
       p2 = pts(id(2),:); 
       p3 = pts(id(3),:); 
       
       AB = p2 - p1;
       AC = p3 - p1;
       N = cross(AB, AC);
       d = -p1*N';
       F = [ N, d];
       inliners = [];
       count = 0;
       for i = 1:length(pts)
           P = [pts(i,:) 1];
           FX = F*P';
           FX = abs(FX/norm(N));
           if( FX <= t)
               inliners = [inliners; i];
               count = count + 1;
           end        
       end    
       InlinerRatio = count/length(pts);
       iter = iter + 1;
   end    
   obPC = inliners;
   %obPC = post_processing(inliners, pts);
end


function OB = post_processing(inliners, pts)
    OB = [];
    mean = sum(inliners)/ size(inliners, 1);
    for i = 1:length(pts)
        distance = norm(pts(i,:) - mean);
        if distance < 0.2 * length(pts)
            OB = [OB; pts(i,:)];
        end    
    end    
end