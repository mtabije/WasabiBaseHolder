//Base Clip holder for Wasabi Wars
//  by Mark Tabije

//Creating Modular pieces that join via dove tail.


//Notes:  Simple base 30mm is 38mm width, 5.5 height, symbol clip is 5.88 height.

/* [Basic] */

boxDepth = 18;      //Depth of Storage device in mm
boxBottomThickness = .6;

rowsOfLevelClips = 5;
colsOfLevelClips = 2;
rowsOfSymbolClips = 5;
colsOfSymbolClips = 6;
//rowsOfSymbolClips = 3;
//colsOfSymbolClips = 3;


includeLevelClip = true;   //Include slots for Level Clips 
levelClipHeight = 6;     //Height of Level Clip slots
levelClipWidth = 44;        //Width of Level Clip slots  (44m for 30mmSmallBase_V2a; 33mm for 20mmSmallBase_V2a)

includeSymbolClip = true;   //Include slots for Symbol Clips 
symbolClipHeight = 7;     //Height of Symbol Clip slots
symbolClipWidth = 7.5;        //Width of Symbol Clip slots

includeBase = false;    //Include slots for bases
baseHeight = 0;         //Height of Base slots
baseWidth = 0;          //Width of Base slots


/* [Advanced] */
innerWallThickness = 1;
outerWallThickness = 2;

connectorLongSide = 7;  //Male Connector
connectorShortSide = 5; //Male Connector
connectorDepth = 3;     //Male Connector
connectorFemaleSupportSide = 10; 
connectorTolerance = .3;

//********** Set Box Width ************
//*** Uncomment for Manual Version of Box Width and height 
//boxWidth = 140;
//boxHeight = 46.5;

//*** Uncomment for Automated Version of Box Width and height - You must manually change the formula based on the cuttout you are using
//Level Clips
    //boxWidth = outerWallThickness*2 + (levelClipWidth+innerWallThickness)*colsOfLevelClips-innerWallThickness;
    //boxHeight = outerWallThickness*2 + (levelClipHeight+innerWallThickness)*rowsOfLevelClips-innerWallThickness;
//Symbol Clips
    boxWidth = outerWallThickness*2 + (symbolClipWidth+innerWallThickness)*colsOfSymbolClips-innerWallThickness;
    boxHeight = outerWallThickness*2 + (symbolClipHeight+innerWallThickness)*rowsOfSymbolClips-innerWallThickness;

//********** Set Connector Position ************
//*** Uncomment for Manual Version of Connector Position
//connectorOffsetX = 45;
connectorOffsetY = 18; //(18mm for SmallBaseV2 5 rows;)

//*** Uncomment for Automated Version of Connector Position which is 1/2 way.
connectorOffsetX = boxWidth/2;
//connectorOffsetY = boxHeight/2;

echo("connectorOffsetX: ",connectorOffsetX);
echo("connectorOffsetY: ",connectorOffsetY);

/* [Hidden] */



//**** Main

//Calculating where to start the Symbol Clips (after level Clips)
startSymbolClipsX = outerWallThickness + colsOfLevelClips*(innerWallThickness+levelClipWidth);


difference()
{
    //Main Block and Connector
    union()
    {
     
        //Main Block - BUG/DEV need to parametrticise this
        cube([boxWidth, boxHeight, boxDepth]);
        
        //Quad Connectors starting at the left side and going clockwise
        //Quad Connector 1 
        translate([0,connectorOffsetY,0])
            rotate([0,0,90])
                quadConnector(connectorDepth, connectorLongSide, connectorShortSide, boxDepth, 10, connectorTolerance, false);
        
        //Quad Connector 2
            translate([connectorOffsetX,boxHeight,0])
                rotate([0,0,0])
                    quadConnector(connectorDepth, connectorLongSide, connectorShortSide, boxDepth, 10, connectorTolerance, false);
      
        //Quad Connector 3 
        translate([boxWidth,connectorOffsetY,0])
            rotate([0,0,-90])
                quadConnector(connectorDepth, connectorLongSide, connectorShortSide, boxDepth, 10, connectorTolerance, false);
        
        //Quad Connector 4
            translate([connectorOffsetX,0,0])
                rotate([0,0,180])
                    quadConnector(connectorDepth, connectorLongSide, connectorShortSide, boxDepth, 10, connectorTolerance, false);
        
        
        /*  Old connector idea
            //Male Connector 1
            translate([0,boxHeight/2,0])
                rotate([0,0,90])
                    maleConnector(connectorDepth, connectorLongSide, connectorShortSide, boxDepth);
            
            //Male Connector 2
            translate([boxWidth/2,0,0])
                rotate([0,0,180])
                    maleConnector(connectorDepth, connectorLongSide, connectorShortSide, boxDepth);
            
            //Instead of female connector and male connectors code using quad connectors 2 male connectors 
            //  on both sides.
            
            //Female Connector 2
            translate([boxWidth/2,0,0])
                rotate([0,0,180])
                    femaleConnector(connectorDepth, connectorLongSide, connectorShortSide, boxDepth, 10, connectorTolerance, false);
        */
     }
    
    //**********  Set pieces to Cutt **************
    //Cut Level Clips
    //createCutOuts(levelClipWidth, levelClipHeight, boxDepth, rowsOfLevelClips, colsOfLevelClips, outerWallThickness, innerWallThickness, boxBottomThickness, 0, 0);

    //Cut Abiliy Clips
    //createCutOuts(symbolClipWidth, symbolClipHeight, boxDepth, rowsOfSymbolClips, colsOfSymbolClips, outerWallThickness, innerWallThickness, boxBottomThickness, startSymbolClipsX, 0);
    createCutOuts(symbolClipWidth, symbolClipHeight, boxDepth, rowsOfSymbolClips, colsOfSymbolClips, outerWallThickness, innerWallThickness, boxBottomThickness, 0, 0);

}


