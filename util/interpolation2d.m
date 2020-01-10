% Reference
% Linear Interpolation
% https://en.wikipedia.org/wiki/Linear_interpolation
function dst  = interpolation2d(src, curidy, curidx)

preidy	= floor(curidy);
postidy	= preidy + 1;

preidx 	= floor(curidx);
postidx	= preidx + 1;

prewgty     = postidy - curidy;
postwgty	= curidy - preidy;

prewgtx     = postidx - curidx;
postwgtx	= curidx - preidx;

dst = prewgtx*(prewgty*src(preidy, preidx) + postwgty*src(postidy, preidx)) + ...
    postwgtx*(prewgty*src(preidy, postidx) + postwgty*src(postidy, postidx));
end