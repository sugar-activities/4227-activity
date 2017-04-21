; ON THE SIXTH DAY: I (2009) for Sugar and Sugar-on-a-Stick - by Arthur B. Hunkins
; MyMusicMIDImc.csd - requires 1 or more MIDI devices with a total of 8 or 9 pots/sliders
;  Csound 5.10 or greater

<CsoundSynthesizer>
<CsOptions>

-odac -+rtaudio=alsa -+rtmidi=alsa -Ma -m0d --expression-opt -b128 -B2048 -+raw_controller_mode=1

</CsOptions>
<CsInstruments>

gichan  chnexport "chan", 1
gictrl1 chnexport "ctrl", 1
gipan   chnexport "pan", 1
gipctrl chnexport "panctrl", 1
gimult	chnexport "mult", 1

sr      = 32000
ksmps   = 100
nchnls  = 2

        seed 0

	instr 1, 2, 3, 4, 5, 6, 7, 8

indx    =          p1 - 1
ictrl   =          gictrl1 + indx
kamp2   ctrl7      (gichan > 0? gichan: p1), (gichan > 0? ictrl: 7), 0, 1
kamp    table      kamp2 * 512, 1
kamp	  =	       (kamp2 == 0? 0: kamp)
iport	=	   (gimult == 0? .01: .08)
kamp    port       kamp, iport
itrig	=	   (gimult == 0? .01: .02)
ktrig   trigger    kamp2, itrig, 0
        if ktrig == 0 goto skip
        if gipan == 1 goto skip2
	if gimult == 0 goto skip3
	if kamp2 > .1 goto skip
skip3:
kpan    rnd31      .5, .7
kpan    =          (p1 > 1? kpan: 0)
	kgoto skip
skip2:
gkpan   ctrl7      (gichan > 0? gichan: 9), (gichan > 0? gipctrl: 7), -.5, .5
        if p1 > 1 goto skip4
kpan    =          0
gkpan2  =          gkpan
gkflag  =          1
        kgoto skip
skip4:
kpan    =          (((gkpan2 == gkpan) && (gkflag == 1))? 0: gkpan) 
gkpan2  =          gkpan
gkflag  =          (kpan == 0? 1: 0)
skip:        
kmod2   rspline    1.4, 2, 1.5, 2.5
kmod    rspline    .85, 1, 20, 25
kfreq   jspline    .25, 1, 2
kpw     jspline    p7, 1, 2
aout    vco2       p4 * kamp * kmod * kmod2, 440 + (p1 > 1? kfreq: 0), p5, p6 + kpw 
	if gimult > 0 goto skip5
kamp2   port       kamp2, .01
a1,a2,a3,a4 pan    aout, .5 + (kamp2 * kpan), 1, 2, 1
	goto skip6
skip5:
kpan2	port	   .5 + (kamp2 * kpan), .08
a1,a2,a3,a4 pan    aout, kpan2, 1, 2, 1
skip6:
	outs       a1 - (.02 * a2), a2 - (.02 * a1)
   
        endin

</CsInstruments>

<CsScore>

f1 0 512 16 1 511 2.2 1000
f2 0 8193 7 0 8193 1
i1 0 3600 6000 4 .5 .015
i2 0 3600 3000 4 .7 .02
i3 0 3600 4200 4 .8 .017
i4 0 3600 2000 4 .95 .01
i5 0 3600 1300 2 .6 .02
i6 0 3600 1500 2 .7 .02
i7 0 3600 2100 2 .8 .02
i8 0 3600 2200 2 .95 .014

e

</CsScore>
</CsoundSynthesizer>
