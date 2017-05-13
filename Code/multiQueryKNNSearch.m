function [indices, dists] = multiQueryKNNSearch(pc2, pc1, K)
  
pc1_location = pc1.Location;
pc2_location = pc2.Location;

[indices, dists] = knnsearch(pc2_location, pc1_location, 'k', K);
end