//
//  GameScene.m
//  Don't Die
//
//  Created by Nick Abate on 2/14/19.
//  Copyright © 2019 Nick Abate. All rights reserved.
//

#import "GameScene.h"
#import "CategoryDefinitions.h"
#import <Math.h>
#import "Zombie.h"
#import <stdlib.h>

@implementation GameScene {
    NSTimeInterval _lastUpdateTime;
}

- (void)sceneDidLoad {

	_titleLabel = [SKLabelNode labelNodeWithText:@"Dont Die!"];
	[_titleLabel setPosition:CGPointMake(0, 600)];
	[_titleLabel setFontSize:75];
	[self addChild:_titleLabel];

	_zombieID = 0;
	_cooldownDuration = 0.5;
	_canShootNewBullet = YES;
	_touchDown = NO;
	// Setting up background
	SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"Background Dont Die"];
	
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	[background setSize:(CGSizeMake(1000, 1000))];
	[background setPosition:CGPointMake(0, 0)];
	[self addChild:background];
	
	_contactQueue = [NSMutableArray array];
	self.physicsWorld.contactDelegate = self;
	self.contactQueue = [NSMutableArray array];
	
    // Setup your scene here
	_player = [SKSpriteNode spriteNodeWithImageNamed:@"Player"];
	[_player setPosition:CGPointMake(0, 0)];
	[_player setSize:CGSizeMake(50, 50)];
	[_player.physicsBody.node setName:playerName];
	_player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:25];
	_player.physicsBody.dynamic = YES;
	_player.physicsBody.affectedByGravity = NO;
	_player.physicsBody.categoryBitMask = playerCategory;
	_player.physicsBody.collisionBitMask = 0x0;
	[self addChild:_player];
	
	// Screen window for uitouches
	_window = [SKSpriteNode spriteNodeWithTexture:NULL size:CGSizeMake(1000, 1000)];
	[_window setPosition:CGPointMake(0, 0)];
	[self addChild:_window];
    
    // Initialize update time
    _lastUpdateTime = 0;
	
    _currentZombieSpawnDebuff = 0;
    _zombieSpawnCooldown = 1.0;
    _zombieSpeed = 6;
	
	_maxHealth = 100;
    _currentHealth = _maxHealth;
	
	_zombieArray = [[NSMutableArray alloc] init];
	
	// Buttons
	_upgradeGunButton = [SKSpriteNode spriteNodeWithImageNamed:@"UpgradeGun"];
	[_upgradeGunButton setPosition:CGPointMake(-250, -590)];
	[_upgradeGunButton setSize:CGSizeMake(200, 100)];
	[self addChild:_upgradeGunButton];
	_upgradeDefensesButton = [SKSpriteNode spriteNodeWithImageNamed:@"UpgradeDefenses"];
	[_upgradeDefensesButton setPosition:CGPointMake(0, -590)];
	[_upgradeDefensesButton setSize:CGSizeMake(200, 100)];
	[self addChild:_upgradeDefensesButton];
	_upgradeStealthButton = [SKSpriteNode spriteNodeWithImageNamed:@"UpgradeStealth-1"];
	[_upgradeStealthButton setPosition:CGPointMake(250, -590)];
	[_upgradeStealthButton setSize:CGSizeMake(200, 100)];
	[self addChild:_upgradeStealthButton];
	
	// Upgrade Costs
	_upgradeGunCost = 3;
	_upgradeDefensesCost = 3;
	_upgradeStealthCost = 3;
	
	// UpgradeCost Labels
	_upgradeGunLabel = [SKLabelNode labelNodeWithText:@"cost: 3"];
	[_upgradeGunLabel setPosition:CGPointMake(0,0)];
	[_upgradeGunLabel setColor:[UIColor blackColor]];
	[_upgradeGunLabel setFontSize:50];
	[_upgradeGunButton addChild:_upgradeGunLabel];
	_upgradeDefensesLabel = [SKLabelNode labelNodeWithText:@"cost: 3"];
	[_upgradeDefensesLabel setPosition:CGPointMake(0, 0)];
	[_upgradeDefensesLabel setFontSize:50];
	[_upgradeDefensesLabel setColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
	[_upgradeDefensesButton addChild:_upgradeDefensesLabel];
	_upgradeStealthLabel = [SKLabelNode labelNodeWithText:@"cost: 3"];
	[_upgradeStealthLabel setPosition:CGPointMake(0,0)];
	[_upgradeStealthLabel setFontSize:50];
	[_upgradeStealthLabel setColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
	[_upgradeStealthButton addChild:_upgradeStealthLabel];
	
	// Level
	
	_currentLevel = 1;
	_lastLevelUpTime = 0;
	_levelUpDuration = 2;
	
	// Cash
	
	_cash = 0;
	_cashLabel = [SKLabelNode labelNodeWithText:@"cash: 0"];
	[_cashLabel setPosition:CGPointMake(250, 570)];
	[_cashLabel setFontSize:50];
	[_cashLabel setColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:1]];
	[self addChild:_cashLabel];
	
}

