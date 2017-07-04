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

    context = [NSGraphicsContext currentContext];
    red = [NSColor colorWithRed: 1.0 green: 0.0 blue: 0.0 alpha: 1.0];
    green = [NSColor colorWithRed: 0.25 green: 0.75 blue: 0.0 alpha: 1.0];
    blue = [NSColor colorWithRed: 0.0 green: 0.0 blue: 1.0 alpha: 1.0];
    [[NSColor blackColor] setFill];

    // spiral

    numberofpointsmax = 30;                     // [64] [102] [128] [256]
    spiral = [[Spiral alloc] init];
    [spiral makeWithPoints: numberofpointsmax clockwise: false];
    direction = [spiral direction];    
    points = [spiral points];

    // grid
              
    rows = 4;
    columns = 5;
    extrudes = 20;
    offsetx = [self bounds].size.width / (columns + 1);     // between columns
    offsety = [self bounds].size.height / (rows + 1);       // between rows
    offsetz = 4;                                            // between extrudes

    // utility

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

    // draw

    NSRectFill([self bounds]);                                  // clear screen

    NSBezierPath* spiralSingle = [NSBezierPath bezierPath];
    spiralSingle = [self buildBezierPathFromPoints: spiralSingle clockwise: true numberofpoints: counter];
    [spiralSingle setLineWidth:1.0];
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
                [spiralSingle stroke];
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
    if (counter >= numberofpointsmax || counter <= 0) direction *= -1;
    if (debug) counter = numberofpointsmax;
}

// bezier paths

- (NSBezierPath*)buildBezierPathFromPoints:(NSBezierPath*)path 
clockwise:(Boolean)clockwise numberofpoints:(int)numberofpoints {
    
    // add function to only draw part of curve, beginning and ending parameters
    // which point to points[]

    int spiraldirection = 1;
    if (!clockwise) spiraldirection = -1;

    [path moveToPoint:NSMakePoint(0.0, 0.0)];

    for (int i = 0; i < numberofpoints; i++) {

        id object = [points objectAtIndex:i];            
        NSPoint point = [object pointValue];

        if (debug) NSLog(@"=============>>>>> %@", NSStringFromPoint(point));
        if (debug) NSLog(@"=============>>>>> %d", numberofpoints);

        [path lineToPoint:point];
    }

    return path;
}

- (BOOL)hasConfigureSheet {
    return NO;
}

- (NSWindow*)configureSheet {
    return nil;
}

@end
