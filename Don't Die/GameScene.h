//
//  GameScene.h
//  Don't Die
//
//  Created by Nick Abate on 2/14/19.
//  Copyright © 2019 Nick Abate. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <UIKit/UIKit.h>
#import <GameplayKit/GameplayKit.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic) NSMutableArray<GKEntity *> *entities;
@property (nonatomic) NSMutableDictionary<NSString*, GKGraph *> *graphs;
@property (nonatomic) SKSpriteNode *player;
@property (nonatomic) SKSpriteNode *window;
@property (nonatomic) NSMutableArray *bullets;
@property (nonatomic) NSTimer *cooldownTimer;
@property (nonatomic) BOOL canShootNewBullet;
@property (nonatomic) BOOL touchDown;
@property (nonatomic) CGPoint lastPoint;

@property (nonatomic) NSInteger zombieID;
@property (nonatomic) CGFloat cooldownDuration;
@property (nonatomic) CGFloat currentZombieSpawnDebuff;
@property (nonatomic) CGFloat zombieSpawnCooldown;

@property (nonatomic) NSMutableArray *zombieArray;

@property (strong) NSMutableArray *contactQueue;

- (void) rotatePlayerWithPoint:(CGPoint) point;
- (void) shootNewBulletAt:(CGPoint) location;
- (BOOL) canShootNewBullet;
- (void) endBulletCooldown;

@property (nonatomic) int maxHealth;
@property (nonatomic) int currentHealth;

- (void) takeDamage:(int) damage;

- (void) spawnNewZombie;

- (CGFloat) degreesToRadians:(CGFloat)degrees;
- (CGFloat) pointPairToBearingDegrees:(CGPoint) startingPoint secondPoint:(CGPoint) endingPoint;

- (void) didBeginContact:(SKPhysicsContact *)contact;
- (void) handleContact:(SKPhysicsContact *)contact;

@end
