clc 
clear all
load state.mat

points1 = Points(cell2mat(ObjCld(3,1)),:);
points2 = Points(cell2mat(ObjCld(3,2)),:);
pc1 = pointCloud(Points(cell2mat(ObjCld(3,1)),:));
pc2 = pointCloud(Points(cell2mat(ObjCld(3,2)),:));

tform_sand = pcregrigid(pc2, pc1, 'Metric','pointToPlane','Extrapolate', true);
[R, t] = ICP_Point2Plane(points1, points2,  Points, ObjCld);