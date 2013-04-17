//
// Created by JohnPoison <truefiresnake@gmail.com> on 4/14/13.




#import <Foundation/Foundation.h>
#import "Entity.h"
#import "SpaceshipEngineDelegate.h"

@class GLWLayer;
@class GLWSprite;
@class GLWObject;


@interface Spaceship : Entity <SpaceshipEngineDelegate> {
    GLWLayer* layer;
    GLWSprite* spaceship;
    GLWSprite* fire;
}


-(CGPoint)velocity;
-(CGPoint)position;
-(void)setPosition: (CGPoint) p;
-(void)addToParent: (GLWLayer *)parent;

@end