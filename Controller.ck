Sounds s => dac;
Leap leap;

5::ms => dur updateRate;

57 => int tonic;
[72, 62, 64] @=> int scale[];

fun int y2midi(float y) { return Std.ftoi(y / 20) + 40; }

fun float y2freq(float y) { return Std.mtof(tonic) * (Math.pow(2, (y / 200))); }
fun float xr2freq(float x) { return Std.mtof(tonic) * (Math.pow(2, (x / 50) + 1)); }

fun float y2frac(float y) { return y / 600; }
fun float z2frac(float z) { return 1 - (z / 200); }
fun float x2frac(float x) { return Math.min((x + 200) / 200, 1); }

fun int norm2scale(float x, float y) { 
	if (x < 0 && y < 0) return 0;
	else if (x > 0 && y < 0) return 1;
	else return 2;
}

while (true) {
    if (leap.numHands() == 0) {
    	s.padToggle(0);
    	//s.bottleBlow(0);
    	1 => s.leadEnvelope.keyOff;

    	0 => s.beatVolume.gain;
    }

    else if (leap.numHands() >= 1) {
    	s.padToggle(1);

    	//s.bottleBlow(1);
    	//y2freq(leap.pts["palmPos0"].y) => s.bottle.freq;
    	//z2frac(leap.pts["palmPos0"].z) => s.bottle.noiseGain;
    	
    	y2freq(leap.pts["palmPos0"].y) => s.lead.freq;
       	xr2freq(leap.pts["palmPos0"].x) => s.leadFilter.freq;
       	z2frac(leap.pts["palmPos0"].z) => s.leadVolume.gain;
    	1 => s.leadEnvelope.keyOn;


    	if (leap.numHands() >= 2) {
    		z2frac(leap.pts["palmPos1"].z) => s.beatVolume.gain;
    		//<<< "Beat:", z2frac(leap.pts["palmPos1"].z) >>>;
    		[1.000, 0.750, 0.666] @=> float ratios[];
    		norm2scale(leap.pts["palmNormal1"].x, leap.pts["palmNormal1"].y) => int i;
    		ratios[i] * s.baseFreq => s.lead2.freq;

    		1 => s.lead2Envelope.keyOn;
    	} else 
	   		1 => s.lead2Envelope.keyOff;

    }

    updateRate => now;
}