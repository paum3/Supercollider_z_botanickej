/* MIDI synth */


// MIDI
// SYNTH
// POLYFONIA


////////////////////////////////
///// MIDI
////////////////////////////////

"Guides/MIDI".help


MIDIClient.init; // aktiovat SC MIDI syste,
MIDIIn.connectAll; // pripojit SC ku vsetkym MIDI zariadeniam



// pre definovanie chovania stlacenie klaves na MIDI synthe pouzijeme MIDIdef

"MIDIdef".help


// prijima 4 argumenty
MIDIdef.noteOn(\nota, { | vol, nota, chan, src | [vol, nota, chan, src].postln;


// Komplementarne existuje .noteOff
MIDIdef.noteOff(\nota, { | vol, nota, chan, src | [vol, nota, chan, src].postln;


// na 'control messages' je .cc
// control messages mozu byt ostatne gombiky, volume slider, mod koliesko a pod.

MIDIdef.cc(\vol, {| a b c d | [a,b,c,d].postln} )





////////////////////////////////
///// SYNTH
////////////////////////////////

s.boot
s.quit
s.meter
s.plotTree



/*
        v Synthe pouzivam tzv. obalku amplitudy,
        co je vlastne hlasitostna krivka, ktora urcuje
        ako sa ma Synth chovat ked zacne hrat
        (napr fade in 0.5 sek = attackTime: 0.5)
        a ako ked Synth uvolnim a ma prestat hrat.
        (napr fade our 3.2 sek = releaseTime: 3.2)

*/



(
   Env.adsr.plot;
   Env.adsr.test;
)



(
   Env.adsr(attackTime: 2, releaseTime:1.5).plot;
   Env.adsr(attackTime: 2, releaseTime:1.5).test;
)


(
 SynthDef(\synth, { | freq=330 amp=0.05 gate=0|
    var sig = LFTri.ar(freq) * amp ! 2;
    var env = EnvGen.kr(Env.adsr(releaseTime:1.5), gate, doneAction: 2 );
    Out.ar(0, sig*env)
  }).add;
)


a = Synth(\synth, [\freq, 200, \amp, 0.04, \gate,1 ])
a.set(\gate, 0) // uvonli








////////////////////////////////
///// POLYFONIA
////////////////////////////////


/* cely problem polyfonie je ze potrebujeme niekam odkladat Synth ktory bezi,
   aby sme ho mohli pri pusteni klavesy uvolnit.

   Idealne na to posluzi Pole (Array), ktore si vytvorime vo velkosti,
   kolko mame klaves (moze byt aj viac, ale zbytocne)
   a potom do jednotlivych slotov ukladame beziace Synthy.
*/


~klavesy = Array.newClear(61) // vytvorim pole velkosti 61, lebo tolko klavesov mam

        //stlacil som 11tu klavesu = zacne hrat a ulozi sa do 10teho slotu (lebo zaciname od nuly)
~klavesy[10] = Synth(\synth, [\freq, 200.rand, \amp, 0.04 ])

        // pustil som 10tu klavesu, Synth sa z 10teho slotu uvolni..
~klavesy[10].free



////////////////////////////////
///// APP
////////////////////////////////

// 1 oktava = 12
5 * 12 + 1 = 61 // pocet klaves na mojom MIDI nastroji

~klavesy = Array.newClear(61)


(
     MIDIdef.noteOn(\nota, { | vol, nota, chan, src |
      [ vol, nota ].postln;
      ~klavesy[nota-36] = Synth(\synth, [
        \freq,  nota.midicps,
        \amp, vol.linexp(0,127, 0.01, 0.2),
        \gate,1
     ])
     }).permanent_(true);

     MIDIdef.noteOff(\notaoff, { | vol, nota, chan, src |
    [ vol, nota, "OFF" ].postln;
      ~klavesy[nota-36].set(\gate,0);
     }).permanent_(true);

)










