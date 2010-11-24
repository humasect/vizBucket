var SCREENWIDTH = 800;
var SCREENHEIGHT = 600;
var CTX = null;
var SCREEN = null;
function cgShadowOffset(p) {
    CTX.shadowOffsetX = p.x;
    CTX.shadowOffsetY = p.y;
    return null;
};
function startGraph() {
    CTX = $('#screen-canvas')[0].getContext('2d');
    CTX.font = 32 + 'px ' + 'helvetica';
    SCREEN = layerMake('name', '*screen*', 'bounds', { origin : { x : 0, y : 0 }, size : { width : SCREENWIDTH, height : SCREENHEIGHT } });
    return startMain();
};
$(document).ready(startGraph);