- (void) addCash {
	_cash++;
	NSString *amount = [NSString stringWithFormat:@"%d", (int)_cash];
	NSArray *cashTextArr = [[NSArray alloc] initWithObjects:@"cash: ", amount, nil];
	NSString *cashText = [cashTextArr componentsJoinedByString:@""];
	[_cashLabel setText:cashText];
}

- (void) shootNewBulletAt:(CGPoint)location {

	if ([self canShootNewBullet]) {
	
		CGPoint startPoint = CGPointMake(0,0);

		CGFloat angle = [self pointPairToBearingDegrees:CGPointMake(0, 0) secondPoint:location];
		angle = [self degreesToRadians:angle];
		
		CGFloat newAngle = angle + M_PI_4;
		startPoint.x = 25 * cosf(newAngle);
		startPoint.y = 25 * sinf(newAngle);
	
		CGPoint vector = CGPointMake(1000, 0);
		vector.x = 1000 * cosf(angle);
		vector.y = 1000 * sinf(angle);
		SKAction *motion = [SKAction moveTo:vector duration:3];
	
		SKSpriteNode *bullet = [SKSpriteNode spriteNodeWithImageNamed:@"Bullet"];
		[bullet setSize:CGSizeMake(10, 10)];
		[bullet setPosition:CGPointMake(startPoint.x, startPoint.y)];
		bullet.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:5];
		bullet.physicsBody.contactTestBitMask = zombieCategory;
		bullet.physicsBody.collisionBitMask = 0x0;
		bullet.physicsBody.categoryBitMask = bulletCategory;
		bullet.physicsBody.node.name = bulletName;
		bullet.physicsBody.affectedByGravity = NO;
		bullet.physicsBody.dynamic = YES;
		[self addChild:bullet];
	
		[bullet runAction:motion];
	
	}
	
}

- (BOOL) canShootNewBullet {
	if (_canShootNewBullet) {
		_canShootNewBullet = NO;
		_cooldownTimer = [NSTimer scheduledTimerWithTimeInterval:_cooldownDuration target:self selector:@selector(endBulletCooldown) userInfo:nil repeats:NO];
		return YES;
	}
	return NO;
}

- (void) endBulletCooldown {
	_canShootNewBullet = YES;
}

