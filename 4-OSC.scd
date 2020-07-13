/* OSC */




// OSC
// TESTOVANIE OSC
// PODMIENKA 'If'
// OSCdef
// BUFFER
// ADRESAR BUFFROV
// SEROVA VYROBA OSCDefu



////////////////////////////////
///// OSC
////////////////////////////////

// OSC - Open Sound Control, pozri na webe



// IP adresa + PORT

// IP adresa xxx.xxx.xxx.xxx moja je: 192.168.43.222
// PORT xxxxx


// localhost / 127.0.0.1
NetAddr.localAddr
NetAddr.langPort



////////////////////////////////
///// TESTOVANIE OSC
////////////////////////////////


OSCFunc.trace(true)
OSCFunc.trace(false)





////////////////////////////////
///// PODMIENKA 'If'
////////////////////////////////

// podmienka - control stuctures

if( podmienka, {}, {});

"Reference/Control-Structures".help





////////////////////////////////
///// OSCdef
////////////////////////////////

// -- schema
OSCdef(\nejakosavolam, { arg hodnota; ... },'adresa_odkial_ide')




OSCdef(\fader1, {|m| ~attack = m[1].linlin(0,1,0.01,10) },'/1/fader1')
OSCdef(\fader2, {|m| ~release= m[1].linlin(0,1,0.01,10) },'/1/fader2')

~attack = 5
~release = 5



(
   OSCdef(\push1, { |m|

      if(m[1].asInteger == 1, {
         "jedna".postln;
      }, {
         "nie".postln;
      });

   },'/2/push1')

)





////////////////////////////////
///// BUFFER
////////////////////////////////

// pre pracu s nahratymi zvukmi (wav, aiff a mozno aj ine..) je urceny Buffer

"Buffer".help

~a = Buffer.read(s, "/home/paum/Projekty/Workshop/Screencast/final/sample/daily_num001.wav") // nacitam sample


//info o nacitanom sampli
~a.numChannels // pocet kanalov = mono, stereo...
~a.numFrames // jeho velkost v pocte frameov
~a.numFrames / 44100 // ak vydelim numFrames so sampleRate na akom mi bezi server, dostanem cas v sekundach

~a.plot // zobrazenie
~a.play // prehravanie

// Ctrl + . na zastavenie


// jednoduchyu synthDef na prehravanie samplov pomocou UGenu PlayBuf
(
   SynthDef(\sample, { | buf amp=0.2|
     var sig = PlayBuf.ar(2, buf, doneAction: 2) * amp;
     Out.ar(0,sig);
   } ).add;

)

// test

Synth(\sample, [ \buf, ~a  ] )

~a.free //  uvolnenie pamate


"PlayBuf".help




////////////////////////////////
///// ADRESAR BUFFROV
////////////////////////////////


// ako nacitat cely adresar samplov

~p = PathName.new("/home/paum/Projekty/Workshop/Screencast/final/sample/") // adresar so zvukmi
//pozri help ku PathName

~p.entries.do({ |f| f.fullPath.postln })


~b = List.new; // List je druh pola (Array)

"List".help

(

~p.entries.do({ |f|
   ~b.add(
      Buffer.read(s, f.fullPath)
   )
})


)



~b.size
~b[1].plot
~b[15].plot


////////////////////////////////
///// SEROVA VYROBA OSCDefu
////////////////////////////////






("push"++1).asSymbol


(

   16.do({ |i|

      OSCdef( ( "push"++(i+1) ).asSymbol, { |m|

         if(m[1].asInteger == 1, {
            Synth(\sample, [ \buf, ~b[i]  ] )
         }, {
           // "nie".postln;
         });

      }, ( "/2/push"++(i+1) ).asSymbol )

   });
)



























































////////////////////////////////
///// MIDI KOD Z MINULEHO DIELU
////////////////////////////////

(
   MIDIClient.init;
   MIDIIn.connectAll;
   s.boot;
)


   s.meter;

   s.plotTree

(

   MIDIdef.noteOn(\nota, { | vol, nota, chan, src |
      [ vol, nota ].postln;
      ~klavesy[nota-36] = Synth(\synth, [
         \freq,  (nota - 12).midicps,
         \amp, vol.linexp(0,127, 0.01, 0.2),
         \gate,1,
         \atk, ~attack,
         \rel, ~release
      ])
   }).permanent_(true);

   MIDIdef.noteOff(\notaoff, { | vol, nota, chan, src |
      [ vol, nota, "OFF" ].postln;
      ~klavesy[nota-36].set(\gate,0);
   }).permanent_(true);



   SynthDef(\synth, { | freq=330 amp=0.05 gate=0 atk=0.01 rel=1.0|
      var sig = LFTri.ar(freq) * amp ! 2;
      var env = EnvGen.kr(
         Env.adsr(
         attackTime: atk,
         releaseTime: rel),
         gate,
         doneAction: 2 );
      Out.ar(0, sig*env)
   }).add;



   ~klavesy = Array.newClear(61)
)
