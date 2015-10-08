//
//  LoginViewController.m
//  星星育儿搜
//
//  Created by qingyun on 15/9/19.
//  Copyright (c) 2015年 河南青云信息科技有限公司. All rights reserved.
//

#import "LoginViewController.h"


#import "Common.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import <ShareSDK/ShareSDK.h>

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWorld;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userName.delegate = self;
    self.passWorld.delegate = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"jiantou"] style:UIBarButtonItemStylePlain target:self action:@selector(GoBackViewController)];
//    self.loginBtn.layer.cornerRadius = self.loginBtn.frame.size.height/2;
//    self.loginBtn.layer.masksToBounds = YES;
//    self.loginBtn.backgroundColor = [self randomColor];
    //密码隐藏显示
    self.passWorld.secureTextEntry = YES;
}
-(UIColor *)randomColor{
    UIColor *color = [UIColor colorWithRed:( arc4random() % 256 / 256.0 )green:( arc4random() % 256 / 256.0 )  blue:( arc4random() % 256 / 256.0 )alpha:.8f];
    return color;

}
-(void)GoBackViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
- (IBAction)btnIsSelected:(id)sender {
    if (self.btn.selected) {
        self.btn.selected = NO;
    }else{
        self.btn.selected = YES;
    }
}
- (IBAction)Login:(id)sender {
    if (self.userName.text.length == 0 || self.passWorld.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"账户或密码不能为空"];
    }else{
        NSDictionary *parament = @{@"c":KC, @"a":@"login", @"username": self.userName.text, @"pwd":self.passWorld.text};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                                                  
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager GET:KURL parameters:parament success:^ void(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", responseObject);
            if ([responseObject[@"code"]isEqual:@0]) {
                [SVProgressHUD showErrorWithStatus:@"账号和密码不匹配"];
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginSuccess" object:nil];
                NSString *identifier = responseObject[@"data"][@"userid"];
                [[NSUserDefaults standardUserDefaults] setObject:identifier forKey:@"userid"];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }
        } failure:^ void(AFHTTPRequestOperation * operation, NSError * error) {
            NSLog(@"%@", error);
        }];
                                                                    }
}
//键盘消失
#pragma mark -  textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.userName resignFirstResponder];
    [self.passWorld resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.userName resignFirstResponder];
    [self.passWorld resignFirstResponder];
}
- (IBAction)SinaLogin:(id)sender {
   
}

- (IBAction)qqLogin:(id)sender {
    
}
- (IBAction)weixinLogin:(id)sender {
}

@end
