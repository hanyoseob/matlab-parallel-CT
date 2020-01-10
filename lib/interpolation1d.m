function dst  = interpolation1d(src, curid)

preid	= floor(curid);
postid	= preid + 1;

prewgt  = postid - curid;
postwgt	= curid - preid;

dst = prewgt*src(preid) + postwgt*src(postid);
end