#import <Foundation/Foundation.h>

static int instance;
static int direction;
static int cycles;
static float sizer; 
static float xoffset; 
NSMutableArray *points;

# define PI 3.14159265358979323846
static inline CGFloat radians (CGFloat degrees) {
    return degrees * PI / 180;
}
static inline CGFloat mapValueWithRange (CGFloat value, CGFloat inMin, CGFloat inMax, CGFloat outMin, CGFloat outMax) {
    // map one value to another within a range
    return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
}

@interface SpiralDouble : NSObject {
}

+ (void) initialize;
- (id) initWithSize;
- (NSMutableArray*) makeWithPoints;          
- (NSMutableArray*) points;          
- (float) sizer;
- (int) direction;
- (void) debug;

@end
