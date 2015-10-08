//
//  MainViewController.m
//  星星育儿搜
//
//  Created by qingyun on 15/9/14.
//  Copyright (c) 2015年 河南青云信息科技有限公司. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.clipsToBounds = YES;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]){
         [self getMessage];
    }
    //通知中心添加观察者（收信人）
    //登录成功消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessage) name:@"LoginSuccess" object:nil];
    //第三方登录成功消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessage) name:@"oauthSuccess" object:nil];
    //退出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leave) name:@"leaveout" object:nil];
   
}

-(void)getMessage{
    UINavigationController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LikeNavigation"];
   // [self.tabBar setBackgroundColor:[UIColor clearColor]];
    vc.title = @"我收藏";
    self.tabBarItem.image = [UIImage imageNamed:@"sstar_small"];
    NSArray *vcs = self.viewControllers;
    NSMutableArray *muvcs = [NSMutableArray arrayWithArray:vcs];
    [muvcs addObject:vc];
    
    self.viewControllers = muvcs;
    
}
//leave
-(void)leave{
    NSArray *views = self.viewControllers;
    NSMutableArray *vcs = [NSMutableArray array];
    for(int i = 0; i < views.count - 1; i++ ) {
        [vcs addObject:views];
    }
    self.viewControllers = vcs;
    [self reloadInputViews];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
