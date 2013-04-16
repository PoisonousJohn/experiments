//
// Created by JohnPoison <truefiresnake@gmail.com> on 3/25/13.




#import <Foundation/Foundation.h>
#import "GLWTypes.h"

@class GLWShaderProgram;
@class GLWMatrix;


@interface GLWObject : NSObject {
    @protected
        BOOL isDirty;
        SEL updateSelector;
        GLWMatrix *transformation;
        BOOL transformationDirty;
        //factual coordinate of object
        float zCoordinate;
}

@property (nonatomic, strong) GLWShaderProgram *shaderProgram;
// z-index
@property (nonatomic, assign) NSInteger z;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) CGSize size;
// if set this will be used to determine relative position
@property (nonatomic, assign) GLWObject *parent;
@property (nonatomic, assign) float rotation;
@property (nonatomic, assign) float scale;

// use this method to update object before draw
-(void)touch: (CFTimeInterval)dt;
-(void)draw:(CFTimeInterval)dt;
-(void)setUpdateSelector: (SEL) sel;
-(BOOL)isDirty;
- (Vec4) transformedCoordinate: (Vec4) v;
- (CGPoint) transformedPoint: (CGPoint) p;

@end