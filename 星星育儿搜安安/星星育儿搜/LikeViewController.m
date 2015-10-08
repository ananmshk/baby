//
//  LikeViewController.m
//  星星育儿搜
//
//  Created by qingyun on 15/9/20.
//  Copyright (c) 2015年 河南青云信息科技有限公司. All rights reserved.
//

#import "LikeViewController.h"
#import "AFNetworking.h"
#import "Common.h"
#import "PublicModel.h"
#import "LikeViewCell.h"
#import "UIViewController+ShareViewController.h"
#import "SVProgressHUD.h"
#import "DetailsViewController.h"

static int PageN = 1;
@interface LikeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableV;

@property(nonatomic, retain)NSMutableArray *dataArray;

@end

@implementation LikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.e
    
    self.title = @"收藏榜";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableV.dataSource = self;
    self.tableV.delegate = self;
    [self loadData];
    self.navigationController.navigationBar.translucent = YES;
    
    //添加下拉刷新空间
 //   UIRefreshControl *control = [[UIRefreshControl alloc] init];
    
//    self.refreshControl = control;
////    [self.refreshControl addTarget:self action:@selector(reloadNew:) forControlEvents:UIControlEventValueChanged];
//    NSAttributedString *attString = [[NSAttributedString alloc]
//                                     initWithString:@"下拉加载更多"
//                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
//                                                  NSForegroundColorAttributeName : [UIColor orangeColor]}];
//    
 //   [self.refreshControl setAttributedTitle:attString];
    
    

    
    
    
    
    //添加下拉刷新空间
//    UIRefreshControl *control = [[UIRefreshControl alloc] init];

//    self.refreshControl = control;
//    [self.refreshControl addTarget:self action:@selector(reloadNew:) forControlEvents:UIControlEventValueChanged];
//    
//    //设置refreshControl的标题
//    [self setRefreshControlTitle:@"下拉加载更新！"];

}
-(void)loadData{
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
    
    NSDictionary *parament = @{@"c":KC,@"a":@"msglist",@"userid":userid};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:KURL parameters:parament success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *data = responseObject[@"data"];
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:data.count];
        for (NSDictionary *dict in data) {
            PublicModel *model = [[PublicModel alloc] initWithDictionary:dict];
            [models addObject:model];
            
        }
        self.dataArray = models;
        [self.tableV reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];

}

//加载更多
- (void)loadMoreData
{
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    NSMutableDictionary *parament = [NSMutableDictionary dictionaryWithDictionary:@{@"c":KC,@"a":@"msglist",@"userid":userid}];
    NSString *page = [NSString stringWithFormat:@"%d",PageN++];
    [parament setObject:page forKey:@"page"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:KURL parameters:parament success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"msg"] isEqualToString:@"failure"]) {
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"失败" message:@"没有更多了" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [view show];
        }
        
        NSArray *data = responseObject[@"data"];
        //        NSMutableArray *models = [NSMutableArray arrayWithCapacity:data.count];
        for (NSDictionary *dict  in data) {
            PublicModel *model = [[PublicModel alloc]initWithDictionary:dict];
            [self.dataArray addObject:model];
        }
        
        //        self.dataarray = models;
        [self.tableV reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LikeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"likeCell" forIndexPath:indexPath];
    [cell GetFromPublicModel:self.dataArray[indexPath.row]];
    return cell;
}
//传递到详情页面
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DetailsViewController *vc = segue.destinationViewController;
    vc.hidesBottomBarWhenPushed = YES;
    NSIndexPath *getIndex = [self.tableV indexPathForCell:sender];
    PublicModel *model = self.dataArray[getIndex.row];
    vc.model = model;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//退出账号
- (IBAction)leaveOut:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userid"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveout" object:nil];
}
- (IBAction)share:(id)sender {
    [self showShareActionSheet:self.view];
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
