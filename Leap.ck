class Point extends Object {
    0.0 => float x => float y => float z;
}


public class Leap extends Object {
    OscRecv bus;
    8000 => bus.port;
    bus.listen();

    // varibles
    int ints[0];
    float floats[0];
    Point pts[0];

    // function that binds api to variable, example below
    // int numHands
    // bind("/leap/numhands", "i", numHands)
    fun void bind(string api, string type, string name) {
        if (type == "i") 0 => ints[name];
        else if (type == "fff") Point p @=> pts[name];
        
        // register receiver
        bus.event(api + ", " + type) @=> OscEvent event;

        // infinite event loop
        while (true) {
            // wait for event to arrive
            event => now;

            // grab the next message from the queue. 
            while (event.nextMsg() != 0) {
                // write value
                if (type == "i") event.getInt() => ints[name];
                else if (type == "fff") {
                    event.getFloat() => pts[name].x;
                    event.getFloat() => pts[name].y;
                    event.getFloat() => pts[name].z;
                    //<<< pts[name].x, pts[name].y, pts[name].z >>>;
                }
            }
        }
    }

    spork ~ bind("/leap/num_hands", "i", "numHands");
    spork ~ bind("/leap/0/palm_pos", "fff", "palmPos0");
    spork ~ bind("/leap/1/palm_pos", "fff", "palmPos1");
    spork ~ bind("/leap/1/palm_normal", "fff", "palmNormal1");

    fun int numHands() { return ints["numHands"]; }
    fun float height(string name) { 
        if (pts[name] != null) {
            <<< pts[name].x, pts[name].y, pts[name].z >>>;
            return pts[name].y;
        }
        return 0.0;
    }
}
