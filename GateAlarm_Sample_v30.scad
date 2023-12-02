//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for <template>
//
//  Version 3.0 (01-12-2023)
//
// This design is parameterized based on the size of a PCB.
//
//  for many or complex cutouts you might need to adjust
//  the number of elements:
//
//      Preferences->Advanced->Turn of rendering at 250000 elements
//                                                  ^^^^^^
//
//-----------------------------------------------------------------------

include <../YAPP_Box/library/YAPPgenerator_v30.scad>

// Note: length/lengte refers to X axis, 
//       width/breedte to Y, 
//       height/hoogte to Z

/*
            padding-back>|<---- pcb length ---->|<padding-front
                                 RIGHT
                   0    X-ax ---> 
               +----------------------------------------+   ---
               |                                        |    ^
               |                                        |   padding-right 
             ^ |                                        |    v
             | |    -5,y +----------------------+       |   ---              
        B    Y |         | 0,y              x,y |       |     ^              F
        A    - |         |                      |       |     |              R
        C    a |         |                      |       |     | pcb width    O
        K    x |         |                      |       |     |              N
               |         | 0,0              x,0 |       |     v              T
               |   -5,0  +----------------------+       |   ---
               |                                        |    padding-left
             0 +----------------------------------------+   ---
               0    X-ax --->
                                 LEFT
*/


//-- which part(s) do you want to print?
printBaseShell        = true;
printLidShell         = true;
printSwitchExtenders  = true;

//-- pcb dimensions -- very important!!!
// Electro cookie 30 row
pcbLength           = 88.9; // Front to back
pcbWidth            = 52.1; // Side to side
pcbThickness        = 1.7;
                            
//-- padding between pcb and inside wall
paddingFront        = 23;
paddingBack         = 3;
paddingRight        = 3;
paddingLeft         = 3;

//-- Edit these parameters for your own box dimensions
wallThickness       = 2.0;
basePlaneThickness  = 2.0;
lidPlaneThickness   = 2.0;

//-- Total height of box = lidPlaneThickness 
//                       + lidWallHeight 
//--                     + baseWallHeight 
//                       + basePlaneThickness
//-- space between pcb and lidPlane :=
//--      (bottonWallHeight+lidWallHeight) - (standoffHeight+pcbThickness)
baseWallHeight      = 12;
lidWallHeight       = 8;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight         = 5.0;
ridgeSlack          = 0.3;
roundRadius         = 2.0;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight      = 10.0;  //-- used only for pushButton and showPCB
standoffPinDiameter = 1.7;
standoffHoleSlack   = 0.4;
standoffDiameter    = 4.0;



//-- C O N T R O L -------------//-> Default ---------
showSideBySide      = true;     //-> true
previewQuality      = 5;        //-> from 1 to 32, Default = 5
renderQuality       = 12;       //-> from 1 to 32, Default = 8
onLidGap            = 0;
shiftLid            = 5;
colorLid            = "YellowGreen";   
alphaLid            = 1;//0.25;   
colorBase           = "BurlyWood";
alphaBase           = 1;//0.25;
hideLidWalls        = false;    //-> false
hideBaseWalls       = false;    //-> false
showOrientation     = true;
showPCB             = false;
showSwitches        = false;
showPCBmarkers      = false;
showShellZero       = false;
showCenterMarkers   = false;
inspectX            = 0;        //-> 0=none (>0 from back)
inspectY            = 0;        //-> 0=none (>0 from right)
inspectXfromBack    = false;    // View from the inspection cut foreward
inspectYfromLeft    = true;     // View from the inspection cut to the right
inspectZfromTop     = true;
//-- C O N T R O L ---------------------------------------

