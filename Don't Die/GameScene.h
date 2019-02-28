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

@property (nonatomic) SKSpriteNode *upgradeGunButton;
@property (nonatomic) SKSpriteNode *upgradeDefensesButton;
@property (nonatomic) SKSpriteNode *upgradeStealthButton;

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
@property (nonatomic) CGFloat zombieSpeed;

@property (nonatomic) NSInteger currentLevel;
@property (nonatomic) CGFloat lastLevelUpTime;
@property (nonatomic) CGFloat levelUpDuration;

@property (nonatomic) NSMutableArray *zombieArray;

@property (strong) NSMutableArray *contactQueue;

@property (nonatomic) NSInteger cash;
@property (nonatomic) SKLabelNode *cashLabel;

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

@property (nonatomic) NSInteger upgradeGunCost;
@property (nonatomic) SKLabelNode *upgradeGunLabel;
@property (nonatomic) NSInteger upgradeDefensesCost;
@property (nonatomic) SKLabelNode *upgradeDefensesLabel;
@property (nonatomic) NSInteger upgradeStealthCost;
@property (nonatomic) SKLabelNode *upgradeStealthLabel;

@property (nonatomic) SKLabelNode *titleLabel;

- (void) upgradeGun;
- (void) upgradeDefenses;
- (void) upgradeStealth;

- (void) addCash;

@end
