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
@property (strong) NSMutableArray *contactQueue;
@property (nonatomic) id<SKPhysicsContactDelegate> contactDelegate;
@property (nonatomic) NSInteger ID;

- (id) initAtPoint:(CGPoint) point withDelegate:(id<SKPhysicsContactDelegate>) delegate withID:(NSInteger) idIn withSpeed:(CGFloat) speed;

- (CGFloat) pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint) endingPoint;
- (CGFloat) degreesToRadians:(CGFloat) degrees;
- (void) rotateToAngle:(CGFloat) angle;

- (BOOL) idDoesMatch:(NSString *) idIn;

@end

extern int ZOMBIE_ID;

#endif /* Zombie_h */
