#
# http://code.activestate.com/recipes/534162-an-erlang-port-in-python/
#
# heavily modified by Lyndon Tremblay <humasect@gmail.com>
#     for NorthScale vBucketCtl interface.

import sys, os, struct, traceback
from cStringIO import StringIO

class ErlangPort(object):
    PACK = '!h'
    def __init__(self):
        self._in = sys.stdin
        self._out = sys.stdout
        
    def recv(self):
        buf = self._in.read(2)
        if len(buf) ==2:
            (sz,) = struct.unpack(self.PACK, buf)
            return self._in.read(sz)
        
    def send(self, what):
        sz = len(what)
        buf = struct.pack(self.PACK, sz)
        self._out.write(buf)
        return self._out.write(what)

    def run(self):
        buf = self.recv()
        while buf:
            try:
                result = self.process(buf)
            except:
                result = traceback.format_exc()
            self.send(result) 
            buf = self.recv()


class ErlangPortTest(ErlangPort):
    cmds = (0,lambda x: x+2, lambda x: x*2)
    def process(self, message):
        fn,arg = struct.unpack('!BB', message)
        res = self.cmds[fn](arg)
        return struct.pack('!B', res)

class ErlangPyTest(ErlangPortTest):
    class SandBox:
        def json_stats(self, host, port):
            import mc_bin_client
            mc = None
            try:
                mc = mc_bin_client.MemcachedClient(host, port)
                vbs = mc.stats('vbucket')

                #import json
                #print json.dumps(vbs)
                import cjson
                print cjson.encode(vbs)

            except:
                print "{\"error\": \"Failed to get listing..\"}"
            finally:
                mc.close()

        def process(self, message):
            exec message
    sandbox = SandBox()
    def process(self, code):
        try:
            realout = sys.stdout
            sys.stdout = StringIO()
            self.sandbox.process(code)
            result = sys.stdout.getvalue()
        finally:
            if sys.stdout: sys.stdout.close()
            if realout: sys.stdout = realout
        return result

if __name__ == '__main__':
    import sys
    try:
        command = sys.argv[1]
        if command == 'PortTest':
            ErlangPortTest().run()
        elif command =='mc_client':
            ErlangPyTest().run()
    except IndexError:
        print "error"
