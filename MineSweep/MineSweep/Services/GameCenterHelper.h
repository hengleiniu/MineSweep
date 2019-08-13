//
//  GameCenterHelper.h
//  MineSweep
//
//  Created by BLIZZMI on 2019/7/18.
//  Copyright © 2019 BLIZZMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface GameCenterHelper : NSObject
+ (instancetype)shareGameCenterHelper;
- (void)authPlayerInViewController:(UIViewController *)vc;
- (void)saveHighScore:(int64_t)score identifier:(NSString *)identifier;
- (void)gameCenterInViewController:(UIViewController *)vc;
- (void)uploadAchievmentWithComplete:(double)complete identifier:(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
