//
//  glwDefaultFragment.h
//  pacman
//
//  Created by JohnPoison on 3/13/13.
//  Copyright (c) 2013 JohnPoison. All rights reserved.
//

"											\n\
precision highp float;						\n\
                                            \n\
varying vec4 v_fragmentColor;				\n\
                                            \n\
void main()									\n\
{											\n\
    //gl_FragColor = v_fragmentColor;			\n\
    gl_FragColor = vec4(1,0,0,1);			\n\
}											\n\
";
