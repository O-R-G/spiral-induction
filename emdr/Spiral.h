#import <Foundation/Foundation.h>

static int instance;
static int size, direction, cycles;
NSMutableArray *points;

# define PI 3.14159265358979323846
static inline CGFloat radians (CGFloat degrees) {
    return degrees * PI / 180;
}
static inline CGFloat mapValueWithRange (CGFloat value, CGFloat inMin, CGFloat inMax, CGFloat outMin, CGFloat outMax) {
    // map one value to another within a range
    return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
}
// tmp remove ** fix **
static inline CGFloat secondtodegree (CGFloat thissecond) {
    return mapValueWithRange(thissecond, 0.0, 60.0, 360.0, 0.0);
}

@interface Spiral : NSObject {
}

+ (void) initialize;
- (id) init;
- (NSMutableArray*) makeWithPoints;          
- (NSMutableArray*) points;          
- (int) size;
- (int) direction;
- (void) debug;

@end
