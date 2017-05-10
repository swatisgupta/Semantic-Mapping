%% CMSC 733: Project 5 Helper Code
% Written by: Nitin J. Sanket (nitinsan@terpmail.umd.edu)
% PhD in CS Student at University of Maryland, College Park
% Acknowledgements: Bhoram Lee of University of Pennsylvania for help with depthToCloud function

clc
clear all
close all

%% Setup Paths and Read RGB and Depth Images
Path = '../Dataset/SingleObject/'; 

singleScenes = [0, 1 , 2, 6, 8, 12, 22, 23];
FrameN = [390, 35, 376, 414, 460, 373, 373, 385];
ImName = {'frame', 'image','frame','frame','frame','frame','frame','frame'};
TH = [40,40,40,40,40,40,40,40];
InR = [0.2,0.2,0.20,0.20,0.2,0.2,0.2,0.2];
for SceneNum = 4: length(singleScenes) 
 SceneName = sprintf('%0.3d', singleScenes(SceneNum));
 Points = [];
 r1 = [];
 g1 = [];
 b1 = [];
 Opoints = [];
 Or = [];
 Og = [];
 Ob = [];
 %for i = 1:FrameN(SceneNum)
 %
 for i = 1:16    
  FrameNum = num2str(i);
  I = imread([Path,'scene_',SceneName,'/frames/',ImName{SceneNum},'_',FrameNum,'_rgb.png']);
  ID = imread([Path,'scene_',SceneName,'/frames/',ImName{SceneNum},'_',FrameNum,'_depth.png']);

%% Extract 3D Point cloud
% Inputs:
% ID - the depth image
% I - the RGB image
% calib_file - calibration data path (.mat) 
%              ex) './param/calib_xtion.mat'
%              
% Outputs:
% pcx, pcy, pcz    - point cloud (valid points only, in RGB camera coordinate frame)
% r,g,b            - color of {pcx, pcy, pcz}
% D_               - registered z image (NaN for invalid pixel) 
% X,Y              - registered x and y image (NaN for invalid pixel)
% validInd	   - indices of pixels that are not NaN or zero
% NOTE:
% - pcz equals to D_(validInd)
% - pcx equals to X(validInd)
% - pcy equals to Y(validInd)

 [pcx, pcy, pcz, r, g, b, D_, X, Y,validInd] = depthToCloud_full_RGB(ID, I, './params/calib_xtion.mat');
  Pts = [pcx pcy pcz];
  Opoints = [Opoints; Pts];
  Or= [Or; r];
  Og= [Og; g];
  Ob= [Ob; b];
%  [~,X] = sort(Pts(:,3));
%  Pts = Pts(X,:);
 maxIter = 100;
 T = TH(SceneNum); %20
 IR = InR(SceneNum);
 M = ObjectDetectionRNSAC(Pts(:,:), T, maxIter, IR);
 if ~isempty(M) 
   P = Pts(M,:);
   r2 =  r(M);
   g2 =  g(M);
   b2 =  b(M);
   figure,
 pcshow(P,[r2 g2 b2]/255);
 drawnow;
 title('3D Point Cloud');
 else 
    P = [];
    r2 =[];
    g2 =[];
    b2 = [];
    continue;
 end  

  ObjCld{SceneNum,i} =  ObjectDetectionRNSAC(P(:,:), T, maxIter, IR);
  if ~isempty(ObjCld{SceneNum,i})    
   Points = [Points; P(cell2mat(ObjCld(SceneNum,i)),:)];
   r1 = [r1; r2(cell2mat(ObjCld(SceneNum,i)))];
   g1 = [g1; g2(cell2mat(ObjCld(SceneNum,i)))];
   b1 = [b1; b2(cell2mat(ObjCld(SceneNum,i)))];
   
   pcshow(Points,[r1 g1 b1]/255);
   drawnow;
   title('3D Point Cloud');
  end
 end
%% Display Images and 3D Points
% Note this needs the computer vision toolbox: you'll have to run this on
% the server


 close all;
 figure,
 subplot 121
 imshow(I);
 title('RGB Input Image');
 subplot 122
 imagesc(ID);
 title('Depth Input Image');
 
 figure,
 pcshow(Points,[r1 g1 b1]/255);
 drawnow;
 title('3D Point Cloud');
 
  figure,
 pcshow(Opoints,[Or Og Ob]/255);
 drawnow;
 title('3D Point Cloud');
end

Path = '../Dataset/MultipleObject/'; 
multipleScenes = [25, 35 , 40, 44, 50];
FrameN = [558, 468, 528, 556, 425];
