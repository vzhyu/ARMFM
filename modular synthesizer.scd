(
//Place cursor here and press Ctrl+Enter (Windows) or Cmd+Enter (Mac).
s.waitForBoot({
	Window.closeAll;
	SynthDef.new(\carrier, {
		arg in, out, freq, fModFreq = 110, fDevFreq = 120, fSwitch = 0, aModFreq = 230, min = 1, amp = 0.2, ampLag = 4, pos = 0;
		var sig;
		amp = amp.lag(ampLag);
		sig = SinOsc.ar(freq + SinOsc.ar(fModFreq, mul: fDevFreq*fSwitch), mul: amp*SinOsc.ar(aModFreq).range(min, 1));
		sig = Pan2.ar(sig, pos);
		Out.ar(out, sig);
	}).add;
	~amp = 0.2;
	~carFreq = 440;
	~amFreq = 10;
	~fmFreq = 10;
	~fmDev = 10;
	~fSwitch = 0;
	~aSwitch = 0;
	~rSwitch = 0;
	~pan = 0;

	r = Recorder.new(s);
	~currentPath = PathName.new(thisProcess.nowExecutingPath).parentPath;
	thisProcess.platform.recordingsDir = ~currentPath;

	~soundOn = {
		~car.set(\amp, ~amp, \ampLag, 4);
	};

	~soundOff = {
		~car.set(\amp, 0, \ampLag, 4);
	};

	~setAmpFreq = {
		arg freq;
	};

	~ampMod = {
		~car.set(\min, 0);
		~rSwitch = 0;
		~aSwitch = 1;
	};

	~ringMod = {
		~car.set(\min, -1);
		~rSwitch = 1;
		~aSwitch = 0;
	};

	~noAmpMod = {
		~car.set(\min, 1);
		~aSwitch = 0;
		~rSwitch = 0;
	};

	~freqMod = {
		~fSwitch = 1;
		~car.set(\fSwitch, ~fSwitch);
	};

	~noFreqMod = {
		~fSwitch = 0;
		~car.set(\fSwitch, ~fSwitch);
	};


	~mainSwitch = Button.new(w)
	.states_([["Off", Color.gray], ["On", Color.green]])
	.action_({
		~car.set(\amp, ~amp*~mainSwitch.value);
	});

	~setCarFreq = {
		arg freq, freqString;
		~carFreq = freq;
		freqString = freq.round.(0.01).asString + "Hz";
		~car.set(\freq, freq);
		~carFreqSlider.value_(freq.linlin(10, 1200, 0, 1));
		~carFreqBox.value_(freqString);
	};

	~carFreqSlider = Slider.new(w)
	.orientation_(\horizontal)
	.action_({
		arg freq;
		freq = ~carFreqSlider.value.linlin(0, 1, 10, 1200);
		~setCarFreq.(freq);
	});
	~carFreqBox = TextField.new(w)
	.fixedWidth_(80)
	.mouseDownAction_({
		arg i;
		i.value_("");
	})
	.action_({
		~setCarFreq.(~carFreqBox.value.asFloat);
		w.asView.focus;
	});

	~setAMFreq = {
		arg freq, freqString;
		~amFreq = freq;
		freqString = freq.round.(0.01).asString + "Hz";
		~car.set(\aModFreq, freq);
		~amFreqSlider.value_(freq.linlin(10, 1200, 0, 1));
		~amFreqBox.value_(freqString);
	};
	~amButton = Button.new(w)
	.states_([["AM", Color.gray], ["AM", Color.green]])
	.fixedWidth_(37)
	.action_({
		if(~amButton.value == 0, {
			~noAmpMod.();
		});
		if(~amButton.value == 1, {
			if(~rmButton.value == 1, {
				~rmButton.value_(0);
			});
			~ampMod.();
		});
	});
	~rmButton = Button.new(w)
	.states_([["RM", Color.gray], ["RM", Color.green]])
	.fixedWidth_(37)
	.action_({
		if(~rmButton.value == 0, {
			~noAmpMod.();
		});
		if(~rmButton.value == 1, {
			if(~amButton.value == 1, {
				~amButton.value_(0);
			});
			~ringMod.();
		});
	});
	~amFreqSlider = Slider.new(w)
	.orientation_(\horizontal)
	.action_({
		arg freq;
		freq = ~amFreqSlider.value.linlin(0, 1, 10, 1200);
		~setAMFreq.(freq);
	});
	~amFreqBox = TextField.new(w)
	.fixedWidth_(80)
	.mouseDownAction_({
		arg i;
		i.value_("");
	})
	.action_({
		~setAMFreq.(~amFreqBox.value.asFloat);
		w.asView.focus;
	});


	~setFMFreq = {
		arg freq, freqString;
		~fmFreq = freq;
		freqString = freq.round.(0.01).asString + "Hz";
		~car.set(\fModFreq, freq);
		~fmFreqSlider.value_(freq.linlin(10, 1200, 0, 1));
		~fmFreqBox.value_(freqString);
	};
	~fmButton = Button.new(w)
	.states_([["FM", Color.gray], ["FM", Color.green]])
	.fixedWidth_(37)
	.action_({
		if(~fmButton.value == 0, {
			~noFreqMod.();
		});
		if(~fmButton.value == 1, {
			~freqMod.();
		});
	});
	~fmFreqSlider = Slider.new(w)
	.orientation_(\horizontal)
	.action_({
		arg freq;
		freq = ~fmFreqSlider.value.linlin(0, 1, 10, 1200);
		~setFMFreq.(freq);
	});
	~fmFreqBox = TextField.new(w)
	.fixedWidth_(80)
	.mouseDownAction_({
		arg i;
		i.value_("");
	})
	.action_({
		~setFMFreq.(~fmFreqBox.value.asFloat);
		w.asView.focus;
	});

	~setFMDevFreq = {
		arg freq, freqString;
		~fmDev = freq;
		freqString = freq.round.(0.01).asString + "Hz";
		~car.set(\fDevFreq, freq);
		~fmDevSlider.value_(freq.linlin(10, 1200, 0, 1));
		~fmDevBox.value_(freqString);
	};
	~fmDevSlider = Slider.new(w)
	.orientation_(\horizontal)
	.action_({
		arg freq;
		freq = ~fmDevSlider.value.linlin(0, 1, 10, 1200);
		~setFMDevFreq.(freq);
	});
	~fmDevBox = TextField.new(w)
	.fixedWidth_(80)
	.mouseDownAction_({
		arg i;
		i.value_("");
	})
	.action_({
		~setFMDevFreq.(~fmDevBox.value.asFloat);
		w.asView.focus;
	});


	~setPan = {
		arg pan, panString;
		~pan = pan;
		if(pan > 0, {
			panString = "+" ++ pan.round(0.01).asString;
		});
		if(pan <= 0, {
			panString = pan.round(0.01).asString;
		});
		~car.set(\pos, pan);
		~panSlider.value_(pan.linlin(-1, 1, 0, 1));
		~panBox.value_(panString);
	};
	~panSlider = Slider.new(w)
	.orientation_(\horizontal)
	.action_({
		arg pan;
		pan = ~panSlider.value.linlin(0, 1, -1, 1);
		~setPan.(pan);
	});
	~panBox = TextField.new(w)
	.fixedWidth_(80)
	.mouseDownAction_({
		arg i;
		i.value_("");
	})
	.action_({
		~setPan.(~panBox.value.asFloat);
		w.asView.focus;
	});


	~setAmp = {
		arg amp, db, dbString;
		~amp = amp;
		db = amp.ampdb;
		if (db < 0, {
			dbString = db.round(0.1).asString + "dB";
		});
		if (db >= 0, {
			dbString = "+" ++ db.round(0.1).asString + "dB";
		});
		~car.set(\amp, amp, \ampLag, 1);
		~ampSlider.value_(amp.explin(-40.dbamp, 0.dbamp, 0, 1));
		~ampBox.value_(dbString);
		~mainSwitch.valueAction_(1);
	};
	~ampSlider = Slider.new(w)
	.orientation_(\vertical)
	.action_({
		arg amp;
		amp = ~ampSlider.value.linexp(0, 1, -40.dbamp, 0.dbamp);
		~setAmp.(amp);
	});
	~ampBox = TextField.new(w)
	.fixedWidth_(70)
	.mouseDownAction_({
		arg i;
		i.value_("");
	})
	.action_({
		~setAmp.(~ampBox.value.asFloat.dbamp);
		w.asView.focus;
	});

	~recordButton = Button.new(w)
	.states_([["Record", Color.gray], ["Record", Color.red]])
	.action_({
		if(~recordButton.value == 0, {
			r.stopRecording;
		});
		if(~recordButton.value == 1, {
			r.record();
		});
	});

	w = Window.new("Modular Synthesizer")
	.bounds_(Rect.new(200, 200, 500, 200))
	.onClose_({
		s.freeAll;
		s.quit;
	})
	.layout_(
		HLayout(
			VLayout(
				HLayout(
					~mainSwitch,
					~recordButton,
				),
				HLayout(
					StaticText.new(w)
					.string_("Carrier")
					.align_(\center)
					.fixedWidth_(80),
					~carFreqSlider,
					~carFreqBox,
				),
				HLayout(
					~amButton,
					~rmButton,
					~amFreqSlider,
					~amFreqBox,
				),
				HLayout(
					~fmButton,
					VLayout(
						StaticText.new(w)
						.string_("Freq")
						.align_(\center)
						.fixedWidth_(37),
						StaticText.new(w)
						.string_("Dev")
						.align_(\center)
					),
					VLayout(
						HLayout(
							~fmFreqSlider,
							~fmFreqBox,
						),
						HLayout(
							~fmDevSlider,
							~fmDevBox,
						),

					)
				),
				HLayout(
					StaticText.new(w)
					.string_("Pan")
					.align_(\center)
					.fixedWidth_(80),
					StaticText.new(w)
					.string_("L"),
					~panSlider,
					StaticText.new(w)
					.string_("R"),
					~panBox,
				)
			),
			VLayout(
				StaticText.new(w)
				.string_("Volume")
				.align_(\center),
				~ampSlider,
				~ampBox
			)
		)
	);
	w.front;
	w.asView.focus;
	~car = Synth(\carrier, [\out, 0, \freq, ~carFreq, \amp, 0]);
	~setCarFreq.(~carFreq);
	~setAMFreq.(~amFreq);
	~setFMFreq.(~fmFreq);
	~setFMDevFreq.(~fmDev);
	~setPan.(~pan);
	~setAmp.(~amp);
	~mainSwitch.valueAction_(0);
})
)