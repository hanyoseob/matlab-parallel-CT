% Transform from Index in [0, nDct] to Position in [-(dDct*nDct)/2, +(dDct*nDct)/2]
function pos = id2pos(id, d, n)

pos = (id - (n - 1)/2)*d;

end