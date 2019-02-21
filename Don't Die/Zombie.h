//
//  Zombie.h
//  Don't Die
//
//  Created by Nick Abate on 2/20/19.
//  Copyright © 2019 Nick Abate. All rights reserved.
//

#ifndef Zombie_h
#define Zombie_h

#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>

@interface Zombie : NSObject

@property (nonatomic) SKSpriteNode *zombie;

- (id) initAtPoint:(CGPoint) point;

- (CGFloat) pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint) endingPoint;
- (CGFloat) degreesToRadians:(CGFloat) degrees;
- (void) rotateToAngle:(CGFloat) angle;

@end

#endif /* Zombie_h */
