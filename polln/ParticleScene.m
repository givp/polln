//
//  ParticleScene.m
//  polln
//
//  Created by Giv Parvaneh on 6/25/15.
//  Copyright (c) 2015 Giv Parvaneh. All rights reserved.
//

#import "ParticleScene.h"

@implementation ParticleScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
        NSString *emitterPath = [[NSBundle mainBundle] pathForResource:@"BokehMyParticle" ofType:@"sks"];
        SKEmitterNode *bokeh = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
        bokeh.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height/2);
        bokeh.name = @"pollenEmitter";
        bokeh.targetNode = self.scene;
        [self addChild:bokeh];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
