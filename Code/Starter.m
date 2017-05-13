%% CMSC 733: Project 5 Helper Code
% Written by: Nitin J. Sanket (nitinsan@terpmail.umd.edu)
% PhD in CS Student at University of Maryland, College Park
% Acknowledgements: Bhoram Lee of University of Pennsylvania for help with depthToCloud function

clc
clear all
close all

single = 1;
multiple = 0;
%% Setup Paths and Read RGB and Depth Images

if single == 1
    Path = '../Dataset/SingleObject/'; 
    singleScenes = [0, 1 , 2, 6, 8, 12, 22, 23];
    FrameN = [390, 35, 376, 414, 460, 373, 373, 385];
    ImName = {'frame', 'image','frame','frame','frame','frame','frame','frame'};
    TH = [30,15,40,30,30,30,30,30];
    InR = [0.2,0.2,0.20,0.20,0.2,0.2,0.2,0.2];
    [Points, r1, g1, b1] = isolate_background(Path, singleScenes, FrameN, ImName, TH, InR);
    [P, r, b ,g] = ICP_Wrapper(3, FrameN, Points,r1,g1, b1);
    
end

if multiple == 1
    Path = '../Dataset/MultipleObjects/'; 
    multipleScenes = [25, 35 , 40, 44, 50];
    FrameN = [558, 468, 528, 556, 425];
    ImName = {'frame','frame','frame','frame','frame'};
    TH = [30, 40, 40, 30, 30];
    InR = [0.3, 0.4, 0.3, 0.2, 0.3];
    [Points, r1, g1, b1] = isolate_background(Path, multipleScenes, FrameN, ImName, TH, InR);  
end

