function [Points, r, g, b] = isolate_background(Path, Scenes, FrameN, ImName, TH, InR)

  for SceneNum = 1: 3 %length(singleScenes) 
       SceneName = sprintf('%0.3d', Scenes(SceneNum));
       Opoints = []; Or = []; Og = []; Ob = [];
     
      % for i = 1:FrameN(SceneNum)
      for i = 1:8        
         FrameNum = num2str(i);
         f1 = sprintf('scene_%s/frames/%s_%s_rgb.png',SceneName,ImName{SceneNum},FrameNum);
         f2 = sprintf('scene_%s/frames/%s_%s_depth.png',SceneName,ImName{SceneNum},FrameNum);
         if ~exist(fullfile(Path, f1), 'file') || ~exist(fullfile(Path, f2), 'file')
            continue;
         end     
 
         I = imread([Path,'scene_',SceneName,'/frames/',ImName{SceneNum},'_',FrameNum,'_rgb.png']);
         ID = imread([Path,'scene_',SceneName,'/frames/',ImName{SceneNum},'_',FrameNum,'_depth.png']);

         %% Extract 3D Point cloud
        [pcx, pcy, pcz, r1, g1, b1, D_, X, Y,validInd] = depthToCloud_full_RGB(ID, I, './params/calib_xtion.mat');
        Pts = [pcx pcy pcz];
        Opoints = [Opoints; Pts];
        Or= [Or; r1];
        Og= [Og; g1];
        Ob= [Ob; b1];
        maxIter = 100;
        T = TH(SceneNum); %20
        IR = InR(SceneNum);
        M = ObjectDetectionRNSAC(Pts(:,:), T, maxIter, IR);
        if ~isempty(M) 
            P = Pts(M,:);
            r2 =  r1(M);
            g2 =  g1(M);
            b2 =  b1(M);
            %figure, pcshow(P,[r2 g2 b2]/255), drawnow, title('3D Point Cloud');
        else 
            continue;
        end  
        ObjCld{SceneNum,i} =  ObjectDetectionRNSAC(P(:,:), T, maxIter, IR);
        if ~isempty(ObjCld{SceneNum,i})    
            Points{SceneNum,i} = P(cell2mat(ObjCld(SceneNum,i)),:);
            r{SceneNum,i} =  r2(cell2mat(ObjCld(SceneNum,i)));
            g{SceneNum,i} = g2(cell2mat(ObjCld(SceneNum,i)));
            b{SceneNum,i} = b2(cell2mat(ObjCld(SceneNum,i)));
            figure, pcshow(cell2mat(Points(SceneNum,i)),[cell2mat(r(SceneNum,i)) cell2mat(g(SceneNum,i)) cell2mat(b(SceneNum,i))]/255), drawnow, title('3D Point Cloud');
        end
     end
    %% Display Images and 3D Points
%     close all;
%     figure,
%     subplot 121
%     imshow(I);
%     title('RGB Input Image');
%     subplot 122
%     imagesc(ID);
%     title('Depth Input Image');
 
    %figure, pcshow(cell2mat(Points(SceneNum,:)),[cell2mat(r1(SceneNum,:)) cell2mat(g1(SceneNum,:)) b1(SceneNum,:)]/255), drawnow, title('3D Point Cloud');
    %figure, pcshow(Opoints,[Or Og Ob]/255), drawnow, title('3D Point Cloud');
    
  end
  
  
end  