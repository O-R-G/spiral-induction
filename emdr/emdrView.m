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

    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) 
        [self setAnimationTimeInterval:1/30.0];

    // set globals

    radius = ( [self bounds].size.width / 5 );
    xCenter = ( [self bounds].size.width / 2 );
    yCenter = ( [self bounds].size.height / 2 );
    rows = 8;
    columns = 10;
    numberofpointsmax = 30; // [64] [102] [128] [256]
    grid = true;
    counter = 0;

    // set drawing context

    context = [NSGraphicsContext currentContext];
    red = [NSColor colorWithRed: 1.0 green: 0.0 blue: 0.0 alpha: 1.0];
    green = [NSColor colorWithRed: 0.25 green: 0.75 blue: 0.0 alpha: 1.0];
    blue = [NSColor colorWithRed: 0.0 green: 0.0 blue: 1.0 alpha: 1.0];

    // build spiral

    spiral = [[Spiral alloc] init];
    [spiral makeWithPoints: numberofpointsmax clockwise: false];

    // spiralsize = [spiral size];
    direction = [spiral direction];    
    // NSMutableArray* points = [spiral points];
    points = [spiral points];
    NSLog(@"points[2] -------------> : %@", [points objectAtIndex:2]);
    // NSLog(@"thispoints[2] -------------> : %@", [[spiral points] objectAtIndex:2]);

    // [spiral debug];

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

    [[NSColor blackColor] set];
    NSRectFill([self bounds]);
    
    // best fit bezier from points?
    // http://ymedialabs.github.io/blog/2015/05/12/draw-a-bezier-curve-through-a-set-of-2d-points-in-ios/

    // NSBezierPath* spiralDouble = [NSBezierPath bezierPath];
    // spiralDouble = [self buildBezierDoubleSpiralWithPath: spiralDouble clockwise: true drawBezierPoints: true numberofpoints: counter];
    NSBezierPath* spiralSingle = [NSBezierPath bezierPath];
    spiralSingle = [self buildBezierPathFromPoints: spiralSingle clockwise: true numberofpoints: counter];

    // draw
 
    // [xform set] adds all the new transform to the matrix
    // [xform concat] adds the new transform plus all existing transforms again to the matrix
    // [xform invert] undoes the previous transform by applying an inverse transform to matrix
    // [context saveGraphicsState] push current matrix onto the stack
    // [context restoreGraphicsState] pop current matrix off the stack

    NSAffineTransform* xform = [NSAffineTransform transform]; // identity transform (ground state)

    // 0. draw one spiral in screen center

    [green setStroke];
    // [spiralSingle setLineWidth:1.0];
    [spiralSingle setLineWidth:2.0];

    // [xform translateXBy: [self bounds].size.width/2 yBy: [self bounds].size.height/2];
    [xform translateXBy: 0 yBy: -100.0];
    [xform set];

    // 1. repeat / extrude 

    int extrude = 80;
    int offset = 16;    // [16]
    int columns = 10;
    int xoffset = 240;

    for (int x = 0; x < columns; x++) {

        [xform translateXBy: xoffset yBy: 0];
        [xform set];

        for (int i = 0; i < extrude; i++) {
            [xform translateXBy: -offset yBy: offset];
            [xform set];
            [spiralSingle stroke];
        }

        [xform translateXBy: extrude * offset yBy: -extrude * offset];
        [xform set];
    }

    // 1. wind up / wind down

    counter += direction;
    if (counter >= numberofpointsmax || counter <= 0) direction *= -1;
}




// bezier paths

// single 

- (NSBezierPath*)buildBezierPathFromPoints:(NSBezierPath*)path clockwise:(Boolean)clockwise 
numberofpoints:(int)numberofpoints {

    int spiraldirection = 1;
    if (!clockwise) spiraldirection = -1;

    [path moveToPoint:NSMakePoint(0.0, 0.0)];

    NSLog(@"=============>>>>> %d", numberofpoints);

    // for (int i = 0; i < [points count]; i++) {
    for (int i = 0; i < numberofpoints; i++) {

        id object = [points objectAtIndex:i];            
        NSPoint point = [object pointValue];
        // NSLog(@"=============>>>>> %@", NSStringFromPoint(point));

        [path lineToPoint:point];
    }

    return path;
}





/* 
// old tmp ** fix ** delete

- (NSBezierPath*)buildBezierSpiralWithPath:(NSBezierPath*)thisPath clockwise:(Boolean)clockwise 
drawBezierPoints:(Boolean)drawBezierPoints numberofpoints:(int)numberofpoints {
    int spiraldirection = 1;
    if (clockwise) spiraldirection = -1;

    [thisPath moveToPoint:NSMakePoint(0.0, 0.0)];

    for (float i = 0; i <= numberofpoints; i+=1.0) {

        float x = i * spiralsize * cos(secondtodegree(i) * spiraldirection);
        float y = i * spiralsize * sin(secondtodegree(i) * spiraldirection);
        [thisPath lineToPoint:NSMakePoint(x, y)];

        if (drawBezierPoints) {
            NSRect thisRect = (NSRect){ .origin.x = x, .origin.y = y, .size.width = 3.0, .size.height = 3.0 };
            NSBezierPath* aCircle = [NSBezierPath bezierPathWithOvalInRect:thisRect];
            [[NSColor blueColor] setFill];
            [aCircle setLineWidth:0.25];
            [aCircle fill];
        }
    }

    return thisPath;
}
*/

