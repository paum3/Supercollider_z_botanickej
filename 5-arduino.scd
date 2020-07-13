/* ARDUINO */


// arduino.cc


// SERIOVY PORT
// TASK
// ARDUINO DATA READER
// APP



////////////////////////////////
///// SERIAL PORT
////////////////////////////////

~port = SerialPort.new(port: "/dev/ttyUSB0", baudrate: 115200 )

// ~port.close



~port.read // ascii

56.asAscii
51.asAscii
53.asAscii



10.asAscii
13.asAscii




////////////////////////////////
///// TASK
////////////////////////////////


Tdef(\meno, {  loop { ~port.read.asAscii.postln; 0.2.wait }    }).play

Tdef(\meno).stop




////////////////////////////////
///// ARDUINO DATA READER
////////////////////////////////

~cislo = []
~cislo.class

~cislo = ~cislo.add( ~port.read.asAscii )

~cislo[0].class

$8.digit // Char -> Integer

[ $8, $5, $3].collect( _.digit).convertDigits



"Char".help


(
   Tdef(\areader, {
      loop {
         var d = ~port.read.asAscii;
         if(d.isDecDigit, {
            ~cislo = ~cislo.add(d);
         },{
            if(~cislo.notEmpty, {
               ~data = ~cislo.collect( _.digit).convertDigits;
               ~cislo = [];
               Ndef(\theremin).set(\freq, ~data.linlin(420,820,200,400));
            });
         });

      }
   }).play
)

Tdef(\areader).stop












////////////////////////////////
///// APP
////////////////////////////////

s.reboot
s.meter

// ~data   420 ~ 820



(

Ndef(\theremin, { | freq = 300 |
      var amp = MouseX.kr(0,0.1);
      var sig = SinOsc.ar( freq + SinOsc.kr(12).range(-10,10) ) * amp ! 2;
      sig
}).play



)


Ndef(\theremin).stop





~port.close
























