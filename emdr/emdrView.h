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
    
    int counter, direction;
    int rows, columns, extrudes, offsetx, offsety, offsetz;
    int numberofpointsmax;

    // objects

    Spiral* spiral;
    NSMutableArray* points;
    NSGraphicsContext *context;
    NSColor *red, *green, *blue;        

    // utility

    bool debug;              
}

@end

