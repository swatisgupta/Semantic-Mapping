function p = filter_pc(pc, inliers)
p = pc.Location;
p = double(p(inliers,:));
end