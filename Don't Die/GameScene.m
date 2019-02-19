//
//  GameScene.m
//  Don't Die
//
//  Created by Nick Abate on 2/14/19.
//  Copyright © 2019 Nick Abate. All rights reserved.
//

#import "GameScene.h"
#import <Math.h>

@implementation GameScene {
    NSTimeInterval _lastUpdateTime;
}

- (void)sceneDidLoad {
    // Setup your scene here
	_player = [SKSpriteNode spriteNodeWithImageNamed:@"BillyBaller_Forward"];
	[_player setPosition:CGPointMake(0, 0)];
	[_player setSize:CGSizeMake(50, 50)];
	[self addChild:_player];
	
	// Screen window for uitouches
	_window = [SKSpriteNode spriteNodeWithTexture:NULL size:CGSizeMake(1000, 1000)];
	[_window setPosition:CGPointMake(0, 0)];
	[self addChild:_window];
    
    // Initialize update time
    _lastUpdateTime = 0;
	
}
- (CGFloat) pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint) endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    float bearingDegrees = bearingRadians * (180.0 / M_PI); // convert to degrees
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingDegrees;
}

- (void)rotatePlayerWithPoint:(CGPoint)point {
	CGFloat angle = [self pointPairToBearingDegrees:CGPointMake(0, 0) secondPoint:point];
	SKAction *rotation = [SKAction rotateToAngle: angle*M_PI/180 - M_PI_2 duration:0];
	[_player runAction:rotation];
}

- (void)touchDownAtPoint:(CGPoint)pos {

}

- (void)touchMovedToPoint:(CGPoint)pos {

}

- (void)touchUpAtPoint:(CGPoint)pos {

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touchPoint = [touches anyObject];
	CGPoint point = [touchPoint locationInNode:_window];
	[self rotatePlayerWithPoint:point];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touchPoint = [touches anyObject];
	CGPoint point = [touchPoint locationInNode:_window];
	[self rotatePlayerWithPoint:point];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {

}


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
    
    // Initialize _lastUpdateTime if it has not already been
    if (_lastUpdateTime == 0) {
        _lastUpdateTime = currentTime;
    }
    
    // Calculate time since last update
    CGFloat dt = currentTime - _lastUpdateTime;
    
    // Update entities
    for (GKEntity *entity in self.entities) {
        [entity updateWithDeltaTime:dt];
    }
    
    _lastUpdateTime = currentTime;
}

@end