- (void) spawnNewZombie
{
	int randomValue = arc4random_uniform(800);
	int posX = arc4random_uniform(2);
	int posY = arc4random_uniform(2);
	int x = 800;
	if (posX == 1) {
		x *= -1;
	}
	int y = randomValue;
	if (posY == 1) {
		y *= -1;
	}
	Zombie *zombie = [[Zombie alloc] initAtPoint:CGPointMake(x, y) withDelegate:self withID:_zombieID withSpeed:_zombieSpeed];
	_zombieID++;
	[_zombieArray addObject:zombie];
	[self addChild:zombie.zombie];
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
	UITouch *touchPoint = [touches anyObject];
	CGPoint point = [touchPoint locationInNode:_window];
	if ([_upgradeGunButton containsPoint:point]) {
		[self upgradeGun];
	} else if ([_upgradeDefensesButton containsPoint:point]) {
		[self upgradeDefenses];
	} else if ([_upgradeStealthButton containsPoint:point]) {
		[self upgradeStealth];
	}
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {

}

// Collision detection

- (void)didBeginContact:(SKPhysicsContact *)contact {
	[self.contactQueue addObject:contact];
}

- (void)handleContact:(SKPhysicsContact *)contact {
	if (!contact.bodyA.node.parent || !contact.bodyB.node.parent) {
		return;
	}
	NSString *nameA = contact.bodyA.node.name;
	NSString *nameB = contact.bodyB.node.name;
	if ([contact.bodyB.node.name isEqualToString:bulletName] || [contact.bodyA.node.name isEqualToString:bulletName]) {
		[self addCash];
		NSString *zNameA;
		NSString *zNameB;
		if (nameA != NULL) {
			zNameA = [nameA substringToIndex:[zombieName length]];
		} if (nameB != NULL) {
			zNameB = [nameB substringToIndex:[zombieName length]];
		}
		if ([zNameB isEqualToString:zombieName] || [zNameA isEqualToString:zombieName]) {
			NSString *idA = [nameA substringFromIndex:[zombieName length]];
			NSString *idB = [nameB substringFromIndex:[zombieName length]];
			if ([zNameB isEqualToString:zombieName]) {
				Zombie *zombieToRemove = NULL;
				for (id zombie in _zombieArray) {
					if ([zombie isKindOfClass:[Zombie class]]) {
						if ([zombie idDoesMatch:idB]) {
							zombieToRemove = zombie;
						} else if ([zombie idDoesMatch:idA]) {
							zombieToRemove = zombie;
						}
					}
				}
				[_zombieArray removeObject:zombieToRemove];
			} else if ([zNameA isEqualToString:zombieName]) {
				Zombie *zombieToRemove = NULL;
				for (id zombie in _zombieArray) {
					if ([zombie isKindOfClass:[Zombie class]]) {
						if ([zombie idDoesMatch:idB]) {
							zombieToRemove = zombie;
						} else if ([zombie idDoesMatch:idA]) {
							zombieToRemove = zombie;
						}
					}
				}
				[_zombieArray removeObject:zombieToRemove];
			}
			[contact.bodyB.node removeFromParent];
			[contact.bodyA.node removeFromParent];
			[self takeDamage:10];
		}
	} else {
		NSString *zNameA;
		NSString *zNameB;
		if (nameA != NULL) {
			zNameA = [nameA substringToIndex:[zombieName length]];
		} if (nameB != NULL) {
			zNameB = [nameB substringToIndex:[zombieName length]];
		}
		if ([zNameA isEqualToString:zombieName]) {
			[contact.bodyA.node removeFromParent];
		} else {
			[contact.bodyB.node removeFromParent];
		}
		[self takeDamage:10];
		NSLog(@"damage to player done");
	}
}

- (void)processContactsForUpdate:(NSTimeInterval)currentTime {
    for (SKPhysicsContact* contact in [self.contactQueue copy]) {
		[self handleContact:contact];
        [self.contactQueue removeObject:contact];
    }
}

// End collision detection

- (void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
    [self processContactsForUpdate:currentTime];
	
	[_upgradeGunLabel setColor:[UIColor blackColor]];
	[_upgradeDefensesLabel setColor:[UIColor blackColor]];
	[_upgradeStealthLabel setColor:[UIColor blackColor]];
    
    // Initialize _lastUpdateTime if it has not already been
    if (_lastUpdateTime == 0) {
        _lastUpdateTime = currentTime;
    }
    
    // Calculate time since last update
    CGFloat dt = currentTime - _lastUpdateTime;
    _lastUpdateTime = currentTime;
    _currentZombieSpawnDebuff += dt;
    
    // Update entities
    for (GKEntity *entity in self.entities) {
        [entity updateWithDeltaTime:dt];
    }
	
    if (_touchDown) {
    	[self shootNewBulletAt:_lastPoint];
	}
	
	if (_currentZombieSpawnDebuff > _zombieSpawnCooldown) {
		[self spawnNewZombie];
		_currentZombieSpawnDebuff -= _zombieSpawnCooldown;
	}
	
	// Leveling up
	if (_lastLevelUpTime == 0) {
		_lastLevelUpTime = currentTime;
	}
	
	if (currentTime - _lastLevelUpTime >= 8) {
		_lastLevelUpTime = currentTime;
		_zombieSpawnCooldown -= 0.08 * _zombieSpawnCooldown;
		_zombieSpeed -= 0.1 * _zombieSpeed;
		_currentLevel++;
	}
	
}

- (void) takeDamage:(int)damage {
	_currentHealth -= damage;
	if (_currentHealth <= 0) {
		_currentHealth = 0;
		NSLog(@"Player is dead");
	}
}

- (void) upgradeGun {
	if (_upgradeGunCost <= _cash) {
		_cash -= _upgradeGunCost;
		_upgradeGunCost += 2;
		_cooldownDuration -= 0.2 * _cooldownDuration;
	}
	NSString *amount = [NSString stringWithFormat:@"%d", (int)_upgradeGunCost];
	NSArray *cashTextArr = [[NSArray alloc] initWithObjects:@"cost: ", amount, nil];
	NSString *cashText = [cashTextArr componentsJoinedByString:@""];
	[_upgradeGunLabel setText:cashText];
}

- (void) upgradeDefenses {
	if (_upgradeDefensesCost <= _cash) {
		_cash -= _upgradeDefensesCost;
		_upgradeDefensesCost += 2;
		_zombieSpeed += 0.15 * _zombieSpeed;
	}
	NSString *amount = [NSString stringWithFormat:@"%d", (int)_upgradeDefensesCost];
	NSArray *cashTextArr = [[NSArray alloc] initWithObjects:@"cost: ", amount, nil];
	NSString *cashText = [cashTextArr componentsJoinedByString:@""];
	[_upgradeDefensesLabel setText:cashText];
	
	int randomx = arc4random_uniform(800) - 400;
	int randomy = arc4random_uniform(800) - 400;
	SKSpriteNode * d1 = [SKSpriteNode spriteNodeWithImageNamed:@"defense"];
	[d1 setPosition:CGPointMake(randomx, randomy)];
	[d1 setSize:CGSizeMake(20, 20)];
	[self addChild:d1];
	int randomx2 = arc4random_uniform(800) - 400;
	int randomy2 = arc4random_uniform(800) - 400;
	SKSpriteNode * d2 = [SKSpriteNode spriteNodeWithImageNamed:@"defense"];
	[d2 setPosition:CGPointMake(randomx2, randomy2)];
	[d2 setSize:CGSizeMake(20, 20)];
	[self addChild:d2];
}

- (void) upgradeStealth {
	if (_upgradeStealthButton <= _cash) {
		_cash -= _upgradeStealthCost;
		_upgradeStealthCost += 2;
		_zombieSpawnCooldown += .1 ;
	}
	NSString *amount = [NSString stringWithFormat:@"%d", (int)_upgradeStealthCost];
	NSArray *cashTextArr = [[NSArray alloc] initWithObjects:@"cost: ", amount, nil];
	NSString *cashText = [cashTextArr componentsJoinedByString:@""];
	[_upgradeStealthLabel setText:cashText];
	
}

@end








