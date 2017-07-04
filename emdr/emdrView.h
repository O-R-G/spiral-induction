//
//  emdrView.h
//  emdr
//
//  Created by david reinfurt on 4/4/17.
//  Copyright © 2017 O-R-G inc. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>
#import "Spiral.h"

@interface emdrView : ScreenSaverView
{
    // Instance (global) variables
    
    // double radius, second;
    CGFloat radius;
    CGFloat sweephour, sweepminute, sweepsecond;    // NSDate (sweep)
    int hour, minute, second;                    // time_t (click)
    int xCenter, yCenter;
    int numberofspirals, numberofpointsmax;
    int rows, columns;
    int counter, direction;

    float spiralsize;       // temp ** fix **

    // objects 
    Spiral* spiral;
    NSMutableArray* points;

    NSGraphicsContext *context;
    NSColor *red, *green, *blue;        

    bool grid;              // draw spirals in a grid, otherwise l/r edges only
}

// - (void) checkTime_nsdate;

@end

