/* scsynth */




// AUDIO SERVER
// UGEN
// SPOSOBY GENEROVANIA ZVUKU
// HLASITOST
// STEREO
// SKALOVANIE







////////////////////////////////
///// AUDIO SERVER
////////////////////////////////

// -- je to samostatny program, ktory potrebujeme nastartovat manulane (da sa to aj zautomatizovat), ak chceme robit so zvukom

s.boot // nastartovanie audio serveru, v SCIDE je na to klavesova skratka Ctrl + b
s.meter // Level meter


s.quit // ukoncenie audio servera


// ak chceme menit pocet vstupnych / vystupnych kanalov scsynthu, je potrebne pred bootnutim nastavit pozadovane ServerOptions  a az  potom bootnut



s.options.numOutputBusChannels = 20  // 20 vystupov

s.options.numInputBusChannels = 4 // 4 vstupy

s.reboot;

"Classes/ServerOptions".help // co vsetko sa da nastavit ...


s.sampleRate // 44100


////////////////////////////////
///// UGENs (Unit GEnerators)
////////////////////////////////

{SinOsc.ar}.plot

{SinOsc.ar * 2}.plot

{SinOsc.ar / 2}.plot

{WhiteNoise.ar}.plot

{LFSaw.ar}.plot

"Guides/Tour_of_UGens".help

////////////////////////////////
///// HLASITOST (aplituda)
////////////////////////////////


{SinOsc.ar * 0.1 }.play

// !!! PANIC BUTTON !!!

Ctrl + .



////////////////////////////////
///// SPOSOBY GENEROVANIA ZVUKU
////////////////////////////////

// -- funkcia

    x = {SinOsc.ar * 0.1 }.play

    x.free

"Reference/Functions".help

// -- SynthDef, je to 'recept' na zvukovy syntezu, ktoremu sa da nejake meno, podla ktoreho ho vieme pouzivat lubovolny pocet krat.

    SynthDef(\meno, {   Out.ar(0, SinOsc.ar * 0.1) }).add; // najprv ho treba zadefonovat
    a = Synth(\meno) // zacne hrat
    a.free // skonci


"SynthDef".help


// -- Ndef, velmi pohodlny sposob, daju sa robit prelinacky medzi jednotlivymi verziami


     Ndef(\meno, {SinOsc.ar * 0.1 ! 2 }).play

     Ndef(\meno, { Saw.ar(LFNoise2.kr(15).range(100, 300)) * 0.1 ! 2});

     Ndef(\meno).fadeTime = 5

     Ndef(\meno, { Saw.ar([ 110, 101]) * 0.1});
     Ndef(\meno).stop

"Ndef".help





////////////////////////////////
///// MULTICHANNEL (stereo ...)
////////////////////////////////

     [sig, sig]

2.dup(2) // [2,2], duplikacia

1.dup(5) // [1,1,1,1,1]

Ndef(\stereo, { (SinOsc.ar * 0.1).dup(2) }).play
Ndef(\stereo).stop



(

Ndef(\stereo, {
    var sig = SinOsc.ar(  freq: MouseY.kr(100,300)   ) * 0.2;
    Pan2.ar(sig, LFNoise0.kr(1).range(-1,1)  );
}).play

)
Ndef(\stereo).stop

"Guides/Multichannel-Expansion".help


////////////////////////////////
///// SKALOVANIE (alebo mapovanie v SC)
////////////////////////////////


// sclang
0 - 100 -> 200 - 300

100.rand.linlin(0,100, 200,300) // nazov linlin odkazuje ze z linearneho rozsahu prevadza do linearneho
// najdi si rozdiel medzi linearnym a exponencialnym

linexp
exolin
expexp


//scsynth

(
  {[
    LFNoise0.kr(100), //  defaultny rozsah tohto UGenu je <-1,1>
    LFNoise0.kr(100).range(-10,10) //  teraz bude <-10, 10>
]}.plot(1)
)



////////////////////////////////
///// APP
////////////////////////////////



// funckcia z predchadzajuceho dielu
(
~tlac = { arg kolko, znak;
    kolko.do({  znak.asAscii.post; });
    "".postln; // posledny znak, prechod na novy riadok
};

)


(

Ndef(\synth, { arg amp=0.2, mfreq=20, mwidth=200;
    var mod = SinOsc.ar(mfreq) * mwidth;
    var sig = SinOsc.ar(200 + mod) * amp;
    Pan2.ar(sig, SinOsc.kr(0.2).range(-0.4,0.4)  );
})

)

Ndef(\synth).play

Ndef(\synth).set(\amp, 0.2) // argumenty vieme menit pomocou '.set'

Ndef(\synth).set(\mfreq, 200.rand)

Ndef(\synth).set(\mwidth, 800)

Ndef(\synth).stop

~cas = 0.2; // ako rychlo sa ma vykreslovat, da sa menit za behu..



