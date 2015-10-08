//
//  PublicViewController.m
//  星星育儿搜
//
//  Created by qingyun on 15/9/15.
//  Copyright (c) 2015年 河南青云信息科技有限公司. All rights reserved.
//

#import "PublicViewController.h"
#import "UIViewController+ShareViewController.h"
#import "PublicModel.h"
#import "PublicTableViewCell.h"
#import "Common.h"

#import "AFNetworking.h"
#import <iflyMSC/IFlyRecognizerView.h>
#import <iflyMSC/IFlyRecognizerViewDelegate.h>
#import <iflyMSC/IFlySpeechConstant.h>
#import "SVProgressHUD.h"

#import "DetailsViewController.h"

@interface PublicViewController ()<UITextFieldDelegate, UITableViewDataSource,UITableViewDelegate, IFlyRecognizerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UITableView *tableV;
@property(nonatomic, strong)IFlyRecognizerView *iflyView;//语音识别控件

@property(nonatomic, retain)NSMutableArray *dataArray;

@end

@implementation PublicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //让tableViewcell向右上角对齐
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationController.navigationBar.translucent = YES;
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    self.textField.delegate = self;
    //添加右视图
    self.textField.rightViewMode = UITextFieldViewModeAlways;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setImage:[UIImage imageNamed:@"mike_small"] forState:UIControlStateNormal];
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightView addSubview:btn];
    self.textField.rightView = rightView;
    [btn addTarget:self action:@selector(speeach) forControlEvents:UIControlEventTouchDown];
    [self loadData];
}
-(void)speeach{
    //初始化语音识别控件
    _iflyView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    _iflyView.delegate = self;
    
    //设置返回结果为plain格式
    [_iflyView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    //功能领域，普通听写
    [_iflyView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    [_iflyView start];

}
#pragma mark - ifly delegate

-(void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast{
    NSMutableString *string = [[NSMutableString alloc] init];
    NSDictionary *dic = resultArray[0];
    for (NSString *key in dic) {
        [string appendString:key];
    }
    self.textField.text = [string copy];
    [_iflyView cancel];
    
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
#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return self.dataArray.count;
    }
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PublicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"publicCell" forIndexPath:indexPath];
    [cell GetFromTableViewModel:self.dataArray[indexPath.row]];
    [cell.like addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
    [cell.share addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DetailsViewController *vc = segue.destinationViewController;
    NSIndexPath *Deindex = [self.tableV indexPathForCell:sender];
    PublicModel *model = self.dataArray[Deindex.row];

    vc.model = model;
    vc.title = model.title;
}


- (IBAction)search:(id)sender {
    if (self.textField.text.length == 0 ||[self.textField.text isEqualToString:@""]) {
//        UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"警告" message:@"输入不能为空" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
       //  [view show];
        [SVProgressHUD showErrorWithStatus:@"搜索内容不能为空"];
       
        
    }else{
        self.keywards = self.textField.text;
        self.labelid = nil;
        self.userid = nil;
        self.title = self.textField.text;
        [self loadData];
    }

   }
- (void)loadData
{
    //    NSDictionary *parament = @{@"c":KC,@"a":@"msglist",@"keywards":self.keywards,@"labelid":self.labelid,@"userid":self.userid};
    NSMutableDictionary *parament = [NSMutableDictionary dictionaryWithDictionary:@{@"c":@"iosapp",@"a":@"msglist"}];
    if (self.keywards) {
        [parament setObject:self.keywards forKey:@"keywards"];
    }
    if (self.labelid) {
        [parament setObject:self.labelid forKey:@"labelid"];
    }
    if (self.userid) {
        [parament setObject:self.userid forKey:@"userid"];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:KURL parameters:parament success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        NSArray *data = responseObject[@"data"];
        NSMutableArray *models = [NSMutableArray array];
        for (NSDictionary *dict  in data) {
            PublicModel *model = [[PublicModel alloc]initWithDictionary:dict];
            [models addObject:model];
        }
        
        self.dataArray = models;
        [self.tableV reloadData];
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    [self search:nil];
    return YES;
}


- (IBAction)share:(id)sender {
    [self showShareActionSheet:self.view];
}

- (IBAction)like:(id)sender {
    // 取出userdefault的用户id
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]) {
        UINavigationController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigation"];
        VC.hidesBottomBarWhenPushed = YES;
        //        [self.navigationController pushViewController:VC animated:YES];
        [self presentViewController:VC animated:YES completion:nil];
        //        [VC.navigationController setNavigationBarHidden:YES];
        
    }else{
        PublicTableViewCell *cell = (PublicTableViewCell *)[sender superview];
        NSIndexPath *GTindex = [self.tableV indexPathForCell:cell];
        PublicModel *model = self.dataArray[GTindex.row];
        NSString *msgid = model.msgid;
        NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
        NSDictionary *parament = @{@"c":KC,@"a":@"collect",@"msgid":msgid,@"userid":userid};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager GET:KURL parameters:parament success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *code = responseObject[@"code"];
            if ([code isEqual:@0]) {
                if ([responseObject[@"msg"] isEqualToString:@"对不起，您已经收藏过"]) {
                    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"收藏失败" message:@"对不起，您已经收藏过" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [view show];
                }else{
                    
                    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"收藏失败" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [view show];
                }
            }else{
                UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"收藏成功" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [view show];
                
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    

}
- (void)onError:(IFlySpeechError *)error{
    
}
@end







