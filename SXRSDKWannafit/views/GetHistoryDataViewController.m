//
//  GetHistoryDataViewController.m
//  CZJKFuncList
//
//  Created by qf on 16/10/12.
//  Copyright © 2016年 Keeprapid. All rights reserved.
//

#import "GetHistoryDataViewController.h"
#import "SXRService.h"

@interface GetHistoryDataViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView* tableview;
@property(nonatomic, strong)UILabel* infolabel;
@property(nonatomic, strong)NSMutableArray* resultlist;

@end

@implementation GetHistoryDataViewController
-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReadData:) name:notify_key_JY_did_read_history_data object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReadFinish:) name:notify_key_JY_sync_history_data_finish object:nil];
    [self refreshInfoLabel];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.resultlist = [[NSMutableArray alloc] init];
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-65) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    // Do any additional setup after loading the view.
    self.tableview.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 145)];
        view.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-200)/2.0, 10, 200, 30)];
        [btn setTitle:NSLocalizedString(@"Read Data", nil) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor darkGrayColor]];
        [btn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        self.infolabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, CGRectGetWidth(self.view.frame), 90)];
        self.infolabel.textColor = [UIColor blackColor];
        self.infolabel.adjustsFontSizeToFitWidth = YES;
        self.infolabel.minimumScaleFactor = 0.5;
        self.infolabel.textAlignment = NSTextAlignmentLeft;
        self.infolabel.numberOfLines = 0;
        
        [view addSubview:self.infolabel];
        view;
    });
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
    if ([[SXR shareInstance] isConnect]) {
        [SXRService GetHistoryData:nil];
    }else{
        UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Device not Connected", nil) preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:ac animated:YES completion:nil];
        
    }
}

-(void)refreshInfoLabel{
    NSDictionary* bonginfo = [SXRSDKUtils getDeviceInformation:[SXRSDKConfig getCurrentDeviceUUID]];
    double lastsporttime = 0;
    if (bonginfo) {
        if ([bonginfo.allKeys containsObject:BONGINFO_KEY_LASTSYNCTIME]) {
            lastsporttime = [[bonginfo objectForKey:BONGINFO_KEY_LASTSYNCTIME] doubleValue];
        }
    }
    self.infolabel.text = [NSString stringWithFormat:@"Last Read HistoryDataTime: %.0f\n%@",lastsporttime,
                           [NSDateFormatter localizedStringFromDate:[NSDate dateWithTimeIntervalSince1970:lastsporttime] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle]];

}

-(void)onReadData:(NSNotification*)notify{
    NSDictionary* param = notify.userInfo;
    NSArray* datalist = [param objectForKey:JY_NOTIFY_PARAM_DATALIST];
    for (NSDictionary* datainfo in datalist) {
        int mode = [[datainfo objectForKey:JY_NOTIFY_PARAM_MODE] intValue];
        int step = [[datainfo objectForKey:JY_NOTIFY_PARAM_STEP] intValue];
        int heartrate = [[datainfo objectForKey:JY_NOTIFY_PARAM_HEARTRATE] intValue];
        double timestamp = [[datainfo objectForKey:JY_NOTIFY_PARAM_TIMESTAMP] doubleValue];
        NSString* str = [NSString stringWithFormat:@"timestamp->[%.0f],mode->[%d],step->[%d],heart->[%d]",timestamp,mode,step,heartrate];
        [self.resultlist insertObject:str atIndex:0];
        [self.tableview reloadData];
        [self refreshInfoLabel];

    }

}
-(void)onReadFinish:(NSNotification*)notify{
    [self refreshInfoLabel];
    UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Read History Data Finish", nil) preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:ac animated:YES completion:nil];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultlist.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [self.tableview dequeueReusableCellWithIdentifier:@"simplecell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"simplecell"];
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = [self.resultlist objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumScaleFactor = 0.5;
    return cell;
    
}


@end
