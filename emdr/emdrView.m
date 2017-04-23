//
//  emdrView.m
//  emdr
//
//  Created by david reinfurt on 4/4/17.
//  Copyright © 2017 O-R-G inc. All rights reserved.
//

#import "emdrView.h"

@implementation emdrView

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/30.0];
    }

    // set globals

    radius = ( [self bounds].size.width / 5 );
    xCenter = ( [self bounds].size.width / 2 );
    yCenter = ( [self bounds].size.height / 2 );
    rows = 8;
    columns = 13;  
    numberofpointsmax = 112;       // [64] [128] [256]
    counter = 0;
    direction = 1;
    spiralsize = 0.45;        // [0.25] [0.35] [1.0]
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{

    // using cocoa drawing (NS) (a superset of quartz 2d (CG))

    NSGraphicsContext* context = [NSGraphicsContext currentContext];

    // colors    
    NSColor* yellow = [NSColor colorWithRed: 1.0 green: 1.0 blue: 0.0 alpha: 1.0];
    NSColor* red = [NSColor colorWithRed: 1.0 green: 0.0 blue: 0.0 alpha: 1.0];
    NSColor* blue = [NSColor colorWithRed: 0.0 green: 0.0 blue: 1.0 alpha: 1.0];
    
    // get time
    [self checkTime_nsdate];        // system time milliseconds (CGFloat) sweep
    
    // bg     
    [[NSColor blackColor] set];
    NSRectFill([self bounds]);
    
    // spirals
    // better to just make a spiral object? with properties?
    // could also "animate" the spiral in the build method, like an update using a counter
    // best fit bezier from points? 
    // http://ymedialabs.github.io/blog/2015/05/12/draw-a-bezier-curve-through-a-set-of-2d-points-in-ios/

    NSBezierPath* spiralLeft = [NSBezierPath bezierPath];
    NSBezierPath* spiralRight = [NSBezierPath bezierPath];
    spiralLeft = [self buildBezierSpiralWithPath: spiralLeft clockwise: true drawBezierPoints: false numberofpoints: counter];
    spiralRight = [self buildBezierSpiralWithPath: spiralRight clockwise: false drawBezierPoints: false numberofpoints: counter];

    // draw
 
    // [xform set] adds all the new transform to the matrix
    // [xform concat] adds the new transform plus all existing transforms again to the matrix
    // [xform invert] undoes the previous transform by applying an inverse transform to matrix
    // [context saveGraphicsState] push current matrix onto the stack
    // [context restoreGraphicsState] pop current matrix off the stack

    NSAffineTransform* xform = [NSAffineTransform transform];           // identity transform (ground state)

    [spiralRight setLineWidth:1.0];
    [spiralLeft setLineWidth:1.0];
    [yellow setStroke];

    // offset x, y 
        
    [xform translateXBy:-[self bounds].size.width/columns/2 yBy:-[self bounds].size.height/rows/2];   
    [xform set];

    // columns

    for (int j = 0; j < columns; j++) {
  
        // rows (left)

        [xform translateXBy:[self bounds].size.width/columns yBy: 0.0];                 // shift x
        [xform set];
 
        for (int i = 0; i < rows; i++) {
            [xform translateXBy:0.0 yBy:[self bounds].size.height/rows];                // shift y
            [xform set];          
            [spiralLeft stroke];
        }

        [xform translateXBy:0.0 yBy: -[self bounds].size.height];                       // reset y
        [xform set];

        // rows (right)

        [xform translateXBy:[self bounds].size.width/columns yBy: 0.0];                 // shift x
        [xform set];  
 
        for (int i = 0; i < rows; i++) {
            [xform translateXBy:0.0 yBy:[self bounds].size.height/rows];                // shift y
            [xform set];          
            [spiralRight stroke];
        }

        [xform translateXBy:0.0 yBy: -[self bounds].size.height];                       // reset y
        [xform set];
    }

    // wind up, wind down

    counter += direction;
    if (counter >= numberofpointsmax || counter <= 0) direction *= -1;

    [context flushGraphics];     // necessary?
}

- (NSBezierPath*)buildBezierSpiralWithPath:(NSBezierPath*)thisPath clockwise:(Boolean)clockwise drawBezierPoints:(Boolean)drawBezierPoints numberofpoints:(int)numberofpoints
{
    int spiraldirection = 1;
    if (!clockwise) spiraldirection = -1;

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

- (void) checkTime_nsdate
{
    // get current time in milliseconds
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"hh:mm:ss.SSS";
    NSString *string = [formatter stringFromDate: now];
    NSArray *timeComponents = [string componentsSeparatedByString:@":"];
    
    NSInteger hr = [timeComponents[0] integerValue];
    NSInteger min = [timeComponents[1] integerValue];
    sweepsecond = [timeComponents[2] floatValue];
    sweepminute = min + (sweepsecond / 60.0);
    sweephour = hr + (sweepminute / 60.0);
    
    return;
}

- (void)debugText:(CGFloat)xPosition yPosition:(CGFloat)yPosition canvasWidth:(CGFloat)canvasWidth canvasHeight:(CGFloat)canvasHeight
{
    //Draw Text
    CGRect textRect0 = CGRectMake(xPosition, yPosition, canvasWidth, canvasHeight);
    CGRect textRect1 = CGRectMake(xPosition, yPosition-12, canvasWidth, canvasHeight);
    CGRect textRect2 = CGRectMake(xPosition, yPosition-24, canvasWidth, canvasHeight);
    NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    textStyle.alignment = NSTextAlignmentLeft;
    NSDictionary* textFontAttributes = @{NSFontAttributeName: [NSFont fontWithName: @"Courier New" size: 12], NSForegroundColorAttributeName: NSColor.redColor, NSParagraphStyleAttributeName: textStyle};
    
    NSString *debug0 = [NSString stringWithFormat: @"0 :  %f", sweephour];
    NSString *debug1 = [NSString stringWithFormat: @"1 :  %f", sweepminute];
    NSString *debug2 = [NSString stringWithFormat: @"2 :  %f", sweepsecond];
    
    /*
     // output to log
     
     NSLog(@"====================================================================");
     NSLog(@"h: %f", sweephour);
     NSLog(@"m: %f", sweepminute);
     NSLog(@"s %f", sweepsecond);
     NSLog(@"====================================================================");
     */
    
    [debug0 drawInRect: textRect0 withAttributes: textFontAttributes];
    [debug1 drawInRect: textRect1 withAttributes: textFontAttributes];
    [debug2 drawInRect: textRect2 withAttributes: textFontAttributes];
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
