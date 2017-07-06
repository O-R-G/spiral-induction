// 
// emdrView.m 
// emdr 
// 
// Created by david reinfurt on 4/4/17. 
// Copyright © 2017 O-R-G inc. All rights reserved. 
//

#import "emdrView.h"
#import <Foundation/Foundation.h>
#import "Spiral.m"

@implementation emdrView

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview {

    // self 

    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) 
        [self setAnimationTimeInterval:1/30.0];

    // graphics context
    // using cocoa drawing (NS) (a superset of quartz 2d (CG))

    context = [NSGraphicsContext currentContext];
    // [NSBezierPath setDefaultFlatness: 10.0];
    red = [NSColor colorWithRed: 1.0 green: 0.0 blue: 0.0 alpha: 1.0];
    green = [NSColor colorWithRed: 0.25 green: 0.75 blue: 0.0 alpha: 1.0];
    blue = [NSColor colorWithRed: 0.0 green: 0.0 blue: 1.0 alpha: 1.0];
    [[NSColor blackColor] setFill];

    // spiral

    pointsmax = 30;
    float scaler = .001;
    float sizer = [self bounds].size.width * scaler;
    spiral = [[Spiral alloc] initWithSize: sizer];
    [spiral makeWithPoints: pointsmax clockwise: false];
    direction = [spiral direction];  
    points = [spiral points];

    // grid
              
    rows = 6;
    columns = 9;
    extrudes = 15;
    offsetx = [self bounds].size.width / (columns + 1);     // between columns
    offsety = [self bounds].size.height / (rows + 1);       // between rows
    offsetz = 4;                                            // between extrudes

    // utility

    timerstep = 50.0;                                       // millis (max speed)
    debug = false;
    counter = 0;

    if (debug) [spiral debug];
    if (debug) NSLog(@"offsetx [self bounds].size.width = %f", [self bounds].size.width);
    if (debug) NSLog(@"offsetx = %d", offsetx);
    if (debug) NSLog(@"offsety [self bounds].size.height = %f", [self bounds].size.height);
    if (debug) NSLog(@"offsety = %d", offsety);

    return self;
}

- (void)startAnimation {
    [super startAnimation];
}

- (void)stopAnimation {
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect {
    [super drawRect:rect];
}

- (void)animateOneFrame {

    // update?

    lastmillis = thismillis;
    thismillis = [self millis];
    double elapsedmillis = thismillis - lastmillis;
    if (elapsedmillis < timerstep) millissinceupdate += elapsedmillis;
    else millissinceupdate = elapsedmillis;

    // draw 

    if (millissinceupdate > timerstep) {

        NSRectFill([self bounds]);                  // clear screen

        NSBezierPath* spiralPath = [NSBezierPath bezierPath];
        spiralPath = [self buildBezierPathFromPointsWithIndex: spiralPath 
clockwise: false numberofpoints: counter indexstart: 0 indexdirection: 
direction];
        [spiralPath setLineWidth:1.0];
        [green setStroke];

        NSAffineTransform* xform = [NSAffineTransform transform];   // identity
        [xform translateXBy: 0.0 yBy: -offsety / 3];                // adjust

        for (int y = 0; y < rows; y++) {

            // row

            [xform translateXBy: 0.0 yBy: offsety];
            [xform set];

            for (int x = 0; x < columns; x++) {         

                // column

                [xform translateXBy: offsetx yBy: 0.0];
                [xform set];

                for (int i = 0; i < extrudes; i++) {

                    // extrude

                    [xform translateXBy: -offsetz yBy: offsetz];
                    [xform set];
                    [spiralPath stroke];
                }
            
                // reset extrude

                [xform translateXBy: offsetz * extrudes yBy: -offsetz * extrudes];
                [xform set];
            }            
            
            // reset column

            [xform translateXBy: -offsetx * columns yBy: 0.0];
            [xform set];
        }

        // wind up / down

        counter += direction;
        if (counter >= pointsmax || counter <= 0) direction *= -1;

        millissinceupdate = 0;
    }
}



/* bezier paths */

- (NSBezierPath*)buildBezierPathFromPointsWithIndex:(NSBezierPath*)path 
clockwise:(Boolean)clockwise numberofpoints:(int)numberofpoints indexstart: 
(int)indexstart indexdirection:(int)indexdirection {
    
    int index = indexstart;
    if (!indexstart) indexstart = 0;
    if (!indexdirection) indexdirection = 1;            // 1 | -1
    indexdirection = 1;                              // force roll unroll
 
    numberofpoints = numberofpoints - indexstart;

    id object = [points objectAtIndex:indexstart];
    NSPoint point = [object pointValue];
    [path moveToPoint:point];                           // 0,0

    for (int i = 0; i < numberofpoints; i++) {

        id object = [points objectAtIndex:index];
        NSPoint point = [object pointValue];
        [path lineToPoint:point];
    
        index+=indexdirection;

        if (index > [points count] - 1) index = [points count] -1;
        if (index < 0) index = 0;
    }

    return path;
}

- (BOOL)hasConfigureSheet {
    return NO;
}

- (NSWindow*)configureSheet {
    return nil;
}



/* utility */

- (double) millis {

    NSTimeInterval seconds = [NSDate timeIntervalSinceReferenceDate];
    double milliseconds = seconds*1000;

    return milliseconds;
}

@end
