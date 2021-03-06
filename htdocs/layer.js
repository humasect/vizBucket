function layerAddSublayer(l, s) {
    l.sublayers.push(s);
    return s.parent = l;
};
function sublayerNamed(l, name) {
    var found = null;
    for (var __i in l.sublayers) {
        var s = l.sublayers[__i];
        if (s.name == name) {
            found = s;
        };
    };
    return found;
};
function layerRender(l) {
    if (l.contents != 'empty') {
        CTX.fillStyle = l.fillStyle;
        CTX.strokeStyle = l.strokeStyle;
        if (l.render) {
            l.render();
        } else {
            var bounds1 = { origin : { x : l.bounds.origin.x * 1, y : l.bounds.origin.y * 1 }, size : { width : l.bounds.size.width * 1, height : l.bounds.size.height * 1 } };
            if (typeof l.contents == 'string') {
                CTX.fillText(l.contents, bounds1.origin.x, bounds1.origin.y);
            } else {
                CTX.fillRect(bounds1.origin.x, bounds1.origin.y, bounds1.size.width, bounds1.size.height);
            };
        };
    };
    for (var __i in l.sublayers) {
        var s = l.sublayers[__i];
        layerRender(s);
    };
};