//===================================================================
// *** PCB Supports ***
// Pin and Socket standoffs 
//-------------------------------------------------------------------
//  Default origin =  yappCoordPCB : pcb[0,0,0]
//
//  Parameters:
//   Required:
//    (0) = posx
//    (1) = posy
//   Optional:
//    (2) = Height to bottom of PCB : Default = standoffHeight
//    (3) = PCB Gap : Default = -1 : Default for yappCoordPCB=pcbThickness, yappCoordBox=0
//    (4) = standoffDiameter    Default = standoffDiameter;
//    (5) = standoffPinDiameter Default = standoffPinDiameter;
//    (6) = standoffHoleSlack   Default = standoffHoleSlack;
//    (7) = filletRadius (0 = auto size)
//    (n) = { <yappBoth> | yappLidOnly | yappBaseOnly }
//    (n) = { yappHole, <yappPin> } // Baseplate support treatment
//    (n) = { <yappAllCorners> | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
//    (n) = { yappCoordBox, <yappCoordPCB> }  
//    (n) = { yappNoFillet }
//-------------------------------------------------------------------

pcbStands = [
  // Electro cookie 30 row
  [5.1, 8.25]
];


//===================================================================
//  *** Connectors ***
//  Standoffs with hole through base and socket in lid for screw type connections.
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//  
//  Parameters:
//   Required:
//    (0) = posx
//    (1) = posy
//    (2) = pcbStandHeight
//    (3) = screwDiameter
//    (4) = screwHeadDiameter (don't forget to add extra for the fillet)
//    (5) = insertDiameter
//    (6) = outsideDiameter
//   Optional:
//    (7) = PCB Gap : Default = -1 : Default for yappCoordPCB=pcbThickness, yappCoordBox=0
//    (8) = filletRadius : Default = 0/Auto(0 = auto size)
//    (n) = { <yappAllCorners> | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
//    (n) = { <yappCoordBox>, yappCoordPCB }
//    (n) = { yappNoFillet }
//-------------------------------------------------------------------

connectors   =
  [
  //  [9, 15, 10, 2.5, 6 + 1.25, 4.0, 9, 0, yappFrontRight]
  // ,[9, 15, 10, 2.5, 6+ 1.25, 4.0, 9, 0, yappFrontLeft]
  // ,[34, 15, 10, 2.5, 6+ 1.25, 4.0, 9, 0, yappFrontRight]
  // ,[34, 15, 10, 2.5, 6+ 1.25, 4.0, 9, 0, yappFrontLeft]
  ];

//===================================================================
//  *** Base Mounts ***
//    Mounting tabs on the outside of the box
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   Required:
//    (0) = pos
//    (1) = screwDiameter
//    (2) = width
//    (3) = height
//   Optional:
//    (4) = filletRadius : Default = 0/Auto(0 = auto size)
//    (n) = yappLeft / yappRight / yappFront / yappBack (one or more)
//    (n) = { yappNoFillet }
//-------------------------------------------------------------------

baseMounts =
[
//  [shellWidth/2, 3, 10, 3, yappFront, yappBack]//, yappCenter]
 //  [[10,10], 3, 0, 3, yappFront, yappBack]
];


//===================================================================
//  *** Cutouts ***
//    There are 6 cutouts one for each surface:
//      cutoutsBase, cutoutsLid, cutoutsFront, cutoutsBack, cutoutsLeft, cutoutsRight
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//                        Required                Not Used        Note
//                      +-----------------------+---------------+------------------------------------
//  yappRectangle       | width, length         | radius        |
//  yappCircle          | radius                | width, length |
//  yappRoundedRect     | width, length, radius |               |     
//  yappCircleWithFlats | width, radius         | length        | length=distance between flats
//  yappCircleWithKey   | width, length, radius |               | width = key width length=key depth
//  yappPolygon         | width, length         | radius        | yappPolygonDef object must be provided
//
//  Parameters:
//   Required:
//    (0) = from Back
//    (1) = from Left
//    (2) = width
//    (3) = length
//    (4) = radius
//    (5) = shape : {yappRectangle | yappCircle | yappPolygon | yappRoundedRect | yappCircleWithFlats | yappCircleWithKey}
//  Optional:
//    (6) = depth : Default = 0/Auto : 0 = Auto (plane thickness)
//    (7) = angle : Default = 0
//    (n) = { yappPolygonDef } : Required if shape = yappPolygon specified -
//    (n) = { yappMaskDef } : If a yappMaskDef object is added it will be used as a mask for the cutout.
//    (n) = { [yappMaskDef, hOffset, vOffset, rotations] } : If a list for a mask is added it will be used as a mask for the cutout. With the Rotation and offsets applied. THis can be used to fine tune the mask placement in the opening.
//    (n) = { <yappCoordBox> | yappCoordPCB }
//    (n) = { <yappOrigin>, yappCenter }
//  (n) = { yappLeftOrigin, <yappGlobalOrigin> } // Only affects Top, Back and Right Faces
//-------------------------------------------------------------------

