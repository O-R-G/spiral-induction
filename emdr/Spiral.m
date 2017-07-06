// #import "Spiral.h"

@implementation Spiral

+ (void) initialize {

    instance = 0;                       
    sizer = 1.0;                         
    direction = 1;
    cycles = 3.0;                   // rotations
    points = [[NSMutableArray alloc] initWithCapacity:0];
}

- (id) initWithSize: (float)thissizer {

    self = [super init];
    if (self != nil) {
        instance++;
        sizer = thissizer;
    }    

    return self;
}

- (id) makeWithPoints: (int)number clockwise:(Boolean)clockwise {

    // populate
    // cycles = turns around the center
        
    for (float i = 0; i < number; i+=1.0) {

        CGPoint p;
        CGFloat radian = mapValueWithRange(i, 0.0, number, 0.0, (2 * PI) * cycles);
        if (clockwise) radian*=-1; 

        float x = i * sizer * cos(radian);
        float y = i * sizer * sin(radian);
        p.x = x;
        p.y = y;

        [points addObject: [NSValue valueWithPoint:p]];
    }

    return self;
}

- (NSMutableArray*) points {

    return points;
}

- (float) sizer {

    return sizer;
}

- (int) direction {

    // default clockwise (in init)

    return direction;
}

- (int) cycles {

    return cycles;
}

- (void) debug {

    NSLog(@"instance : %d", instance);
    NSLog(@"sizer : %d", sizer);
    NSLog(@"direction : %d", direction);
    NSLog(@"cycles : %d", cycles);
    NSLog(@"points : %@", points);
    NSLog(@"points count : %d", [points count]);
}

@end
