var SHOWDEAD = true;
var REFRESHMS = 300;
var INFOMS = 3000;
var IMAGESIZE = 192;
var IMAGEOUTSET = 16;
function requestJson(method, successf, failuref) {
    var url = 'http://' + window.location.host + '/bucket/' + method;
    return $.ajax({ url : url, success : function (data, textStatus, req) {
        var object = null;
        try {
            object = JSON.parse(data);
        } catch (err) {
            console.log(err + ': ' + data);
            var doAlert = true;
            if (failuref) {
                doAlert = failuref(err);
            };
            if (doAlert) {
                alert(err + ': request \'' + url + '\' failed: ' + data);
            };
        };
        if (!object.error) {
            return successf(object);
        };
    } });
};
function startMain() {
    requestJson('vinfo', function (d) {
        $('#loading').html('');
        addServers(d['vBucketServerMap']['serverList']);
        if (SERVERPOLLING) {
            setTimeout(startMain, INFOMS);
        };
        return null;
    }, function (d) {
        return $('#loading').html('Failed to load: ' + d);
    });
    SCREEN.fillStyle = 'blue';
    return layerRender(SCREEN);
};
var SERVERSNEEDUPDATE = false;
var SERVERPOLLING = true;
var SERVERS = [];
function addServers(lst) {
    if (!lst) {
        return null;
    };
    console.log(lst);
    var ips = _.map(SERVERS, function (s) {
        return s['server'];
    });
    var sames = _.intersect(lst, ips);
    if (SERVERSNEEDUPDATE || ips.length == sames.length && lst.length == sames.length) {
        return null;
    } else {
        console.log('Server list changed.');
    };
    stopPolling();
    SERVERS = [];
    SERVERSNEEDUPDATE = false;
    return null;
};
function stopPolling() {
    SERVERPOLLING = false;
    return _.each(SERVERS, function (s) {
        s.polling = false;
        return clearTimeout(s.pid);
    });
};