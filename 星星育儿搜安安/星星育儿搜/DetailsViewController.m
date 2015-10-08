//
//  DetailsViewController.m
//  星星育儿搜
//
//  Created by qingyun on 15/9/18.
//  Copyright (c) 2015年 河南青云信息科技有限公司. All rights reserved.
//

#import "DetailsViewController.h"
#import "PublicModel.h"
#import "UIViewController+ShareViewController.h"
#import "UIImageView+WebCache.h"

#import "AFNetworking.h"
#import "Common.h"
#import "ADViewController.h"
#import "SVProgressHUD.h"
@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *detailsImage;
@property (weak, nonatomic) IBOutlet UITextView *detailsTextView;
@property (weak, nonatomic) IBOutlet UIImageView *ADimage;
@property (nonatomic, copy) NSString *imageurl;
@property (nonatomic, copy) NSString *httpurl;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //让textview 不能编辑
    self.detailsTextView.editable = NO;
    // 请求广告
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:KURL parameters:@{@"c":KC,@"a":@"ad"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.imageurl = responseObject[@"data"][@"imageurl"];
        self.httpurl = responseObject[@"data"][@"httpurl"];
        [self.ADimage sd_setImageWithURL:[NSURL URLWithString:self.imageurl]];
        
        NSLog(@"Detail 请求成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];

    self.detailsTextView.text = self.model.descrip;
    NSString *url = [self.model.images[0] stringByAppendingString:@"_middle.jpg"];
    [self.detailsImage  sd_setImageWithURL:[NSURL URLWithString:url]];
    
    //在广告图片上加按钮 跳转到下一页
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    button.backgroundColor = [UIColor clearColor];
    [self.ADimage addSubview:button];
    [button addTarget:self action:@selector(ADViewController) forControlEvents:UIControlEventTouchDown];
}

-(void)ADViewController{
    ADViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"ADvc"];
    VC.http = self.httpurl;
    [self.navigationController pushViewController:VC animated:YES];
    
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
- (IBAction)like:(id)sender {
    // 取出userdefault的用户id
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]) {
        UINavigationController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigation"];
        VC.hidesBottomBarWhenPushed = YES;
        //        [self.navigationController pushViewController:VC animated:YES];
        [self presentViewController:VC animated:YES completion:nil];
        //        [VC.navigationController setNavigationBarHidden:YES];
        
    }else{
        
        NSString *msgid = self.model.msgid;
        NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
        NSDictionary *parament = @{@"c":KC,@"a":@"collect",@"msgid":msgid,@"userid":userid};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager GET:KURL parameters:parament success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *code = responseObject[@"code"];
            if ([code isEqual:@0]) {
                [SVProgressHUD showErrorWithStatus:@"收藏失败"];
//                UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"收藏失败" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                [view show];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
//                UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"收藏成功" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                [view show];
                
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];

}
}
- (IBAction)share:(id)sender {
    [self showShareActionSheet:self.view];
}


@end
