function [R, t] = ICP_Point2Plane(p, q, Points, ObjCld)

% Convert p and q to poinCloud structure form
pc1 = pointCloud(Points(cell2mat(ObjCld(3,1)),:));
pc2 = pointCloud(Points(cell2mat(ObjCld(3,2)),:));
pc1_location = pc1.Location;

% Compute Correspondences and remove outliers
[indices, dists] = multiQueryKNNSearchImpl(pc2, pc1_location, 1);
[inliers_pc1, inliers_pc2, inliers_dist] = remove_outliers(pc1, indices, dists);


% Define Number of points
N = length(inliers_pc1);

% Compute normals and filter them
n = pcnormals(pc2);
n = n(inliers_pc2,:);

% Filtered pointclouds in double format
p = ;
q = ;

% ICP Algorithm
for i = 1:N
    A(i, 6) = [n(i,3)*p(i,2) - n(i,2)*p(i,3), n(i,1)*p(i,3) - n(i,3)*p(i,1)...
        n(i,2)*p(i,1) - n(i,1)*p(i,2), n(i,1), n(i,2), n(i,3)] ;
    
    
    b(i, 1) = n(i,1)*q(i,1) + n(i,2)*q(i,2) + n(i,3)*q(i,3) - n(i,1)*p(i,1)...
        - n(i,2)*p(i,2) - n(i,3)*p(i,3);
end

% Compuet pseudo inverse of A

A_pseudo = pinv(A);

% Solve for x
x = A_pseudo*b;

% Reconstruct R and t from x.

end