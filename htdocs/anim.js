function layerAddSublayer(l, s) {
    l.sublayers.push(s);
    return s.parent = l;
};
function layerRender(l) {
    var lx = (l.bounds = { origin : { x : l.bounds.origin.x * 1, y : l.bounds.origin.y * 1 }, size : { width : l.bounds.size.width * 1, height : l.bounds.size.height * 1 } }, l);
    CTX.fillStyle = lx.fillStyle;
    CTX.strokeStyle = lx.strokeStyle;
    CTX.fillRect(lx.bounds.origin.x, lx.bounds.origin.y, lx.bounds.size.width, lx.bounds.size.height);
    for (var i in lx.sublayers) {
        layerRender(lx.sublayers[i]);
    };
};