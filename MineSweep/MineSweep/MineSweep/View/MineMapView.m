//
//  MineMapView.m
//  MineSweep
//
//  Created by BLIZZMI on 2019/7/16.
//  Copyright © 2019 BLIZZMI. All rights reserved.
//

#import "MineMapView.h"
#import "UIView+Category.h"

@interface MineMapView()
@property (nonatomic, weak) UIImageView *flag;
@end
@implementation MineMapView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *bulletAndNumberImage = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-4, frame.size.height/2-7, 8, 14)];
        bulletAndNumberImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:bulletAndNumberImage];
        UIImageView *appeareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,frame.size.width, frame.size.height)];
        appeareImageView.backgroundColor = [UIColor clearColor];
        appeareImageView.userInteractionEnabled = YES;
        appeareImageView.image = [UIImage imageNamed:@"s_fk"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(appearanceImageTap)];
        [appeareImageView addGestureRecognizer:tap];
        [self addSubview:appeareImageView];
        
        UIImageView *flagImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        flagImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:flagImageView];
        
        UIImageView *flag = [[UIImageView alloc] init];
        flag.backgroundColor = [UIColor clearColor];
        [self addSubview:flag];
        
        self.bulletAndNumberImageView = bulletAndNumberImage;
        self.appeareImageView = appeareImageView;
        self.flagImageView = flagImageView;
        self.flag = flag;
        self.flagStyle = NO;
    }
    return self;
}
- (void)appearanceImageTap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mineMapView:tapViewIndex:roundMineNumber:)]) {
        [self.delegate mineMapView:self tapViewIndex:self.index roundMineNumber:self.number];
    }
}
- (void)setIndex:(NSInteger)index{
    _index = index;
}
- (void)setNumberPix:(NSString *)numberPix{
    _numberPix = numberPix;
}
- (void)setFlagStyle:(BOOL)flagStyle{
    _flagStyle = flagStyle;
    if (flagStyle) {
        self.flagImageView.image = [UIImage imageNamed:@"d_bai"];
        if ([self.numberPix isEqualToString:@"c"]) {
            self.flag.frame = CGRectMake(self.frame.size.width/2 - 5, self.frame.size.height/2 - 7, 10, 14);
            self.flag.image = [UIImage imageNamed:@"c_hq"];
        } else if ([self.numberPix isEqualToString:@"d"]) {
            self.flag.frame = CGRectMake(self.frame.size.width/2 - 5, self.frame.size.height/2 - 7, 11, 15);
            self.flag.image = [UIImage imageNamed:@"d_hq"];
        }else{
            self.flag.frame = CGRectMake(self.frame.size.width/2 - 10, self.frame.size.height/2 - 13, 19, 27);
            self.flag.image = [UIImage imageNamed:@"s_hq"];
        }
    }else{
        self.flag.image = nil;
        self.flagImageView.image = nil;
    }
}
- (void)setNumber:(NSInteger)number{
    _number = number;
    if ([self.numberPix isEqualToString:@"c"]) {
        self.bulletAndNumberImageView.frame = CGRectMake(self.frame.size.width/2-2, self.frame.size.height/2-4, 4, 8);
    }else if([self.numberPix isEqualToString:@"d"]){
        self.bulletAndNumberImageView.frame = CGRectMake(self.frame.size.width/2-2.5, self.frame.size.height/2-5.5, 5, 11);
    }else{
          self.bulletAndNumberImageView.frame = CGRectMake(self.frame.size.width/2-4, self.frame.size.height/2-7, 8, 14);
    }
    switch (number) {
        case 0:
            break;
        case 1:
            self.bulletAndNumberImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_1",self.numberPix]];
            break;
        case 2:
            self.bulletAndNumberImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_2",self.numberPix]];
            break;
        case 3:
            self.bulletAndNumberImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_3",self.numberPix]];
            break;
        case 4:
            self.bulletAndNumberImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_4",self.numberPix]];
            break;
        case 5:
            self.bulletAndNumberImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_5",self.numberPix]];
            break;
        case 6:
            self.bulletAndNumberImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_6",self.numberPix]];
            break;
        case 7:
            self.bulletAndNumberImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_7",self.numberPix]];
            break;
        case 8:
            self.bulletAndNumberImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_8",self.numberPix]];
            break;
        case 9:{
            if ([self.numberPix isEqualToString:@"c"]) {
                self.bulletAndNumberImageView.frame = CGRectMake(self.frame.size.width/2-9, self.frame.size.height/2-10, 18, 20);
            }else{
                self.bulletAndNumberImageView.frame = CGRectMake(self.frame.size.width/2-10, self.frame.size.height/2-12, 20, 24);
            }
            self.bulletAndNumberImageView.image = [UIImage imageNamed:@"d_zd"];
        }
            break;
        default:
            break;
    }
}
@end
