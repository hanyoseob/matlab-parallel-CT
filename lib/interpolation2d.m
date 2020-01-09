
function dst  = interpolation2d(src, curidy, preidy, postidy, curidx, preidx, postidx)
prewgty     = postidy - curidy;
postwgty	= curidy - preidy;

prewgtx     = postidx - curidx;
postwgtx	= curidx - preidx;

dst = prewgtx*(prewgty*src(preidy, preidx) + postwgty*src(postidy, preidx)) + ...
    postwgtx*(prewgty*src(preidy, postidx) + postwgty*src(postidy, postidx));
end