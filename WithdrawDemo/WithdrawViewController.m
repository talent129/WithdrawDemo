//
//  WithdrawViewController.m
//  WithdrawDemo
//
//  Created by iMac on 16/5/19.
//  Copyright © 2016年 Cai. All rights reserved.
//

#import "WithdrawViewController.h"
#import "Masonry.h"
#import "NSString+Alert.h"
#import "WithdrawView.h"

@interface WithdrawViewController ()
{
    UIWindow *_window;
}

@property (nonatomic, strong) UITextField *moneyField;
@property (nonatomic, strong) UIButton *withdrawBtn;

@property (nonatomic, strong) WithdrawView *withdrawView;

@end

@implementation WithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"提现";
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    [self setupUI];
    
    [self changeBtnStatusNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeWithDrawViewNoti) name:@"RemoveWithdrawNoti" object:nil];
    
}

- (void)removeWithDrawViewNoti
{
    if (_window != nil) {
        [_window removeFromSuperview];
        _window = nil;
    }
    
    if (_withdrawView != nil) {
        [_withdrawView removeFromSuperview];
        _withdrawView = nil;
    }
}

- (void)setupUI
{
    _moneyField = [[UITextField alloc] init];
    _moneyField.backgroundColor = [UIColor whiteColor];
    _moneyField.layer.cornerRadius = 8.0;
    _moneyField.placeholder = @"输入提现金额";
    _moneyField.font = [UIFont systemFontOfSize:15];
    _moneyField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_moneyField];
    
    _withdrawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _withdrawBtn.backgroundColor = [UIColor orangeColor];
    _withdrawBtn.layer.cornerRadius = 8.0;
    _withdrawBtn.enabled = NO;
    [_withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
    _withdrawBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_withdrawBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_withdrawBtn addTarget:self action:@selector(withdrawBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_withdrawBtn];
    
    __weak typeof(self) weakSelf = self;
    [_moneyField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.mas_equalTo(200);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width - 60, 40));
    }];
    
    [_withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(_moneyField.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width - 60, 39));
    }];
}

- (void)changeBtnStatusNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBtnStatus) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)changeBtnStatus
{
    if (_moneyField.text.length > 0) {
        [_withdrawBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _withdrawBtn.enabled = YES;
    }else {
        _withdrawBtn.enabled = NO;
        [_withdrawBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}

- (void)withdrawBtnAction
{
    if ([_moneyField.text integerValue] < 1.0) {
        [@"提现金额不能小于1元" alert];
        return;
    }
    if ([_moneyField.text integerValue] > 1000) {//最大金额为当前账户剩余可提现金额--这里定义为1000
        [@"不可超出可提现金额" alert];
        return;
    }
    
    if (![self isPureIntWithText:_moneyField.text]) {
        [@"提现金额须为整数" alert];
        return;
    }
    
    [_moneyField resignFirstResponder];
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.hidden = NO;
    _window.windowLevel = UIWindowLevelAlert;
    
    _withdrawView = [[WithdrawView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _withdrawView.amount = _moneyField.text;
    
    [_window addSubview:_withdrawView];
    
}

//判断是否是整数
- (BOOL)isPureIntWithText:(NSString *)text
{
    NSScanner *scan = [NSScanner scannerWithString:text];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RemoveWithdrawNoti" object:nil];
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
