function [P, r3, b3 ,g3] = ICP_Wrapper(Scene, FrameN, Points,r,g, b)


for Scene = 1: length(Scene)
    % for Scene = 1:1
    P = []; r3 = []; g3 = []; b3 = [];
    % for Scene = 1:1
    disp('------------------------------------------------------------------------------------')
    disp(['Starting Scene ', num2str(Scene)]);
    for i = 2:length(Points)
        %     for i = 2:16
        disp(['Starting ICP for frame ', num2str(i)]);
        
        Pts2 = Points{Scene, i};
        
        if i ~= 1
            Pts1 = Points{Scene,i-1};
        else
            Pts1 = Points{Scene, i};
        end
        
        if (isempty(Pts2) || isempty(Pts1))
            continue;
        end
        
%         ICP algorithm
        [R, T] = ICP_Point2Plane(Pts1, Pts2);
        
        M = T*R;
        Pts = M'*[Pts2 ones(length(Pts2),1)]';
        
        Pts = Pts./Pts(4,:);
        Pts = Pts(1:3,:);
        P = [P; Pts1; Pts'];
        r3 = [r3; r{Scene,i-1}; r{Scene,i}];
        g3 = [g3; g{Scene,i-1}; g{Scene,i}];
        b3 = [b3; b{Scene,i-1}; b{Scene,i}];
    end
    
    figure, pcshow(P,[r3 g3 b3]/255), drawnow, title('3D Point Cloud After ICP');
    pause()
end

end