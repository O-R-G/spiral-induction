//
//  emdrView.h
//  emdr
//
//  Created by david reinfurt on 4/4/17.
//  Copyright © 2017 O-R-G inc. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>

// utility converters

#define PI 3.14159265358979323846

static inline double radians(double degrees) {
    return degrees * PI / 180;
}

static inline CGFloat mapValueWithRange (CGFloat value, CGFloat inMin, CGFloat inMax, CGFloat outMin, CGFloat outMax) {
    // map one value to another within a range
    return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
}

static inline CGFloat hourtodegree (CGFloat thishour) {
    return mapValueWithRange(thishour, 0.0, 12.0, 360.0, 0.0);
}

static inline CGFloat minutetodegree (CGFloat thisminute) {
    return mapValueWithRange(thisminute, 0.0, 60.0, 360.0, 0.0);
}

static inline CGFloat secondtodegree (CGFloat thissecond) {
    return mapValueWithRange(thissecond, 0.0, 60.0, 360.0, 0.0);
}

static inline CGFloat millisecondtodegree (CGFloat thissecond) {
    return mapValueWithRange(thissecond, 0.0, 60.0, 0.0, 180.0);
}

@interface emdrView : ScreenSaverView
{
    // Instance (global) variables
    
    // double radius, second;
    CGFloat radius;
    CGFloat sweephour, sweepminute, sweepsecond;    // NSDate (sweep)
    int hour, minute, second;                    // time_t (click)
    int xCenter, yCenter;
}

- (void) checkTime_nsdate;

@end

