//
// Created by JohnPoison <truefiresnake@gmail.com> on 3/25/13.




#import <CoreGraphics/CoreGraphics.h>
#import "HelloScene.h"
#import "GLWRenderManager.h"
#import "GLWSprite.h"
#import "Spaceship.h"
#import "GLWMath.h"
#import "PhysicsSystem.h"
#import "GLWLinesPrimitive.h"
#import "SpaceshipControlSystem.h"
#import "GLWUtils.h"
#import "Asteroid.h"


@implementation HelloScene {
    GLWSprite *sprite;
}
- (void)dealloc {
    self.spaceship = nil;
    self.gestureRecognizer = nil;
}

- (id)init {
    self = [super init];
    if (self) {


        for (int i = 0; i < 5; i++) {
            Asteroid *asteroid = [[Asteroid alloc] init];
            asteroid.position = CGPointMake(100, 20+60 * i);
            [asteroid addToParent: self];
        }

//        float centeredX = [GLWRenderManager sharedManager].windowSize.width / 2;
//
//        self.spaceship = [[Spaceship alloc] init];
//        self.spaceship.position = CGPointMake(centeredX, 100);
//
//
//
//        self.space = [GLWSprite spriteWithFile: @"space.png" rect:CGRectMake(0.f, 0.f, [GLWRenderManager sharedManager].windowSize.width, [GLWRenderManager sharedManager].windowSize.height)];
////        self.space = [GLWSprite spriteWithFile: @"space.png"];
//        [self addChild: self.space];
//        [self.spaceship addToParent: self];




//        [[GLWTextureCache sharedTextureCache] cacheFile: @"spaceship"];
//
//        sprite = [GLWSprite spriteWithRectName: @"spaceship"];
//
//        GLWSpriteGroup *group = [GLWSpriteGroup spriteGroupWithTexture: sprite.texture];
//        [group addChild: sprite];
//        sprite.position = CGPointMake(100, 50);
//        [self addChild: group];
//        [self addChild: sprite];

        [self requireSystem: [PhysicsSystem class]];
        [self requireSystem: [SpaceshipControlSystem class]];

        [self setUpdateSelector:@selector(update:)];
    }

    return self;
}

- (void) update: (CFTimeInterval) dt {
//    sprite.position = CGPointMake(sprite.position.x + 30.f * dt, sprite.position.y);
    CGPoint v = self.spaceship.velocity;
    float scaleFactor = 0.02f;
    self.space.textureOffset = CGPointAdd(self.space.textureOffset, CGPointMake(-v.x * scaleFactor, -v.y * scaleFactor));
//    self.spaceship.layer.rotation += 90 * dt;
//    self.spaceship.layer.position = CGPointAdd(self.spaceship.layer.position, CGPointMake(0, 10.f * dt));
//    DebugLog(@"velocity: %5.5f %5.5f", v.x, v.y);
}

- (void) handleTouch: (UIGestureRecognizer *) gestureRecognizer {

}

@end