cutoutsBase = 
[
  // Vent
  //[shellLength/2,shellWidth/2 ,55,55, 5, yappPolygon, shapeHexagon, maskHoneycomb, yappCenter]
];

cutoutsLid  = 
[
  // Cutout for piezo buzzer
  [25,shellWidth/2 ,0,0, 29.8/2, yappCircle ,yappCenter] 
  // Cutout for Mute button
 ,[shellLength - 15,shellWidth/2 ,0,0, 6.5, yappCircle ,yappCenter]

//Center test
//  [shellLength/2,shellWidth/2 ,1,1, 5 ,20 ,45, yappRectangle,yappCenter]
// ,[pcbLength/2,pcbWidth/2 ,1,1, 5 ,20 ,45, yappRectangle,yappCenter, yappCoordPCB]
//Edge tests
// ,[shellLength/2,0,             2, 2, 5 ,20 ,45, yappRectangle,yappCenter]
// ,[shellLength/2,shellWidth,    2, 2, 5 ,20 ,45, yappRectangle,yappCenter]
// ,[0,            shellWidth/2,    2, 2, 5 ,20 ,45, yappRectangle,yappCenter]
// ,[shellLength,  shellWidth/2,    2, 2, 5 ,20 ,45, yappRectangle,yappCenter]
/**/
];

cutoutsFront =  
[

];


cutoutsBack = 
[
  // Cutout for USB
 [pcbWidth/2, -5 -pcbThickness ,12.5,7.0, 2, yappRoundedRect , yappCenter, yappCoordPCB]
];

cutoutsLeft =   
[

];

cutoutsRight =  
[
  //Cutout for cable
  [40,6 ,0,0, 3.25, yappCircle,yappCenter]
];


//===================================================================
//  *** Snap Joins ***
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   Required:
//    (0) = posx | posy
//    (1) = width
//    (n) = yappLeft / yappRight / yappFront / yappBack (one or more)
//   Optional:
//    (n) = { <yappOrigin> | yappCenter }
//    (n) = { yappSymmetric }
//    (n) = { yappRectangle } == Make a diamond shape snap
//-------------------------------------------------------------------

snapJoins =   
[
  [(shellWidth/2),     10, yappFront,yappBack, yappCenter, yappRectangle]
 //,[25,  10, yappBack, yappBack, yappSymmetric, yappCenter]
 ,[(shellLength/2),    10, yappLeft, yappRight, yappCenter, yappRectangle]
];

//===================================================================
//  *** Light Tubes ***
//-------------------------------------------------------------------
//  Default origin = yappCoordPCB: PCB[0,0,0]
//
//  Parameters:
//   Required:
//    (0) = posx
//    (1) = posy
//    (2) = tubeLength
//    (3) = tubeWidth
//    (4) = tubeWall
//    (5) = gapAbovePcb
//    (6) = tubeType    {yappCircle|yappRectangle}
//   Optional:
//    (7) = lensThickness (how much to leave on the top of the lid for the light to shine through 0 for open hole : Default = 0/Open
//    (8) = Height to top of PCB : Default = standoffHeight+pcbThickness
//    (9) = filletRadius : Default = 0/Auto 
//    (n) = { yappCoordBox, <yappCoordPCB> }
//    (n) = { yappNoFillet }
//-------------------------------------------------------------------

