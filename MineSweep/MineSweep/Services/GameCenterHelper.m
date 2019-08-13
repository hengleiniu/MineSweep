//
//  GameCenterHelper.m
//  MineSweep
//
//  Created by BLIZZMI on 2019/7/18.
//  Copyright © 2019 BLIZZMI. All rights reserved.
//

#import "GameCenterHelper.h"
#import <GameKit/GameKit.h>

@interface GameCenterHelper ()<GKGameCenterControllerDelegate>

@end
@implementation GameCenterHelper
static id instance = nil;
+ (instancetype)shareGameCenterHelper{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (void)authPlayerInViewController:(UIViewController *)vc{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController * __nullable viewController, NSError * __nullable error){
        if ([[GKLocalPlayer localPlayer] isAuthenticated]) {
            NSLog(@"%@",@"已经授权！");
        }else if(viewController){
            [vc presentViewController:viewController animated:YES completion:nil];
        }else{
            if (!error) {
                NSLog(@"%@",@"授权OK");
            } else {
                NSLog(@"没有授权");
                NSLog(@"AuthPlayer error :%@",error);
            }
        }
    };
}
- (void)saveHighScore:(int64_t)score identifier:(NSString *)identifier{
    if ([GKLocalPlayer localPlayer].isAuthenticated) {
        //得到分数的报告
        GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier:identifier];
        scoreReporter.value = score;
        NSArray<GKScore*> *scoreArray = @[scoreReporter];
        //上传分数
        [GKScore reportScores:scoreArray withCompletionHandler:nil];
    }
}
- (void)downLoadGameCenter{
    if ([GKLocalPlayer localPlayer].isAuthenticated == NO) {
        NSLog(@"没有授权，无法获取更多信息");
        return;
    }
    GKLeaderboard *leaderboadRequest = [GKLeaderboard new];
    //设置好友的范围
    leaderboadRequest.playerScope = GKLeaderboardPlayerScopeGlobal;
    //指定那个区域的排行榜
    NSString *type = @"all";
    if ([type isEqualToString:type]) {
        leaderboadRequest.timeScope = GKLeaderboardTimeScopeToday;
        
    }else if([type isEqualToString:@"week"]){
        leaderboadRequest.timeScope = GKLeaderboardTimeScopeWeek;
        
    }else if([type isEqualToString:@"all"]){
        leaderboadRequest.timeScope = GKLeaderboardTimeScopeAllTime;
        
    }
    //哪一个排行榜
    NSString *ID = @"cn.com.blizzmi.MineSweep";
    leaderboadRequest.identifier = ID;
    //从那个排名到那个排名
    NSInteger location = 1;
    NSInteger length = 10;
    leaderboadRequest.range = NSMakeRange(location, length);
    //请求数据
    [leaderboadRequest loadScoresWithCompletionHandler:^(NSArray<GKScore *> * _Nullable scores, NSError * _Nullable error) {
        if (error) {
            NSLog(@"请求分数失败");
            NSLog(@"error = %@",error);
        }else{
            NSLog(@"请求分数成功");
            //定义一个可变字符串存放用户信息
            NSMutableString *userInfo = [NSMutableString string];
            NSString *rankBoardID = nil;
            for (GKScore *score in scores) {
                NSLog(@"");
                //得到排行榜的 id
                NSString *gamecenterID = score.leaderboardIdentifier;
                NSString *playerName = score.player.displayName;
                NSInteger scroeNumb = score.value;
                NSInteger rank = score.rank;
                NSLog(@"排行榜 = %@，玩家名字 = %@，玩家分数 = %zd，玩家排名 = %zd",gamecenterID,playerName,scroeNumb,rank);
                [userInfo appendString:[NSString stringWithFormat:@"玩家名字 = %@，玩家分数 = %zd，玩家排名 = %zd",playerName,scroeNumb,rank]];
                [userInfo appendString:@"\n"];
                rankBoardID = gamecenterID;
            }
            //展示

        }
    }];
}
- (void)getAllOnlineFriends {
    if ([GKLocalPlayer localPlayer].isAuthenticated == NO) {
        NSLog(@"没有授权，无法获取好友信息");
        return;
    }
    [[GKLocalPlayer localPlayer] loadFriendPlayersWithCompletionHandler:^(NSArray<GKPlayer *> * _Nullable friendPlayers, NSError * _Nullable error) {
        //定义一个可变字符串存放用户信息
        NSMutableString *userInfo = [NSMutableString string];
        
        for (GKPlayer *player in friendPlayers) {
            NSString *name = player.displayName;
            NSString *al = player.alias;
            //NSString *ID = player.guestIdentifier;
            NSString *ID = @"";
            [userInfo appendString:[NSString stringWithFormat:@"好友名字 = %@，nickName = %@%@",name,al,ID]];
            [userInfo appendString:@"\n"];
        }
    }];
}
- (void)gameCenterInViewController:(UIViewController *)vc{
    if ([GKLocalPlayer localPlayer].isAuthenticated == NO) {
        NSLog(@"没有授权，无法获取展示中心");
        return;
    }
    GKGameCenterViewController *GCVC = [GKGameCenterViewController new];
    //跳转指定的排行榜中
//    [GCVC setLeaderboardIdentifier:@"cn.com.blizzmi.MineSweep"];
    //跳转到那个时间段
    NSString *type = @"all";
    if ([type isEqualToString:@"today"]) {
        [GCVC setLeaderboardTimeScope:GKLeaderboardTimeScopeToday];
    }else if([type isEqualToString:@"week"]){
        [GCVC setLeaderboardTimeScope:GKLeaderboardTimeScopeWeek];
    }else if ([type isEqualToString:@"all"]){
        [GCVC setLeaderboardTimeScope:GKLeaderboardTimeScopeAllTime];
    }
    [vc presentViewController:GCVC animated:YES completion:nil];
}

- (void)uploadAchievmentWithComplete:(double)complete identifier:(NSString *)identifier{
    if ([GKLocalPlayer localPlayer].isAuthenticated == NO) {
        NSLog(@"没有授权，上传不了成就");
        return;
    }
    GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier:@"cn.com.blizzmi.MineSweep"];
    [achievement setPercentComplete:complete];
    [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
        }else{
            NSLog(@"上传成就成功");
        }
    }];
}
#pragma mark -  GKGameCenterControllerDelegate
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
