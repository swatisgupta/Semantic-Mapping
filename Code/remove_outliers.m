function [inliers_indices_pc1, inlier_indices_pc2, inliers_dist] = remove_outliers(pc1, indices, dists)

keepInlier_pc1 = false(pc1.Count, 1);
[~, idx] = sort(dists);
keepInlier_pc1(idx(1:pc1.Count)) = true;
inliers_indices_pc1 = find(keepInlier_pc1);
inlier_indices_pc2 = indices(keepInlier_pc1);
inliers_dist = dists(keepInlier_pc1);



end