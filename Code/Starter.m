%% CMSC 733: Project 5 Helper Code
% Written by: Nitin J. Sanket (nitinsan@terpmail.umd.edu)
% PhD in CS Student at University of Maryland, College Park
% Acknowledgements: Bhoram Lee of University of Pennsylvania for help with depthToCloud function

clc
clear all
close all

single = 0;
multiple = 1;
%% Setup Paths and Read RGB and Depth Images

if single == 1
    Path = '../Dataset/SingleObject/'; 
    singleScenes = [0, 1 , 2, 6, 8, 12, 22, 23];
    FrameN = [390, 35, 376, 414, 460, 373, 373, 385];
    ImName = {'frame', 'image','frame','frame','frame','frame','frame','frame'};
    TH = [30,15,40,30,40,40,40,40];
    InR = [0.2,0.2,0.20,0.20,0.2,0.2,0.2,0.2];
    for SceneNum = 2: length(singleScenes) 
       SceneName = sprintf('%0.3d', singleScenes(SceneNum));
       Points = []; r1 = []; g1 = []; b1 = [];
       Opoints = []; Or = []; Og = []; Ob = [];
     
       %for i = 1:FrameN(SceneNum)
       for i = 1:16        
         FrameNum = num2str(i);
         f1 = sprintf('scene_%s/frames/%s_%s_rgb.png',SceneName,ImName{SceneNum},FrameNum);
         f2 = sprintf('scene_%s/frames/%s_%s_depth.png',SceneName,ImName{SceneNum},FrameNum);
         if ~exist(fullfile(Path, f1), 'file') || ~exist(fullfile(Path, f2), 'file')
            continue;
         end     
 
         I = imread([Path,'scene_',SceneName,'/frames/',ImName{SceneNum},'_',FrameNum,'_rgb.png']);
         ID = imread([Path,'scene_',SceneName,'/frames/',ImName{SceneNum},'_',FrameNum,'_depth.png']);

         %% Extract 3D Point cloud
        [pcx, pcy, pcz, r, g, b, D_, X, Y,validInd] = depthToCloud_full_RGB(ID, I, './params/calib_xtion.mat');
        Pts = [pcx pcy pcz];
        Opoints = [Opoints; Pts];
        Or= [Or; r];
        Og= [Og; g];
        Ob= [Ob; b];
        maxIter = 100;
        T = TH(SceneNum); %20
        IR = InR(SceneNum);
        M = ObjectDetectionRNSAC(Pts(:,:), T, maxIter, IR);
        if ~isempty(M) 
            P = Pts(M,:);
            r2 =  r(M);
            g2 =  g(M);
            b2 =  b(M);
            figure, pcshow(P,[r2 g2 b2]/255), drawnow, title('3D Point Cloud');
        else 
            continue;
        end  
        ObjCld{SceneNum,i} =  ObjectDetectionRNSAC(P(:,:), T, maxIter, IR);
        if ~isempty(ObjCld{SceneNum,i})    
            Points = [Points; P(cell2mat(ObjCld(SceneNum,i)),:)];
            r1 = [r1; r2(cell2mat(ObjCld(SceneNum,i)))];
            g1 = [g1; g2(cell2mat(ObjCld(SceneNum,i)))];
            b1 = [b1; b2(cell2mat(ObjCld(SceneNum,i)))];
            pcshow(Points,[r1 g1 b1]/255), drawnow, title('3D Point Cloud');
        end
     end
    %% Display Images and 3D Points
    close all;
    figure,
    subplot 121
    imshow(I);
    title('RGB Input Image');
    subplot 122
    imagesc(ID);
    title('Depth Input Image');
 
    figure, pcshow(Points,[r1 g1 b1]/255), drawnow, title('3D Point Cloud');
    figure, pcshow(Opoints,[Or Og Ob]/255), drawnow, title('3D Point Cloud');
  end
end

if multiple == 1
   Path = '../Dataset/MultipleObjects/'; 
   multipleScenes = [25, 35 , 40, 44, 50];
   FrameN = [558, 468, 528, 556, 425];
   TH = [30, 40, 40, 30, 30];
   InR = [0.3, 0.4, 0.3, 0.2, 0.3];
   for SceneNum = 4:4 
    SceneName = sprintf('%0.3d', multipleScenes(SceneNum));   
    MOpts = []; MOr = []; MOg = []; MOb =[];   
    Points = []; r1 = []; g1 = []; b1 =[];   
    for i = 10:16        
      FrameNum = num2str(i);
      f1 = sprintf('scene_%s/frames/frame_%s_rgb.png',SceneName,FrameNum);
      f2 = sprintf('scene_%s/frames/frame_%s_depth.png',SceneName,FrameNum);
      if ~exist(fullfile(Path, f1), 'file') || ~exist(fullfile(Path, f2), 'file')
       continue;
      end     
      I = imread([Path,'scene_',SceneName,'/frames/frame_',FrameNum,'_rgb.png']);
      ID = imread([Path,'scene_',SceneName,'/frames/frame_',FrameNum,'_depth.png']);

      %% Extract 3D Point cloud
      [pcx, pcy, pcz, r, g, b, D_, X, Y,validInd] = depthToCloud_full_RGB(ID, I, './params/calib_xtion.mat');
      Pts = [pcx pcy pcz];
      MOpts = [MOpts; Pts];
      MOr= [MOr; r];
      MOg= [MOg; g];
      MOb= [MOb; b];
      maxIter = 100;
      T = TH(SceneNum); 
      IR = InR(SceneNum);
      M = ObjectDetectionRNSAC(Pts(:,:), T, maxIter, IR);
      if ~isempty(M) 
         P = Pts(M,:);
         r2 =  r(M);
         g2 =  g(M);
         b2 =  b(M);
         figure, pcshow(P,[r2 g2 b2]/255), drawnow, title('3D Point Cloud');
      else 
            continue;
      end  
      MObjCld{SceneNum,i} =  ObjectDetectionRNSAC(P(:,:), T, maxIter, IR);
      if ~isempty(MObjCld{SceneNum,i})    
            Points = [Points; P(cell2mat(MObjCld(SceneNum,i)),:)];
            r1 = [r1; r2(cell2mat(MObjCld(SceneNum,i)))];
            g1 = [g1; g2(cell2mat(MObjCld(SceneNum,i)))];
            b1 = [b1; b2(cell2mat(MObjCld(SceneNum,i)))];
            pcshow(Points,[r1 g1 b1]/255), drawnow, title('3D Point Cloud');
      end
    end
    %% Display Images and 3D Points
    close all;
    figure,
    subplot 121
    imshow(I);
    title('RGB Input Image');
    subplot 122
    imagesc(ID);
    title('Depth Input Image');
 
    figure, pcshow(Points,[r1 g1 b1]/255), drawnow, title('3D Point Cloud');
    figure, pcshow(MOpts,[MOr MOg MOb]/255), drawnow, title('3D Point Cloud');
   end 
end


   