// double

- (NSBezierPath*)buildBezierDoubleSpiralWithPath:(NSBezierPath*)thisPath clockwise:(Boolean)clockwise 
drawBezierPoints:(Boolean)drawBezierPoints numberofpoints:(int)numberofpoints {

    // ** todo **
    // this builds a double spiral, when it arrives at max number of points then 
    // proceed to the next spiral, unwrapping it

    // ** fix ** 
    // draw from a logical centerpoint of the entire shape width (height is ok)

    int spiraldirection = 1;
    if (clockwise) spiraldirection = -1;

    // numberofpoints always = counter when called

    numberofpoints *= 2;                                    // double spiral, so 2 x numberofpoints
                                                            // more points draws faster
    int numberofpointsleft = numberofpoints;     
    int numberofpointsright = numberofpointsleft; 

    int xoffset = [self bounds].size.width / 15;
    int yoffset = [self bounds].size.height / 5;

    Boolean drawspiralright;

    [thisPath moveToPoint:NSMakePoint(0.0, 0.0)];
        
    float radlast;                                          // temp debug ** fix ** 

    if (counter >= numberofpointsmax / 2 ) {                // half
        // numberofpointsleft = numberofpointsmax;
        numberofpointsleft = numberofpointsmax - counter;
        numberofpointsright = numberofpointsmax - counter;
        drawspiralright = true;
    } else {
        // ?
    }

    drawspiralright = true;
    numberofpointsleft = numberofpointsmax - 10;
    
    // left

    if (!drawspiralright) {

        for (float i = 0; i <= numberofpointsleft; i+=1.0) {

            float x = i * spiralsize * cos(radians(secondtodegree(i)) * spiraldirection);
            float y = i * spiralsize * sin(radians(secondtodegree(i)) * spiraldirection);
            [thisPath lineToPoint:NSMakePoint(x, y)];        

            radlast = radians(secondtodegree(i));               // ** debug **  
        }

    } else {

        for (float i = numberofpointsleft; i >= 0; i-=1.0) {
 
            float x = i * spiralsize * cos(radians(secondtodegree(i)) * spiraldirection);
            float y = i * spiralsize * sin(radians(secondtodegree(i)) * spiraldirection);
            [thisPath lineToPoint:NSMakePoint(x, y)];        

            radlast = radians(secondtodegree(i));               // ** debug **  
        }
    }

/*
    // right

    if (drawspiralright) {

        // spiraldirection *= -1;                          // flip-flop spiral direction

        for (float i = numberofpointsright; i >= 0; i-=1.0) {
    
            float x = i * spiralsize * cos(radians(secondtodegree(i)) * spiraldirection) + xoffset;
            float y = i * spiralsize * sin(radians(secondtodegree(i)) * spiraldirection) + yoffset;
            [thisPath lineToPoint:NSMakePoint(x, y)];        

            radlast = radians(secondtodegree(i));               // ** debug **  
        }

    }
*/

    // debug radians and counter        

    if (counter == numberofpointsmax) 
        NSLog(@"**** SWITCH ****");

    // can switch when radians == 0.00 instead of on numberofpoints ... always == 0.00 here if numberofpoints = 120
    // b/c 120 is a multiple of 60 and a value in range 0-60 is fed to secondtodegree to produce value in range 0-360 
    // which is then converted to radians

    if (counter == numberofpointsmax / 2 ) {
        NSLog(@"**** half = %f ****", radlast);
        NSLog(@"counter --> %i", counter);
        NSLog(@"rad: %f", radlast);
    }

    return thisPath;
}





- (void)makeGrid {

    // in development

    /*

    // move this out to separate function?
    // 1. offset x, y to draw grid of spirals from centers based on screen width, height
        
    [xform translateXBy:-[self bounds].size.width/columns/2 yBy:-[self bounds].size.height/rows/2];
    [xform set];

    // columns

    for (int j = 0; j < columns; j++) {
  
        // rows (spiralRight)
            
        [xform translateXBy:[self bounds].size.width/columns yBy: 0.0];                 // shift x
        [xform set];

        for (int i = 0; i < rows; i++) {
            [xform translateXBy:0.0 yBy:[self bounds].size.height/rows];             // shift y
            [xform set];
            [spiralRight stroke];
        }

        // if edgesonly then increment j a lot and translate x a lot

        [xform translateXBy:0.0 yBy: -[self bounds].size.height];                       // reset y
            [xform set];

        // rows (spiralLeft)

        [xform translateXBy:[self bounds].size.width/columns yBy: 0.0];                 // shift x
        if (!grid) 
            [xform translateXBy:[self bounds].size.width/columns*8 yBy: 0.0];           // shift x to edge
                                                                                        // hardcoded, ** fix **
        [xform set];
 
        for (int i = 0; i < rows; i++) {
            [xform translateXBy:0.0 yBy:[self bounds].size.height/rows];                // shift y
            [xform set];
            [spiralLeft stroke];
        }

        [xform translateXBy:0.0 yBy: -[self bounds].size.height];                       // reset y
        [xform set];

        if (!grid) 
            j = columns;                                                                // exit loop
    }
    */
}



- (BOOL)hasConfigureSheet {
    return NO;
}

- (NSWindow*)configureSheet {
    return nil;
}

@end