//**** Support Modules
module createCutOuts(cutWidth, cutHeight, cutDepth, numRows, numCols, outerSpacing, innerSpacing, bottomSpacing, initialX, initialY)
{
    rowIncrement = cutHeight + innerSpacing;
    colIncrement = cutWidth + innerSpacing;
    rowMax = initialY + rowIncrement * numRows;
    colMax = initialX + colIncrement * numCols;
   
    for (a=[outerSpacing+initialX:colIncrement:colMax])    
    {
        for (b=[outerSpacing+initialY:rowIncrement:rowMax])
        {   
            translate([a, b, bottomSpacing])
                cube([cutWidth, cutHeight, cutDepth]);    
        }
    }    
    
    
}

module prism(l, w, h)
{
       polyhedron(
               points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
               faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
               );
}

module maleConnector(cDepth, cLongWidth, cShortWidth, cHeight)
{
        //Converting values to work with prism
        cw = cDepth;
        ch = cShortWidth;
        cl = cHeight;
  
        pw = cDepth;
        //ph = cLongWidth/2;
        ph = (cLongWidth - cShortWidth)/2;
        pl = cHeight;
    
        rotate([0,-90,0])
        {
            union()
            {
                    
                translate([0,0,-cShortWidth/2])
                    cube([cl,cw,ch]);
                
                translate([0,0,cShortWidth/2])
                    prism(pl,pw,ph);
                
                mirror([0,0,1])
                    translate([0,0,cShortWidth/2])
                        prism(pl,pw,ph);//prism(pl,pw,ph);
            }
        } 
}


module femaleConnector(cDepth, cLongWidth, cShortWidth, cHeight, cSupport, cTolerance, supportOnly)
{
        //BUG/DEV cSupport not coded yet.  This is supposed to make the female part wider for more support. 
    
        //Converting values to work with prism
        cw = cDepth;
        ch = cShortWidth;
        cl = cHeight;
  
        pw = cDepth;
        ph = (cLongWidth - cShortWidth)/2;
        pl = cHeight;
    
        translate([-(cShortWidth+(cLongWidth-cShortWidth)/2+cTolerance),cDepth,1])
            rotate([0,-90,180])
            {
                union()
                {
                        
                    translate([0,0,-cShortWidth/2])
                        cube([cl,cw,ch]);
                    
                    translate([0,0,cShortWidth/2])
                        prism(pl,pw,ph);
                    
                    mirror([0,0,1])
                        translate([0,0,cShortWidth/2])
                            prism(pl,pw,ph);//prism(pl,pw,ph);
                }
            } 
         
         translate([-(cShortWidth+(cLongWidth-cShortWidth)/2+cTolerance),cDepth,1])
            rotate([0,-90,180])
            {
                union()
                {
                        
                    translate([0,0,-cShortWidth/2])
                        cube([cl,cw,ch]);
                    
                    translate([0,0,cShortWidth/2])
                        prism(pl,pw,ph);
                    
                    mirror([0,0,1])
                        translate([0,0,cShortWidth/2])
                            prism(pl,pw,ph);//prism(pl,pw,ph);
                }
            }
}

module quadConnector(cDepth, cLongWidth, cShortWidth, cHeight, cSupport, cTolerance, supportOnly)
{
    //This creates 2 dove tails that will fit a mirror image of them.  They are shifted
    //to the right.
    
    midpointOfDiagonal = (cLongWidth - cShortWidth)/4;
    initialShiftX = cShortWidth/2 + midpointOfDiagonal+cTolerance/2;
    wholeShiftX = cShortWidth+(cLongWidth-cShortWidth)/2+cTolerance;
    
    translate([-initialShiftX,0,0])
        maleConnector(connectorDepth, connectorLongSide, connectorShortSide, boxDepth);
    
    translate([-initialShiftX+wholeShiftX*2,0,0])
        maleConnector(connectorDepth, connectorLongSide, connectorShortSide, boxDepth);
    

    //Uncomment Below for testing purposes
    /*
        translate([initialShiftX,cDepth,0])
            rotate([0,0,180])
                maleConnector(connectorDepth, connectorLongSide, connectorShortSide, boxDepth);
      
        translate([initialShiftX-wholeShiftX*2,cDepth,0])
            rotate([0,0,180])
                maleConnector(connectorDepth, connectorLongSide, connectorShortSide, boxDepth);
    */
}

    