//
// Created by JohnPoison <truefiresnake@gmail.com> on 3/26/13.




#import <CoreGraphics/CoreGraphics.h>
#import "GLWSprite.h"
#import "GLWMath.h"
#import "GLWSpriteGroup.h"
#import "GLWTexture.h"
#import "GLWTextureRect.h"
#import "GLWTextureCache.h"
#import "GLWMacro.h"
#import "GLWShaderManager.h"
#import "GLWAnimation.h"
#import "GLWShaderProgram.h"

static const int VertexSize = sizeof(GLWVertexData);

@implementation GLWSprite {
}

- (void)dealloc {
    self.textureRect = nil;
}

- (void)setParent:(GLWObject *)parent {
    isDirty = YES;
    [super setParent: parent];
}

- (void) updateTexCoords {
    float left      = _textureRect.rect.origin.x + self.textureOffset.x;
    float right     = _textureRect.rect.origin.x + _textureRect.rect.size.width + self.textureOffset.x;
    float bottom    = _textureRect.rect.origin.y + self.textureOffset.y;
    float top       = _textureRect.rect.origin.y + _textureRect.rect.size.height + self.textureOffset.y;

    Vec2 tl = [_textureRect.texture normalizedCoordsForPoint:CGPointMake(left, top)];
    Vec2 tr = [_textureRect.texture normalizedCoordsForPoint:CGPointMake(right, top)];
    Vec2 bl = [_textureRect.texture normalizedCoordsForPoint:CGPointMake(left, bottom)];
    Vec2 br = [_textureRect.texture normalizedCoordsForPoint:CGPointMake(right, bottom)];

    // inverted y-axis due to iOS coordinates system
    _vertices.topLeft.texCoords  = bl;
    _vertices.topRight.texCoords = br;
    _vertices.bottomLeft.texCoords = tl;
    _vertices.bottomRight.texCoords = tr;
}

- (void)setTextureRect:(GLWTextureRect *)textureRect {
    if (self.group && textureRect.texture != self.texture)
        @throw [NSException exceptionWithName: @"Can't change texture rect" reason:@"texture rect and group has different textures" userInfo:nil];

    isDirty = YES;
    [self.group childIsDirty];

    _textureRect = textureRect;
    _texture = textureRect.texture;

    // size should be in points according to ortho projection
    self.size = CGSizeMake(textureRect.rect.size.width / SCALE(), textureRect.rect.size.height / SCALE());

    [self updateTexCoords];

}

- (id)init {
    self = [super init];

    if (self) {
        self.textureOffset  = CGPointZero;
        self.position       = CGPointMake(0.f, 0.f);
        self.size           = CGSizeMake(0.f, 0.f);
        isDirty             = YES;
        z                   = 0;
        self.group          = nil;

        _vertices.topRight.color    =
        _vertices.topLeft.color     =
        _vertices.bottomRight.color =
        _vertices.bottomLeft.color  =
                Vec4Make(255.f, 255.f, 255.f, 255.f);

    }

    return self;
}

- (void)setSize:(CGSize)size {
    isDirty = YES;
    [self.group childIsDirty];
    [super setSize:size];
}

- (void)setPosition:(CGPoint)position {
    isDirty = YES;
    [self.group childIsDirty];
    [super setPosition:position];
}

- (void) updateVertices {
    if (self.isDirty) {

        float left   = self.position.x;
        float right  = self.position.x + self.size.width;
        float bottom = self.position.y;
        float top    = self.position.y + self.size.height;

        _vertices.bottomLeft.vertex     = Vec3Make(left, bottom, z);
        _vertices.bottomRight.vertex    = Vec3Make(right, bottom, z);
        _vertices.topLeft.vertex        = Vec3Make(left, top, z);
        _vertices.topRight.vertex       = Vec3Make(right, top, z);

        [self updateTexCoords];

        isDirty = NO;
    }
}

- (GLWVertex4Data)vertices {
    [self updateVertices];
    return _vertices;
}

- (void)touch:(CFTimeInterval)dt {
    [self.animation update: dt];
    [super touch:dt];
}

- (void)draw:(CFTimeInterval)dt {
    // if we are using VBO this method shouldn't be involved
    if (self.group)
        return;

    [self.shaderProgram use];
//    [[GLWShaderManager sharedManager] updateDefaultUniforms];

    [self.animation update: dt];

    [self updateVertices];
    [GLWTexture bindTexture: self.texture];
    [GLWSprite enableAttribs];

    long v = (long)&_vertices;
    NSInteger diff = offsetof( GLWVertexData, vertex);
    glVertexAttribPointer(kAttributeIndexPosition, 3, GL_FLOAT, GL_FALSE, VertexSize, (GLvoid*)(v+diff));
    diff = offsetof( GLWVertexData, color);
    glVertexAttribPointer(kAttributeIndexColor, 3, GL_FLOAT, GL_FALSE, VertexSize, (GLvoid*) (v+diff));
    diff = offsetof( GLWVertexData, texCoords);
    glVertexAttribPointer(kAttributeIndexTexCoords, 2, GL_FLOAT, GL_FALSE, VertexSize, (GLvoid*) (v+diff));


    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    GL_ERROR();

}

+ (GLWSprite *) spriteWithRectName: (NSString *) name {
    GLWSprite *sprite = [[GLWSprite alloc] init];
    sprite.textureRect = [[GLWTextureCache sharedTextureCache] rectWithName: name];

    return sprite;
}

+ (GLWSprite *) spriteWithFile: (NSString *)filename {
    GLWSprite *sprite = [[GLWSprite alloc] init];
    sprite.textureRect = [GLWTextureRect textureRectWithTexture:[[GLWTextureCache sharedTextureCache] textureWithFile:filename]];

    return sprite;
}

+ (GLWSprite *) spriteWithFile: (NSString *)filename rect: (CGRect) rect {
    GLWSprite *sprite = [[GLWSprite alloc] init];
    sprite.textureRect = [GLWTextureRect textureRectWithTexture:[[GLWTextureCache sharedTextureCache] textureWithFile:filename] rect: CGRectInPixels(rect) name: filename];

    return sprite;
}

+ (void) enableAttribs {
    glEnableVertexAttribArray(kAttributeIndexPosition);
    glEnableVertexAttribArray(kAttributeIndexColor);
    glEnableVertexAttribArray(kAttributeIndexTexCoords);
}

- (void)setAnimation:(GLWAnimation *)animation {
    [_animation stop];
    _animation = animation;
}

- (void)runAnimation:(GLWAnimation *)animation {
    self.animation = animation;
    self.animation.target = self;
    [self.animation start];
}

- (void)setTextureOffset:(CGPoint)textureOffset {
    isDirty = YES;
    _textureOffset = textureOffset;
}

@end