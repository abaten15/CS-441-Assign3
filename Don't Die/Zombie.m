//
//  Zombie.m
//  Don't Die
//
//  Created by Nick Abate on 2/20/19.
//  Copyright © 2019 Nick Abate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Zombie.h"
#import "CategoryDefinitions.h"

@implementation Zombie {

}

// Constuctor
- (id) initAtPoint:(CGPoint) point withDelegate:(id<SKPhysicsContactDelegate>) delegate withID:(NSInteger)idIn
{
	self = [super init];
	if (self) {
		self.contactDelegate = delegate;
		CGFloat angleToZombie = [self pointPairToBearingDegrees:point secondPoint:CGPointMake(0, 0)];
		angleToZombie = [self degreesToRadians:angleToZombie];
		angleToZombie -= M_PI_2;
		SKAction *motion = [SKAction moveTo:CGPointMake(0, 0) duration:5];
		_zombie = [SKSpriteNode spriteNodeWithImageNamed:@"Zombie"];
		[_zombie setPosition:point];
		[_zombie setSize:CGSizeMake(50, 50)];
		_zombie.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:25];
		_zombie.physicsBody.dynamic = YES;
		_zombie.physicsBody.categoryBitMask = zombieCategory;
		_zombie.physicsBody.contactTestBitMask = playerCategory;
		_zombie.physicsBody.affectedByGravity = NO;
		_zombie.physicsBody.collisionBitMask = 0x0;
		NSString *ID = [NSString stringWithFormat:@"%d", idIn];
		_ID = idIn;
		NSArray *nameArray = [[NSArray alloc] initWithObjects:zombieName, ID, nil];
		NSString *nameString = [nameArray componentsJoinedByString:@""];
		_zombie.physicsBody.node.name = nameString;
		[self rotateToAngle:angleToZombie];
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

- (BOOL) idDoesMatch:(NSString *)idIn
{

	NSString *idString = [NSString stringWithFormat:@"%d", (int)_ID];
	return [idString isEqualToString:idIn];

}

@end

