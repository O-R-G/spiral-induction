#import <Foundation/Foundation.h>

static int instance;
static direction, cycles;
static int direction, cycles;
static float sizer; 
NSMutableArray *points;

# define PI 3.14159265358979323846
static inline CGFloat radians (CGFloat degrees) {
    return degrees * PI / 180;
}
static inline CGFloat mapValueWithRange (CGFloat value, CGFloat inMin, CGFloat inMax, CGFloat outMin, CGFloat outMax) {
    // map one value to another within a range
    return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
}

@interface Spiral : NSObject {
}

+ (void) initialize;
- (id) initWithSize;
- (NSMutableArray*) makeWithPoints;          
- (NSMutableArray*) points;          
- (float) sizer;
- (int) direction;
- (void) debug;

@end
