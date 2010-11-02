function layerAddSublayer(l, s) {
    l.sublayers.push(s);
    return s.parent = l;
};
function layerRender(l) {
    CTX.fillStyle = l.fillStyle;
    CTX.strokeStyle = l.strokeStyle;
    if (l.render) {
        l.render();
    } else {
        var bounds13 = { origin : { x : l.bounds.origin.x * 1, y : l.bounds.origin.y * 1 }, size : { width : l.bounds.size.width * 1, height : l.bounds.size.height * 1 } };
        if (typeof l.contents == 'string') {
            CTX.fillText(l.contents, bounds13.origin.x, bounds13.origin.y);
        } else {
            CTX.fillRect(bounds13.origin.x, bounds13.origin.y, bounds13.size.width, bounds13.size.height);
        };
    };
    for (var i in l.sublayers) {
        layerRender(l.sublayers[i]);
    };
};