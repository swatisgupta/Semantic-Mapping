function [R, T] = ICP_Point2Plane( Pts1, Pts2)


% Convert p and q to poinCloud structure form
pc1 = pointCloud(Pts1);
pc2 = pointCloud(Pts2);


% Compute Correspondences and remove outliers
[indices, dists] = multiQueryKNNSearch(pc2, pc1, 1);
[inliers_pc1, inliers_pc2, ~] = remove_outliers(pc1, indices, dists);


% Define Number of points
N = length(inliers_pc1);

% Compute normals and filter them
n = pcnormals(pc2);
n = n(inliers_pc2,:);

% Filtered pointclouds in double format
p = filter_pc(pc1, inliers_pc1);
q = filter_pc(pc2, inliers_pc2);

% ICP Algorithm
for i = 1:N
    A(i, :) = [n(i,3)*p(i,2) - n(i,2)*p(i,3), n(i,1)*p(i,3) - n(i,3)*p(i,1)...
        n(i,2)*p(i,1) - n(i,1)*p(i,2), n(i,1), n(i,2), n(i,3)] ;
    
    
    b(i) = n(i,1)*q(i,1) + n(i,2)*q(i,2) + n(i,3)*q(i,3) - n(i,1)*p(i,1)...
        - n(i,2)*p(i,2) - n(i,3)*p(i,3);
end

% Compuet pseudo inverse of A
A_pseudo = pinv(A);

% Solve for x
x = A_pseudo*b';

% Reconstruct R and t from x.
alpha = x(1);
beta = x(2);
gamma = x(3);
tx = x(4);
ty = x(4);
tz = x(4);

r11 = cos(gamma)*cos(beta);
r12 = -sin(gamma)*cos(alpha) + cos(gamma)*sin(beta)*sin(alpha);
r13 = sin(gamma)*sin(alpha) + cos(gamma)*sin(beta)*cos(alpha);
r21 = sin(gamma)*cos(beta);
r22 = cos(gamma)*cos(alpha) + sin(gamma)*sin(beta)*sin(alpha);
r23 = -cos(gamma)*sin(alpha) + sin(gamma)*sin(beta)*cos(alpha);
r31 = -sin(beta);
r32 = cos(beta)*sin(alpha);
r33 = cos(beta)*cos(alpha);

T = [1 0 0 tx; 0 1 0 ty; 0 0 1 tz; 0 0 0 1];
R = [r11, r12, r13, 0; r21, r22, r23, 0; r31 r32 r33 0; 0 0 0 1];

end