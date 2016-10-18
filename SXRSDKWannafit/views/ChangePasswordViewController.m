//
//  ChangePasswordViewController.m
//  CZJKFuncList
//
//  Created by qf on 16/10/13.
//  Copyright © 2016年 Keeprapid. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()
@property(nonatomic,strong)UITextField* oldpassword;
@property(nonatomic,strong)UITextField* newpassword;
@property(nonatomic,strong)UITextField* newpasswordconfirm;
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.oldpassword = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 300, 40)];
    self.oldpassword.textColor = [UIColor blackColor];
    self.oldpassword.placeholder = @"Old Password";
    [self.view addSubview:self.oldpassword];
    
    self.newpassword = [[UITextField alloc] initWithFrame:CGRectMake(10, 60, 300, 40)];
    self.newpassword.textColor = [UIColor blackColor];
    self.newpassword.placeholder = @"New Password";
    [self.view addSubview:self.newpassword];

    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-200)/2.0, 120, 200, 30)];
    [btn setTitle:NSLocalizedString(@"Change Password", nil) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor darkGrayColor]];
    [btn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
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
-(void)onClickBtn:(id)sender{

    if ([self.oldpassword.text isEqualToString:@""] || [self.newpassword.text isEqualToString:@""]) {
        UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Password is Empty", nil) preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:ac animated:YES completion:nil];
        return;
        
    }
    [[SXR shareInstance] SXRSDKChangePasswd:self.oldpassword.text newPasswd:self.newpassword.text callBack:^(NSDictionary *result, NSError *error) {
        if (error) {
            UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@\nerror=%@",NSLocalizedString(@"Change Password Error", nil),error] preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:ac animated:YES completion:nil];
            
        }else{
            UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@\nresult=%@",NSLocalizedString(@"Register Complete", nil),result] preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:ac animated:YES completion:nil];
            
        }
    }];
}
@end
