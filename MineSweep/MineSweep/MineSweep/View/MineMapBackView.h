//
//  MineMapBackView.h
//  MineSweep
//
//  Created by BLIZZMI on 2019/7/18.
//  Copyright © 2019 BLIZZMI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^mineMapClickedPrimaryBlcok)(NSInteger,NSInteger);
@interface MineMapBackView : UIView
@property (nonatomic, strong) NSMutableArray *appearacneArray;
@property (nonatomic, strong) mineMapClickedPrimaryBlcok clickedBlcok;

- (instancetype)initWithFrame:(CGRect)frame
                    titleName:(NSString *)titleName
             mapBackImageName:(NSString *)mapBackImageName
                          row:(NSInteger)row
                       column:(NSInteger)column
                      padding:(NSInteger)padding;

@end

NS_ASSUME_NONNULL_END
