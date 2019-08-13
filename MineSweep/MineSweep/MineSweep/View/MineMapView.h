//
//  MineMapView.h
//  MineSweep
//
//  Created by BLIZZMI on 2019/7/16.
//  Copyright © 2019 BLIZZMI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MineMapView;
@protocol MineMapViewDelegate <NSObject>

- (void)mineMapView:(MineMapView *)mineMapView tapViewIndex:(NSInteger)index roundMineNumber:(NSInteger)number;

@end
@interface MineMapView : UIView
@property (nonatomic, weak) UIImageView *bulletAndNumberImageView;
@property (nonatomic, weak) UIImageView *appeareImageView;
@property (nonatomic, weak) UIImageView *flagImageView;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *numberPix;
@property (nonatomic, assign) BOOL flagStyle;
@property (nonatomic, weak) id<MineMapViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
