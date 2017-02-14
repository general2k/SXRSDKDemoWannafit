//
//  MemberInfoViewController.m
//  CZJKFuncList
//
//  Created by qf on 16/10/13.
//  Copyright © 2016年 Keeprapid. All rights reserved.
//

#import "MemberInfoViewController.h"

@interface MemberInfoViewController ()
@property(nonatomic,strong)UITextView* retlabel;
@end

@implementation MemberInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat btnwidth = (CGRectGetWidth(self.view.frame)-30)/2.0;
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, btnwidth, 30)];
    [btn setTitle:NSLocalizedString(@"Get Memberinfo", nil) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor darkGrayColor]];
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    btn.titleLabel.minimumScaleFactor = 0.5;
    [btn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    UIButton* btn1 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)+10, 10, btnwidth, 30)];
    [btn1 setTitle:NSLocalizedString(@"Set Memberinfo", nil) forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor darkGrayColor]];
    [btn1 addTarget:self action:@selector(onClickBtn1:) forControlEvents:UIControlEventTouchUpInside];
    btn1.titleLabel.adjustsFontSizeToFitWidth = YES;
    btn1.titleLabel.minimumScaleFactor = 0.5;
    [self.view addSubview:btn1];

    UIButton* btn2 = [[UIButton alloc] initWithFrame:CGRectMake(10, 50, btnwidth, 30)];
    [btn2 setTitle:NSLocalizedString(@"Set Alarm", nil) forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 setBackgroundColor:[UIColor darkGrayColor]];
    [btn2 addTarget:self action:@selector(onClickBtn1:) forControlEvents:UIControlEventTouchUpInside];
    btn2.titleLabel.adjustsFontSizeToFitWidth = YES;
    btn2.titleLabel.minimumScaleFactor = 0.5;
   [self.view addSubview:btn2];
    
    UIButton* btn3 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)+10, 50, btnwidth, 30)];
    [btn3 setTitle:NSLocalizedString(@"Upload Headimage", nil) forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn3 setBackgroundColor:[UIColor darkGrayColor]];
    [btn3 addTarget:self action:@selector(onClickBtn1:) forControlEvents:UIControlEventTouchUpInside];
    btn3.titleLabel.adjustsFontSizeToFitWidth = YES;
    btn3.titleLabel.minimumScaleFactor = 0.5;
    [self.view addSubview:btn3];

    self.retlabel = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(btn3.frame)+10, CGRectGetWidth(self.view.frame)-20, CGRectGetHeight(self.view.frame)-CGRectGetMaxY(btn3.frame)-65)];
    self.retlabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.retlabel];

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
    if (![[SXR shareInstance] isLogin]) {
        UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Not Login", nil) preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:ac animated:YES completion:nil];
        return;
        
    }
    [[SXR shareInstance] SXRSDKGetMemberInfo:nil callBack:^(NSURLSessionDataTask *task, NSDictionary *result, NSError *error){
        if (error) {
            UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@\nerror=%@",NSLocalizedString(@"Send Get Memberinfo Error", nil),error] preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:ac animated:YES completion:nil];
            
        }else{
            self.retlabel.text = [NSString stringWithFormat:@"%@",result];
            
        }
    }];
}

-(void)onClickBtn1:(id)sender{
        UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Please contact marketing@keeprapid.com or 10614126@qq.com for further information.请联系marketing@keeprapid.com 或者 10614126@qq.com获取进一步的信息", nil) preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:ac animated:YES completion:nil];
        return;
        
}


@end