lightTubes =
[
  
  [pcbLength-(8.820),(pcbWidth/2)-3.810, // Pos
    6, 6,                 // W,L
    1.2,                      // wall thickness
    2,                      // Gap above PCB
    yappCircle,          // tubeType (Shape)
    yappCenter            //
  ]
 ,[pcbLength-(8.820+10.16),(pcbWidth/2)-3.810, // Pos
    6, 6,                 // W,L
    1.2,                      // wall thickness
    2,                      // Gap above PCB
    yappCircle,          // tubeType (Shape)
    yappCenter            //
  ]
 ,[pcbLength-(8.820+10.16+10.16),(pcbWidth/2)-3.810, // Pos
    6, 6,                 // W,L
    1.2,                      // wall thickness
    2,                      // Gap above PCB
    yappCircle,          // tubeType (Shape)
    yappCenter            //
  ]
 ,[pcbLength-(8.820),(pcbWidth/2)+3.810+5.08, // Pos
    6, 6,                 // W,L
    1.2,                      // wall thickness
    2,                      // Gap above PCB
    yappCircle,          // tubeType (Shape)
    yappCenter            //
  ]
 ,[pcbLength-(8.820+10.16),(pcbWidth/2)+3.810+5.08, // Pos
    6, 6,                 // W,L
    1.2,                      // wall thickness
    2,                      // Gap above PCB
    yappCircle,          // tubeType (Shape)
    0,                    // lensThickness
    yappCenter            //
  ]
];

//===================================================================
//  *** Push Buttons ***
//-------------------------------------------------------------------
//  Default origin = yappCoordPCB: PCB[0,0,0]
//
//  Parameters:
//   Required:
//    (0) = posx
//    (1) = posy
//    (2) = capLength for yappRectangle, capDiameter for yappCircle
//    (3) = capWidth for yappRectangle, not used for yappCircle
//    (4) = capAboveLid
//    (5) = switchHeight
//    (6) = switchTravel
//    (7) = poleDiameter
//   Optional:
//    (8) = Height to top of PCB : Default = standoffHeight + pcbThickness
//    (9) = buttonType  {yappCircle|<yappRectangle>} : Default = yappRectangle
//    (10) = filletRadius : Default = 0/Auto 
//-------------------------------------------------------------------

pushButtons = 
[

];
             
//===================================================================
//  *** Labels ***
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   (0) = posx
//   (1) = posy/z
//   (2) = rotation degrees CCW
//   (3) = depth : positive values go into case (Remove) negative valies are raised (Add)
//   (4) = plane {yappLeft | yappRight | yappFront | yappBack | yappTop | yappBottom}
//   (5) = font
//   (6) = size
//   (7) = "label text"
//-------------------------------------------------------------------

labelsPlane =
[
    [5, 18, -90, 1, yappTop, "Liberation Mono:style=bold", 5, "DMR" ]

    ,[83.5, 22, -90, 1, yappTop, "Liberation Mono:style=bold", 4, "Front" ]
    ,[83.5-10.16, 22, -90, 1, yappTop, "Liberation Mono:style=bold", 4, "Drive" ]
    ,[83.5-10.16-10.16, 22, -90, 1, yappTop, "Liberation Mono:style=bold", 4, "Rear" ]
    ,[83.5, 60, -90, 1, yappTop, "Liberation Mono:style=bold", 4, "Alarm" ]
    ,[83.5-10.16, 59.8, -90, 1, yappTop, "Liberation Mono:style=bold", 4, "Muted" ]
    ,[shellLength-17, 57, -90, 1, yappTop, "Liberation Mono:style=bold", 4, "Mute" ]
];


//---- This is where the magic happens ----
YAPPgenerate();
