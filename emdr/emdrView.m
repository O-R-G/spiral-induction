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

    // set global dims

    xCenter = ( [self bounds].size.width / 2 );
    yCenter = ( [self bounds].size.height / 2 );
    radius = ( [self bounds].size.width / 5 );
    
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
    // get Core Graphics (CG) graphics context (Quartz 2D)
    
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetShouldAntialias(context, 1);
    
    // get graphics context for push/pop
    // https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CocoaDrawingGuide/GraphicsContexts/GraphicsContexts.html

    NSGraphicsContext* theContext = [NSGraphicsContext currentContext];

    // set colors
    
    CGColorRef blue = CGColorCreateGenericRGB(1.0, 0.0, 0.0, 1.0);
    CGColorRef yellow = CGColorCreateGenericRGB(0.0, 0.7, 0.18, 1.0);
    
    // get time
    
    [self checkTime_nsdate];        // system time milliseconds (CGFloat) sweep
    
    // bg
    
    CGRect bg = CGRectMake(0, 0, [self bounds].size.width, [self bounds].size.height);
    CGContextSetRGBFillColor (context, 0, 0, 0, 1);
    CGContextFillRect(context, bg);
    
    /*
    // right circle
    
    CGContextSetFillColorWithColor(context, blue);
    CGContextAddArc(context, xCenter+radius, yCenter, radius, radians(secondtodegree(sweepsecond) + 90), radians(secondtodegree(sweepsecond) - 90), 0);
    CGContextFillPath(context);
    CGContextSetFillColorWithColor(context, yellow);
    CGContextAddArc(context, xCenter+radius, yCenter, radius, radians(secondtodegree(sweepsecond) + 90), radians(secondtodegree(sweepsecond) - 90), 1);
    CGContextFillPath(context);
    */
    
    // spirals
    // better to just make a spiral object? with properties?

    NSBezierPath* spiralLeft = [NSBezierPath bezierPath];
    NSBezierPath* spiralRight = [NSBezierPath bezierPath];
    spiralLeft = [self buildBezierSpiralWithPath: spiralLeft clockwise: true drawBezierPoints: false];
    spiralRight = [self buildBezierSpiralWithPath: spiralRight clockwise: false drawBezierPoints: false];

    // draw
    // use animation instead of transforming rotation of drawing context !! ** fix **

    NSAffineTransform* xform = [NSAffineTransform transform];   // identity transform
    
// Add the transformations
[xform translateXBy:400.0 yBy:400.0];
[xform concat];
 
// Draw content...
 
        [[NSColor whiteColor] setStroke];
        [spiralRight setLineWidth:1.0];
        [spiralRight stroke];

// Remove the transformations by applying the inverse transform.
[xform invert];

[xform translateXBy:100.0 yBy:100.0];
[xform concat];

        [[NSColor whiteColor] setStroke];
        [spiralRight setLineWidth:1.0];
        [spiralRight stroke];

[xform invert];
[xform concat];




// [xform rotateByDegrees:90.0]; // counterclockwise rotation


/*

    [theContext saveGraphicsState]; // push             
    [xform translateXBy:xCenter/3 yBy:0.0];
    // [xform translateXBy:xCenter/2 yBy:yCenter/2];
    // [xform concat];         // apply the changes 

    for (float i = 4; i > 0; i-=1.0) {

        [theContext saveGraphicsState]; // push
        [xform translateXBy:0.0 yBy: yCenter/i];
        [xform concat];         // apply the changes 
        [[NSColor whiteColor] setStroke];
        [spiralRight setLineWidth:1.0];
        [spiralRight stroke];
        [xform invert];         // undo last
        [xform invert];         // undo last
        [theContext restoreGraphicsState];  // pop
    }

    [theContext restoreGraphicsState];  // pop

*/

    // ** fix ** work out
    // best fit bezier from points
    // http://ymedialabs.github.io/blog/2015/05/12/draw-a-bezier-curve-through-a-set-of-2d-points-in-ios/
    
    // [self debugText:xCenter/15 yPosition:yCenter/15 canvasWidth:200 canvasHeight:100];        // debug
    
    CGContextFlush(context);
}

- (NSBezierPath*)buildBezierSpiralWithPath:(NSBezierPath*)thisPath clockwise:(Boolean)clockwise drawBezierPoints:(Boolean)drawBezierPoints 
{
    // int size = 16;
    // int numberofpoints = 256;
    int numberofpoints = 128;
    int direction = 1;
    if (!clockwise) direction = -1;

    [thisPath moveToPoint:NSMakePoint(0.0, 0.0)];

    for (float i = 0; i <= numberofpoints; i+=1.0) {

        float x = i*2 * cos(secondtodegree(i) * direction);
        float y = i*2 * sin(secondtodegree(i) * direction);
        [thisPath lineToPoint:NSMakePoint(x, y)];

        if (drawBezierPoints) {
            NSBezierPath* aCircle = [NSBezierPath bezierPathWithOvalInRect:CGRectMake(x, y, 3.0, 3.0)];
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
