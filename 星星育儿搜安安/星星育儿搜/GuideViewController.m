//
//  GuideViewController.m
//  星星育儿搜
//
//  Created by qingyun on 15/9/14.
//  Copyright (c) 2015年 河南青云信息科技有限公司. All rights reserved.
//

#import "GuideViewController.h"
#import "AppDelegate.h"

@interface GuideViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollVieww;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollVieww.pagingEnabled = YES;
    self.scrollVieww.showsHorizontalScrollIndicator = NO;
    self.scrollVieww.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.scrollVieww.contentSize = self.contentView.frame.size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)guideEnd:(id)sender {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate guideEnd];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //计算出第几页
    self.pageController.currentPage = self.scrollVieww.contentOffset.x/self.scrollVieww.frame.size.width;
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
