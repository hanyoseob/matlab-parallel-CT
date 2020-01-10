% Transform from Position in [-(dDct*nDct)/2, +(dDct*nDct)/2] to Index in [0, nDct]
function id = pos2id(pos, d, n)

id  = pos/d + (n - 1)/2;

end