(
~cas = 0.2;
Ndef(\synth).play;
Tdef(\loop, {

    loop{
        var znak = 93.rand + 33;
        var gerlach = 1 + 10.rand;

        (1..gerlach).do({ arg kolko;  // STUPANIE
            var mfreq = kolko.linlin(1,20,8,400);
            var mwidth = kolko.linlin(1,20,40,400);
            ~tlac.value(kolko, znak);
            Ndef(\synth).set(\mfreq, mfreq);
            Ndef(\synth).set(\mwidth, mwidth);
            ~cas.wait;

        });

        (gerlach..1).do({ arg kolko;  // KLESANIE
            var mfreq = kolko.linlin(1,20,8,400);
            var mwidth = kolko.linlin(1,20,40,400);
            ~tlac.value(kolko, znak);
            Ndef(\synth).set(\mfreq, mfreq);
            Ndef(\synth).set(\mwidth, mwidth);
            ~cas.wait;

        });
    }
}).play;

)


// zastav
(
Tdef(\loop).stop;
Ndef(\synth).stop;
)



// predchadzajuci blok by sa dal este zjednodusit, kedze v stupani a klesani je velmi podobny kod, v podstate rovnaky, lisi sa len "cestou"
// vytvorim si funkciu ktora sa postara o vyjreslenie "svahu" (stupanie alebo klesanie)


// jej argumenty:
// gerlach -> max pocet znakov, tak ako mame
// znak -> aky znak ma tlacit
// stupanie -> ak true, bude stupat, ak false bude klesat
(


~svah = { arg gerlach=10, znak=102, stupanie=true; // defaultne hodnoty
    var cesta;
    if(stupanie, {
        cesta = (1..gerlach) // stupanie
    },{
        cesta = (gerlach..1) // klesanie
    });

    cesta.do({ arg kolko;
            var mfreq = kolko.linlin(1,20,8,400);
            var mwidth = kolko.linlin(1,20,40,400);
            ~tlac.value(kolko, znak);
            Ndef(\synth).set(\mfreq, mfreq);
            Ndef(\synth).set(\mwidth, mwidth);
            ~cas.wait;
    });

}


)



(
Ndef(\synth).play;
Tdef(\loop, {

    loop{
        var znak = 93.rand + 33;
        var gerlach = 1 + 10.rand;

        ~svah.value(gerlach, znak, true);// STUPANIE
        ~svah.value(gerlach, znak, false);// KLESANIE

    }
}).play;

)


// teraz ak by som chcel zmenit chopovanie, staci redefinovat novu verziu funkcie ~svah a zacne sa to chovat novym sposobom



// zastav
(
Tdef(\loop).stop;
Ndef(\synth).stop;
)








































































(
   var a = {100.rand}.dup(100);

   [  a.linlin(0,99,0,1), a.linexp(0,99,0.01,1)  ].plot;
)



    {100.rand}.dup(100).linlin(0,99,0,1).plot



Ndef(\a, {|f=300 h=2 amp=0.2 modf=0.1| Blip.ar(f * SinOsc.ar(modf),h)*amp!2}).play

Ndef(\a).set(\h, 10)

Ndef(\a).stop
Ndef(\a).fadeTime = 2


s.sampleRate

[SinOsc,SinOsc]

2.dup(40)
2 ! 40

{SinOsc.ar( MouseX.kr(20,600) ) * 0.2 ! 2}.scope


~cas = 4


(
   Tdef(\t,{
      Ndef(\a).play;
      loop{
           ~znak = 93.rand + 33;
           ~gerlach = 30.rand + 2 ;
           ~freq = [60.midicps,67.midicps,65.midicps].choose;
           Ndef(\a).set(\h,(~znak-33).linlin(0,93,1,10));
           Ndef(\a).set(\f,~freq);
             (1..~gerlach).do { | kolko| // vystup
                     Ndef(\a).set(\amp,kolko.linlin(0,39,0,0.5));
                     Ndef(\a).set(\modf,kolko.linlin(0,39,0.01,50));
                     ~riadky.value(kolko,~znak+kolko);
                     (~cas/kolko).linlin(2,~gerlach, 0.05,2).wait;
              };

              (~gerlach..1).do { | kolko |  // klesanie
                     Ndef(\a).set(\amp,kolko.linlin(0,39,0,0.5));
                     Ndef(\a).set(\modf,kolko.linlin(0,39,0.01,50));
                     ~riadky.value(kolko ,~znak+kolko);
                     (~cas/kolko).linlin(2,~gerlach, 0.05,2).wait;
              };
      }
   }).play
) // zastavit ctrl + .


(
Tdef(\t).stop;
Ndef(\a).stop;
)

//.set(\freq, ((~znak-33).linlin(0,93,1,5).round*200).postln );
              //Ndef(\a).set(\harm, (~znak-33).linlin(0,93,1,10 v ) );
