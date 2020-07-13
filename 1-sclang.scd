/* SUPERCOLLIDER */






// SPUSTANIE KODU
// KOMENTAR
// HELP
// PREMENNE
// FUNKCIE
// CYKLY
// POLIA




////////////////////////////////
///// SPUSTANIE KODU
////////////////////////////////


// a) jeden riadok pomocou Shift + Enter

3  // shift + enter
5 + 6 // 11
"ahoj".postln


// b) blok (viac riadkov) Ctrl + Enter
(
 (6 * 8).postln;
 "supercollider".scramble.postln;
 100.rand.postln; // ctrl + enter
)



(
"t".postln;
"tt".postln;
"ttt".postln;
"tttt".postln;
"ttt".postln;
"tt".postln;
"t".postln;
)





////////////////////////////////
///// KOMENTAR
////////////////////////////////


// -- osobne poznamky ktore SC ingoruje,  aj toto je jenda


/*

        viacriadkovy komentar

*/








////////////////////////////////
///// HELP
////////////////////////////////


rand // na tomto slove stlac Ctrl + d
// zobrazia sa vsetky tredy (Classes) ktore maju definovanu metodu 'rand'







////////////////////////////////
///// PREMENNE
////////////////////////////////

// -- male pismena: a -- z, rychle premenne,
// -- pismeno 's' je rezervovane pre audio server

a = 5
a + 32
b = 3

a + b


s // premenna 's' je pri starte SC zadefinovana ako Server.local, co je audio server. Pouzijeme v nasledujucom tutorialy


// prmenne s dlhsim nazvom sa dajue pouzit
// a) v bloku kodu ohranicenom oblymi zatvorkami () plus klucove slovo 'var'. Musi sa zacinam malym pismenom
(
  var vypisDoKonzoly;
  vypisDoKonzoly = "Tilia cordata";

  vypisDoKonzoly.postln;
)


// b) ako tzv. environmentalne premenne (zlozitejsi koncept, nie je teraz dolezity). Pred nazov premennej jhe potrebne dat znak tilda '~' a za nou musi nasledovat najprv male pismeno



~superNazovPremennej = 3

~superNazovPremennej + 2 // 5




////////////////////////////////
///// FUNKCIE
////////////////////////////////

// -- funkciami si definujeme nejaky zlozitejsi kod, ktory vieme potom jednoducho zavolat menom funkcie
// -- su VZDY uzatvorene v zlozenych zatvorkach {}. V SC sa zlozene zatvorky nepouzivaju na nic ine
// -- vacsinou si funkciu nejako pomenujeme, teda ulozime ju do premennej, aby sme ju potom mohli 'zavolat' pomocou metody '.value()'
// -- fukcia moze mat (a vacsinou ma)  tzv. ARGUMENTY, pomocou ktorych sa meni vnutorny stav. Tie mozu mat svoju defaultnu hodnotu

"Reference/Functions".help
"Classes/Function".help

// zakladna schema:
a = { arg x, y, z; ..kod funkcie.. }; // definicia funkcie

a.value(x: xx, y: yy, z: zz) // volanie

// priklad
a = { "Dnes je pondelok".postln}
a.value
a.value
a.value

// priklad s argumentom
a = { arg den = "pondelok"; "Dnes je "++den.postln}

a.value
a.value("utorok")










////////////////////////////////
///// CYKLUS
////////////////////////////////

// opakovanie niecoho
// a) ohraniceny pocet krat

10.do({ "a".post;})

[320,650,1234,20].do({arg v i; ("Prvok #"++i++" je: "++v).postln    })


"Reference/Control-Structures".help







// b) nekonecny pocet krat (loop)


(
Tdef(\mojloop,
    {
      loop{ 100.rand2.postln; 0.5.wait; } // vypis nahodne cislo z rozsahu <-99,  99> a pockaj pol sekundy
    }
).play; // ctrl + . STOP
)


Tdef(\mojloop).stop











////////////////////////////////
///// POLIA - ARRAY
////////////////////////////////

// zoznamy prvkov
[0,1,2,3,4,5,6,7,8,9,10]

(0..10).do({ arg i; i.postln  })


(1,3..10).do({ arg i; i.postln  })













////////////////////////////////
///// APP
////////////////////////////////



// funkcia na vypisanie zadanoho poctu vybraneho znaku.

// najprv si funkciu treba zadefinovat. Ctrl + Enter v nasledujucom bloku kodu )
(
~tlac = { arg kolko, znak;

    kolko.do({  znak.asAscii.post; });
    "".postln; // posledny znak, prechod na novy riadok
};

)

// a teraz ju mozeme zavolat
~tlac.value(5,102) // fffff

~tlac.value(50,89) // YYYYYYYYYYYYYYYYYYYYYYY...

// vybrany znak definujeme pomocou ASCII hodnoty. Vygoogli si to


49.asAscii // 1
50.asAscii // 2

97.asAscii // a
98.asAscii // b


// loop

(
Tdef(\loop, {
    var cas = 0.2;
    loop{
        var znak = 93.rand + 33; // nahodne cislo v rozsahu (0 - 92) + 33 = nahodne cislo v rozsahu 33 - 125
        var gerlach = 1 + 20.rand;

        (1..gerlach).do({ arg kolko; ~tlac.value(kolko, znak); cas.wait;});
        (gerlach..1).do({ arg kolko; ~tlac.value(kolko, znak); cas.wait;});
    }
});

)

Tdef(\loop).play
Tdef(\loop).stop
