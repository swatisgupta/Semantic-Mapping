function [P, r3, b3 ,g3] = ICP_Wrapper(Scene, FrameN, Points,r,g, b)


for Scene = 1: length(Scene)
    % for Scene = 1:1
    P = []; Q = []; r3 = []; g3 = []; b3 = [];
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
    
    figure, pcshow(P(indices,:),[r3(indices) g3(indices) b3(indices)]/255), drawnow, title('3D Point Cloud After ICP');
    hold on
    A = mean(P,1);
    plot3(A(1), A(2), A(3), 'r.', 'MarkerSize', 15)
    xlabel('x-axis')
    ylabel('y-axis')
    zlabel('z-axis')
    hold on
    sz_val = 1000;
    sz = [sz_val, sz_val, sz_val];
    offset = sz/3;
    %     plot3(offset(1), offset(2), offset(3), 'r.', 'MarkerSize', 15)
    %     plotcube(sz, A + offset, .4, [1 0 0]);
    view([0,0]);
    pause()
end

end