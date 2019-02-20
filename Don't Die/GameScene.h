//
//  GameScene.h
//  Don't Die
//
//  Created by Nick Abate on 2/14/19.
//  Copyright © 2019 Nick Abate. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>

@interface GameScene : SKScene

@property (nonatomic) NSMutableArray<GKEntity *> *entities;
@property (nonatomic) NSMutableDictionary<NSString*, GKGraph *> *graphs;
@property (nonatomic) SKSpriteNode *player;
@property (nonatomic) SKSpriteNode *window;
@property (nonatomic) NSMutableArray *bullets;
@property (nonatomic) NSTimer *cooldownTimer;
@property (nonatomic) BOOL canShootNewBullet;
@property (nonatomic) BOOL touchDown;
@property (nonatomic) CGPoint lastPoint;

- (void) rotatePlayerWithPoint:(CGPoint) point;
- (void) shootNewBulletAt:(CGPoint) location;
- (BOOL) canShootNewBullet;
- (void) endBulletCooldown;

- (CGFloat) degreesToRadians:(CGFloat)degrees;
- (CGFloat) pointPairToBearingDegrees:(CGPoint) startingPoint secondPoint:(CGPoint) endingPoint;

@end
