//
//  emdrView.h
//  emdr
//
//  Created by david reinfurt on 4/4/17.
//  Copyright © 2017 O-R-G inc. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>
#import "Spiral.h"

@interface emdrView : ScreenSaverView {

    // globals
    
    int pointsmax;
    int counter, direction;
    int rows, columns, extrudes, offsetx, offsety, offsetz;
    double millis, thismillis, lastmillis, millissinceupdate;
    double timerstep;
    bool debug;              
 
    // objects

    Spiral* spiral; 
    NSMutableArray* points;
    NSGraphicsContext *context;
    NSColor *red, *green, *blue;        
}

@end

