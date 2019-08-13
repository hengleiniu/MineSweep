//
//  GameStartViewController.h
//  MineSweep
//
//  Created by BLIZZMI on 2019/7/15.
//  Copyright © 2019 BLIZZMI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,GameType) {
    simeple,
    medium,
    difficult,
    challenge
};

@interface GameStartViewController : UIViewController

- (instancetype)initWithGameType:(GameType)gameType;

@end

NS_ASSUME_NONNULL_END
