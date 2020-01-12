% Reference
% Linear Interpolation
% https://en.wikipedia.org/wiki/Linear_interpolation
function dst  = interpolation2d(src, pcurid, pn)

dst = 0;

curidy = pcurid(1);
curidx = pcurid(2);

ny = pn(1);
nx = pn(2);

if (curidy < 1 || curidx < 1 || curidy > ny || curidx > nx)
    return ;
end

preidy	= floor(curidy);
postidy	= preidy + 1;

preidx 	= floor(curidx);
postidx	= preidx + 1;

prewgty	= postidy - curidy;
postwgty= curidy - preidy;

prewgtx = postidx - curidx;
postwgtx= curidx - preidx;

dst = prewgtx*(prewgty*src(preidy, preidx) + postwgty*src(postidy, preidx)) + ...
    postwgtx*(prewgty*src(preidy, postidx) + postwgty*src(postidy, postidx));

end