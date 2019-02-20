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
	_canShootNewBullet = YES;
	_touchDown = NO;
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

- (void) shootNewBulletAt:(CGPoint)location {

	if ([self canShootNewBullet]) {

		CGFloat angle = [self pointPairToBearingDegrees:CGPointMake(0, 0) secondPoint:location];
		angle = [self degreesToRadians:angle];
	
		CGPoint vector = CGPointMake(1000, 0);
		vector.x = 1000 * cosf(angle);
		vector.y = 1000 * sinf(angle);
		SKAction *motion = [SKAction moveTo:vector duration:3];
	
		SKSpriteNode *bullet = [SKSpriteNode spriteNodeWithImageNamed:@"Bullet"];
		[bullet setSize:CGSizeMake(10, 10)];
		[bullet setPosition:CGPointMake(0, 0)];
		[self addChild:bullet];
	
		[bullet runAction:motion];
	
	}
	
}

- (BOOL) canShootNewBullet {
	if (_canShootNewBullet) {
		_canShootNewBullet = NO;
		_cooldownTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(endBulletCooldown) userInfo:nil repeats:NO];
		return YES;
	}
	return NO;
}

- (void) endBulletCooldown {
	_canShootNewBullet = YES;
}

- (CGFloat) degreesToRadians:(CGFloat)degrees {
	return degrees * M_PI / 180.0;
}

- (CGFloat) pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint) endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y);
    float bearingRadians = atan2f(originPoint.y, originPoint.x);
    float bearingDegrees = bearingRadians * (180.0 / M_PI);
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees));
    return bearingDegrees;
}

- (void)rotatePlayerWithPoint:(CGPoint)point {
	CGFloat angle = [self pointPairToBearingDegrees:CGPointMake(0, 0) secondPoint:point];
	angle = [self degreesToRadians:angle];
	SKAction *rotation = [SKAction rotateToAngle: angle - M_PI_2 duration:0];
	[_player runAction:rotation];
	[self shootNewBulletAt:point];
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
	_touchDown = YES;
	_lastPoint = point;
	[self rotatePlayerWithPoint:point];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touchPoint = [touches anyObject];
	CGPoint point = [touchPoint locationInNode:_window];
	_lastPoint = point;
	[self rotatePlayerWithPoint:point];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	_touchDown = NO;
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
	
    if (_touchDown) {
    	[self shootNewBulletAt:_lastPoint];
	}
    
    _lastUpdateTime = currentTime;
}

@end
