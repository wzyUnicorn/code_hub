
//*******************************************************************************
//
//   Cells included in this file

//    ******Digital I/O pads******
//    RCMCU_PLBMUX

//    ******Power pads******
//    RCMCU_PLVDDH
//    RCMCU_PLVDDH_NOPOC
//    RCMCU_PLVSSH
//    RCMCU_PLVDD
//    RCMCU_PLVSS
//    RCMCU_PLVDDHIS
//    RCMCU_PLVDDHI
//    RCMCU_PLVDDI
//    RCMCU_PLVDDHA
//    RCMCU_PLVSSHA
//    RCMCU_PLVDDA
//    RCMCU_PLVSSA

//    ******Analog pads******
//    RCMCU_PLAR

//    ******Other pads******
//    RCMCU_PLVDDHPOC
//    RCMCU_PLOSC
//    RCMCU_PLVPP
//    RCMCU_PLFLR1
//    RCMCU_PLFLR5
//    RCMCU_PLCORNER
//    RCMCU_PLPWBK
//
//********************************************************************************

//*****************************************************************
//      Cell Name:       RCMCU_PLBMUX  
//      Pad Type:        Bi IO with analogy pin
//*****************************************************************
`timescale 1ns/10ps
//`celldefine
  module RCMCU_PLBMUX (Y,YA, PAD, A, IE, OS, OD, PU, PD, CS, OE, DR, SR);
	output Y;
	inout  PAD;
        inout  YA;
	input  A;
	input  IE;
	input  OS;
        input  PD;
	input  OD; 
	input  PU;
	input  CS;

        input  OE;
        input  DR;
        input  SR;

        
	not _i0 (_n3,OD);
	not _i1 (_n4,OS);
	and _i2 (_n2,OD,OS);       // OD & OS
	and _i4 (_n5,A,OD,_n4);    // A & OD & !OS
	not _i5 (_n8,A);
	and _i7 (_n7,_n8,_n3,OS);  //!A &!OD & OS 
	nor _i8 (_n1,_n2,_n5,_n7, !OE);   

        rnmos i1 (_P,1'b0,PD);
        rnmos i2 (_P,1'b1,PU);

        nmos _i22 (_P,A,_n1);
	nmos _i24 (PAD,_P,1'b1);

	
	and _i26 (Y,PAD,IE); 
      //  rtran _i27 (YA,PAD);           

	specify
   if(DR == 1'b1 && SR == 1'b1)     (A => PAD) = (10,10);
   if(DR == 1'b1 && SR == 1'b0)     (A => PAD) = (10,10);
   if(DR == 1'b0 && SR == 1'b1)     (A => PAD) = (10,10);
   if(DR == 1'b0 && SR == 1'b0)     (A => PAD) = (10,10);
      (OE => PAD ) =(0.0,0.0,0.0,0.0,0.0,0.0);
        (PAD => Y) = (1,1);
 	endspecify

endmodule
//`endcelldefine








//**************************************************************
//      Cell Name:       RCMCU_PLVDDH 
//      Pad Type:        power pads 
//**************************************************************
`celldefine
module RCMCU_PLVDDH (VDDH);
    inout VDDH;
    supply1 VDDH;

endmodule
`endcelldefine


//**************************************************************
//      Cell Name:       RCMCU_PLVDDH_NOPOC
//      Pad Type:        power pads 
//**************************************************************
`celldefine
module RCMCU_PLVDDH_NOPOC (VDDH);
    inout VDDH;
    supply1 VDDH;

endmodule
`endcelldefine



//**************************************************************
//      Cell Name:       RCMCU_PLVSSH 
//      Pad Type:        ground pads 
//**************************************************************
`celldefine
module RCMCU_PLVSSH (VSSH);
    inout VSSH;
    supply0 VSSH;

endmodule
`endcelldefine

//**************************************************************
//      Cell Name:       RCMCU_PLVDD 
//      Pad Type:        power pads 
//**************************************************************
`celldefine
module RCMCU_PLVDD (VDD);
    inout VDD;
    supply1 VDD;

endmodule
`endcelldefine


//**************************************************************
//      Cell Name:       RCMCU_PLVSS 
//      Pad Type:        ground pads 
//**************************************************************
`celldefine
module RCMCU_PLVSS (GND);
    inout GND;
    supply0 GND;

endmodule
`endcelldefine





//**************************************************************
//      Cell Name:       RCMCU_PLVDDHIS
//      Pad Type:        power pads 
//**************************************************************
`celldefine
module RCMCU_PLVDDHIS (VDDHIS);
    inout VDDHIS;
    supply1 VDDHIS;

endmodule
`endcelldefine


//**************************************************************
//      Cell Name:       RCMCU_PLVDDHI 
//      Pad Type:        5v independent power/ground pads 
//**************************************************************
`celldefine
module RCMCU_PLVDDHI (VDDHI, VSSHI);
    inout VDDHI;
    supply1 VDDHI;

    inout VSSHI;
    supply0 VSSHI;

endmodule
`endcelldefine




//**************************************************************
//      Cell Name:       RCMCU_PLVDDI 
//      Pad Type:        1.8v independent power/ground pads 
//**************************************************************
`celldefine
module RCMCU_PLVDDI (VDDI, VSSI);
    inout VDDI;
    supply1 VDDI;

    inout VSSI;
    supply0 VSSI;

endmodule
`endcelldefine


//**************************************************************
//      Cell Name:       RCMCU_PLVDDHA 
//      Pad Type:        power pads 
//**************************************************************
`celldefine
module RCMCU_PLVDDHA (VDDHA);
    inout VDDHA;
    supply1 VDDHA;


endmodule
`endcelldefine



//**************************************************************
//      Cell Name:       RCMCU_PLVSSHA 
//      Pad Type:        ground pads 
//**************************************************************
`celldefine
module RCMCU_PLVSSHA (VSSHA);
    inout VSSHA;
    supply0 VSSHA;


endmodule
`endcelldefine




//**************************************************************
//      Cell Name:       RCMCU_PLVDDA 
//      Pad Type:        power pads 
//**************************************************************
`celldefine
module RCMCU_PLVDDA (VDDA);
    inout VDDA;
    supply1 VDDA;


endmodule
`endcelldefine


//**************************************************************
//      Cell Name:       RCMCU_PLVSSA 
//      Pad Type:        power pads 
//**************************************************************
`celldefine
module RCMCU_PLVSSA (VSSA);
    inout VSSA;
    supply0 VSSA;


endmodule
`endcelldefine






//**************************************************************
//      Cell Name:       RCMCU_PLA 
//      Pad Type:        analog pads 
//**************************************************************
/*`celldefine
module RCMCU_PLA (P);
    inout P;

endmodule
`endcelldefine*/



//**************************************************************
//      Cell Name:       RCMCU_PLAR 
//      Pad Type:        analog pads with resistor
//**************************************************************
`celldefine
module RCMCU_PLAR (PAD, YA);
    inout PAD;
    inout YA;
    rtran (YA, PAD);
    

endmodule
`endcelldefine
    



//**************************************************************
//      Cell Name:       RCMCU_PLVDDHPOC 
//      Pad Type:        Digital power domain power on control cell
//**************************************************************
`celldefine
module RCMCU_PLVDDHPOC ();
endmodule
`endcelldefine




//**************************************************************
//      Cell Name:       RCMCU_PLOSC 
//      Pad Type:        oscillator pads 
//**************************************************************
`celldefine
// Oscillator pad without resistor
// OSCOUT = !(EO&OSCIN);CLK = EI&OSCIN
module RCMCU_PLOSC (CLK, OSCOUT, EI, EO, OSCIN);
	output CLK;
	output OSCOUT;
	input  EI;
	input  EO;
	input  OSCIN;
	nand _i0 (OSCOUT,EO,OSCIN);
	and _i1 (CLK,EI,OSCIN);
	specify
	
	(EI => CLK) = (0,0);
	(EO => OSCOUT) = (0,0);
	if(!EI) (OSCIN => OSCOUT) = (0,0);
	if(!EO) (OSCIN => CLK) = (0,0);
	if(EI) (OSCIN => OSCOUT) = (0,0);
	if(EO) (OSCIN => CLK) = (0,0);
	ifnone (OSCIN => CLK) = (0,0);
	ifnone (OSCIN => OSCOUT) = (0,0);
	endspecify
endmodule
`endcelldefine





//**************************************************************
//      Cell Name:       RCMCU_PLVPP 
//      Pad Type:        eFlash 12V programming pad 
//**************************************************************
`celldefine
module RCMCU_PLVPP(VPP, TM0);
inout VPP;
inout TM0;

nmos (VPP, TM0, 1'b1);
endmodule
`endcelldefine



//**************************************************************
//      Cell Name:       PRCMCU_LFLR1
//      Pad Type:        filler cell
//**************************************************************
`celldefine
module RCMCU_PLFLR1 ();
endmodule
`endcelldefine


//**************************************************************
//      Cell Name:       PRCMCU_LFLR5
//      Pad Type:        filler cell
//**************************************************************
`celldefine
module RCMCU_PLFLR5 ();
endmodule
`endcelldefine



//**************************************************************
//      Cell Name:       RCMCU_PLCORNER
//      Pad Type:        corner cell
//**************************************************************
`celldefine
module RCMCU_PLCORNER ();
endmodule
`endcelldefine


//**************************************************************
//      Cell Name:       RCMCU_PLPWBK
//      Pad Type:        Power break cell
//**************************************************************
`celldefine
module RCMCU_PLPWBK ();
endmodule
`endcelldefine


