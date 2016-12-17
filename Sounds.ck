public class Sounds extends Chubgraph {
	220 => float baseFreq;
	Gain master => outlet;
	0.4 => master.gain;

	BandedWG pad => master;

	2 => pad.preset; // tibetan bowl
	0.5 => pad.bowPressure;
	1 => pad.bowRate;
	baseFreq => pad.freq;
	//0.0 => pad.bowMotion;
	0 => int padState;

	fun void padToggle(int state) {
		if (state == 1 && padState == 0) 1 => pad.startBowing;
		else if (state == 0 && padState == 1) 0 => pad.stopBowing;
		else {
			if (state != padState) 
				<<< "Cannot change state from ", padState, " to ", state >>>;
			return;
		}
		state => padState;
		<<< "Pad: ", padState >>>;
	}

	BlowBotl bottle => master;
	baseFreq => bottle.freq;
	0 => int bottleState;

	fun void bottleBlow(int state) {
		if (state == 1 && bottleState == 0) 1 => bottle.startBlowing;
		else if (state == 0 && bottleState == 1) 1 => bottle.stopBlowing;
		else {
			if (state != bottleState) 
				<<< "Cannot change state from ", padState, " to ", state >>>;
			return;
		}
		state => bottleState;
		<<< "Bottle: ", bottleState >>>;
	}

	SndBuf beat => Gain beatVolume => master;
	me.dir() + "beat.wav" => beat.read;
	0 => beatVolume.gain;
	1 => beat.loop;

	SawOsc lead => ADSR leadEnvelope => LPF leadFilter => Gain leadVolume => master;
	leadEnvelope.set(second, second, 1.0, second);
	baseFreq => leadFilter.freq;
	baseFreq => lead.freq;
	0 => leadVolume.gain;

	SqrOsc lead2 => ADSR lead2Envelope => Gain lead2Volume => beatVolume;
	lead2Envelope.set(second, second, 1.0, second);
	baseFreq => lead2.freq;
	0.3 => lead2Volume.gain;
}