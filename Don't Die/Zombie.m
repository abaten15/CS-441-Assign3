//
//  Zombie.m
//  Don't Die
//
//  Created by Nick Abate on 2/20/19.
//  Copyright © 2019 Nick Abate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Zombie.h"

@implementation Zombie {

}

// Constuctor
- (id) initAtPoint:(CGPoint) point
{
	self = [super init];
	if (self) {
		CGFloat angleToZombie = [self pointPairToBearingDegrees:point secondPoint:CGPointMake(0, 0)];
		CGFloat angleToOrigin;
		if (angleToZombie > M_PI) {
			angleToOrigin = angleToZombie - M_PI;
		} else {
			angleToOrigin = angleToZombie + M_PI;
		}
		SKAction *motion = [SKAction moveTo:CGPointMake(0, 0) duration:5];
		_zombie = [SKSpriteNode spriteNodeWithImageNamed:@"BillyBaller_Forward"];
		[_zombie setPosition:point];
		[_zombie setSize:CGSizeMake(50, 50)];
		[self rotateToAngle:angleToOrigin];
		[_zombie runAction:motion];
	}
	return self;
}

// Get angle of line between starting point and ending point
- (CGFloat) pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint) endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y);
    float bearingRadians = atan2f(originPoint.y, originPoint.x);
    float bearingDegrees = bearingRadians * (180.0 / M_PI);
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees));
    return bearingDegrees;
}

- (CGFloat) degreesToRadians:(CGFloat)degrees
{
	return degrees * M_PI / 180;
}

- (void) rotateToAngle:(CGFloat) angle
{
	SKAction *rotation = [SKAction rotateToAngle: angle duration:0];
	[_zombie runAction:rotation];
}

@end

