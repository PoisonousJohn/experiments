//
// Created by JohnPoison <truefiresnake@gmail.com> on 4/14/13.




#import <CoreGraphics/CoreGraphics.h>
#import "PhysicalBody.h"
#import "GLWMath.h"
#import "OpenGLConfig.h"
#import "Shape.h"


@implementation PhysicalBody {

}
- (id)init {
    self = [super init];
    if (self) {
        _velocity = CGPointZero;
        _maxVelocity = 0.f;
        shapeVerticesCount = 0;
    }

    return self;
}

- (PhysicalBody *)initWithRadius:(float)radius verticesCount:(uint)count {
    self = [self init];

    if (self) {
        _radius = radius;
        shapeVerticesCount = count;
    }

    return self;
}


- (void)applyForce:(CGPoint)forceVector {
    float massFactor = self.mass < 1.f ? 1 : 1 / self.mass;

    CGPoint acceleration = CGPointMake(forceVector.x * massFactor, forceVector.y * massFactor);
    _velocity = CGPointAdd(_velocity, acceleration);

    float vectorVelocity = VectorLength(_velocity);

    if (vectorVelocity > self.maxVelocity) {
        float scaleFactor = self.maxVelocity / vectorVelocity;
        _velocity.x *= scaleFactor;
        _velocity.y *= scaleFactor;
    }
}

- (void)applyImpulse:(CGPoint)impulseVector {
    _velocity = CGPointAdd(_velocity, impulseVector);
}

- (Shape *)shape {
    return shape;
}

- (uint)shapeVerticesCount {
    return shapeVerticesCount;
}


@end