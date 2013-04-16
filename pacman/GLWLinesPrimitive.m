//
// Created by JohnPoison <truefiresnake@gmail.com> on 4/15/13.




#import "GLWLinesPrimitive.h"
#import "GLWMath.h"
#import "GLWShaderManager.h"
#import "GLWTextureCache.h"
#import "GLWTexture.h"
#import "GLWSprite.h"
#import "GLWTypes.h"
#import "GLWShaderProgram.h"

static const int VertexSize = sizeof(GLWVertexData);

@implementation GLWLinesPrimitive {

}

- (id)init {
    self = [super init];
    if (self) {
        self.shaderProgram = [[GLWShaderManager sharedManager] getProgram: kGLWPositionColorProgram];
    }

    return self;
}

- (void) updateVertices {


    for (int i = 0; i < _points.count; i++) {
        CGPoint v =[[_points objectAtIndex:i] CGPointValue];
        _vertices[i].vertex = Vec3Make(self.position.x + v.x, self.position.y + v.y, 0);
        _vertices[i].color = normalizedColor;
        _vertices[i].texCoords = Vec2Make(0,0);
    }
}


- (GLWLinesPrimitive *)initWithVertices:(NSArray *)vArr lineWidth:(float)lineWidth color:(Vec4)color {
    self = [self init];

    if (self) {

        _points = vArr;

        _vertices = malloc(sizeof(GLWVertexData) * vArr.count);
        _lineWidth = lineWidth;
        self.color = color;


        isDirty = YES;

    }

    return self;
}

- (void)draw:(CFTimeInterval)dt {
    [self.shaderProgram use];
//    [[GLWShaderManager sharedManager] updateDefaultUniforms];

    if (self.isDirty) {
        [self updateVertices];
        isDirty = NO;
    }

    glLineWidth(_lineWidth);

    [GLWSprite enableAttribs];
    long v = (long) _vertices;
    NSInteger diff = offsetof( GLWVertexData, vertex);
    glVertexAttribPointer(kAttributeIndexPosition, 3, GL_FLOAT, GL_FALSE, VertexSize, (GLvoid*)(v+diff));
    diff = offsetof( GLWVertexData, color);
    glVertexAttribPointer(kAttributeIndexColor, 3, GL_FLOAT, GL_FALSE, VertexSize, (GLvoid*) (v+diff));
    diff = offsetof( GLWVertexData, texCoords);
    glVertexAttribPointer(kAttributeIndexTexCoords, 2, GL_FLOAT, GL_FALSE, VertexSize, (GLvoid*) (v+diff));

    glDrawArrays(GL_LINES, 0, _points.count);
    GL_ERROR();
}

- (void)setColor:(Vec4)color {
    _color = color;
    normalizedColor = Vec4Make(color.x / 255.f, color.y / 255.f, color.z / 255.f, color.w / 255.f);
    isDirty = YES;
}


- (void)dealloc {
    if (_vertices)
        free(_vertices);
}

@end