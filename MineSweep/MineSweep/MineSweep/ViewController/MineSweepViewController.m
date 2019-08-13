//
//  MineSweepViewController.m
//  MineSweep
//
//  Created by BLIZZMI on 2019/7/15.
//  Copyright © 2019 BLIZZMI. All rights reserved.
//

#import "MineSweepViewController.h"
#import "Masonry.h"
#import "UIImage+Extension.h"
#import "GameStartViewController.h"
#import "GameCenterHelper.h"

static float const ratio = 812;

@interface MineSweepViewController ()
@property (nonatomic, strong) UIButton *paihang;
@end

@implementation MineSweepViewController
- (UIButton *)paihang{
    if (!_paihang) {
        _paihang = [[UIButton alloc] initWithFrame:CGRectMake(self.navigationController.navigationBar.frame.size.width - 79, self.navigationController.navigationBar.frame.size.height/2-32, 64, 64)];
        [_paihang  setImage:[UIImage imageNamed:@"tubiao-paihang"] forState:UIControlStateNormal];
        [_paihang addTarget:self action:@selector(paihangClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _paihang;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[GameCenterHelper shareGameCenterHelper] authPlayerInViewController:self];

    [self inittialUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage createImageWithColor:[UIColor clearColor]]];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar addSubview:self.paihang];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
    [self.paihang removeFromSuperview];
}
- (void)inittialUI{
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backImage.image = [UIImage imageNamed:@"background"];
    [self.view addSubview:backImage];
    
    UIImageView *logo = [[UIImageView alloc] init];
    logo.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:logo];

    UIButton *simple = [[UIButton alloc] init];
    [simple setImage:[UIImage imageNamed:@"SIMPLE"] forState:UIControlStateNormal];
    [simple addTarget:self action:@selector(simpleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:simple];
    
    UIButton *medium = [[UIButton alloc] init];
    [medium setImage:[UIImage imageNamed:@"MEDIUM"] forState:UIControlStateNormal];
    [medium addTarget:self action:@selector(mediumButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:medium];
    
    UIButton *difficult = [[UIButton alloc] init];
    [difficult setImage:[UIImage imageNamed:@"DIFFICULT"] forState:UIControlStateNormal];
    [difficult addTarget:self action:@selector(difficultButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:difficult];
    
    UIButton *challenge = [[UIButton alloc] init];
    [challenge setImage:[UIImage imageNamed:@"CHALLENGE"] forState:UIControlStateNormal];
    [challenge addTarget:self action:@selector(challengeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:challenge];
    
    float screenRation = [UIScreen mainScreen].bounds.size.height/ratio;
    
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backImage).equalTo(@(70*screenRation));
        make.centerX.mas_equalTo(backImage.mas_centerX);
        make.width.mas_equalTo(@217);
        make.height.mas_equalTo(@120);
    }];
    [simple mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(logo).equalTo(@(200*screenRation));
        make.centerX.mas_equalTo(backImage.mas_centerX);
        make.width.mas_equalTo(@209);
        make.height.mas_equalTo(@60);
    }];
    [medium mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(simple).equalTo(@(120*screenRation));
        make.centerX.mas_equalTo(backImage.mas_centerX);
        make.width.mas_equalTo(@209);
        make.height.mas_equalTo(@60);
    }];
    [difficult mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(medium).equalTo(@(120*screenRation));
        make.centerX.mas_equalTo(backImage.mas_centerX);
        make.width.mas_equalTo(@209);
        make.height.mas_equalTo(@60);
    }];
    [challenge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(difficult).equalTo(@(120*screenRation));
        make.centerX.mas_equalTo(backImage.mas_centerX);
        make.width.mas_equalTo(@209);
        make.height.mas_equalTo(@60);
    }];
}
- (void)paihangClicked{
    [[GameCenterHelper shareGameCenterHelper] gameCenterInViewController:self];
}
- (void)simpleButtonClicked:(UIResponder *)sender{
    GameStartViewController *gameStart = [[GameStartViewController alloc] initWithGameType:simeple];
    [self.navigationController pushViewController:gameStart animated:YES];
}
- (void)mediumButtonClicked:(UIResponder *)sender{
    GameStartViewController *gameStart = [[GameStartViewController alloc] initWithGameType:medium];
    [self.navigationController pushViewController:gameStart animated:YES];
}
- (void)difficultButtonClicked:(UIResponder *)sender{
    GameStartViewController *gameStart = [[GameStartViewController alloc] initWithGameType:difficult];
    [self.navigationController pushViewController:gameStart animated:YES];
}
- (void)challengeButtonClicked:(UIResponder *)sender{
    GameStartViewController *gameStart = [[GameStartViewController alloc] initWithGameType:challenge];
    [self.navigationController pushViewController:gameStart animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
