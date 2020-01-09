function dst  = interpolation1d(src, curid, preid, postid)
prewgt  = postid - curid;
postwgt	= curid - preid;

dst = prewgt*src(preid) + postwgt*src(postid);
end