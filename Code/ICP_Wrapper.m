function [P, r, b ,g] = ICP_Wrapper(Scene, FrameN, Points,r1,g1, b1)
  P = []; r = []; g = []; b = [];
  
  %for i = FrameN:-1:2
 for i = 3:-1:2   
   if isempty(Points{Scene, i})
        continue;
   end
   
   Pts1 = Points{Scene,i-1};
   Pts2 = Points{Scene, i};   
   
   [R, T] = ICP_Point2Plane(Pts1, Pts2);
   
   M = T*R;
   Pts = M'*[Pts2 ones(length(Pts2),1)]';
   
   if ~isempty(P)
    Ptsp = M'*[P ones(length(P),1)]';
    Ptsp = Ptsp./Ptsp(4,:);
    Ptsp = Ptsp(1:3,:);
   else 
    Ptsp = [];  
   end  
   
   Pts = Pts./Pts(4,:);
   Pts = Pts(1:3,:);
   P = [Ptsp';  Pts'];
   r = [r; r1{Scene,i}];
   g = [g; g1{Scene,i}];
   b = [b; b1{Scene,i}];
 end
  Pts = [Pts; Points{Scene, 1}];
  figure, pcshow(P,[r g b]/255), drawnow, title('3D Point Cloud After ICP');
  
end