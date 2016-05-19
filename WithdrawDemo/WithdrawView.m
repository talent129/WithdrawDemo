//
//  WithdrawView.m
//  WithdrawDemo
//
//  Created by iMac on 16/5/19.
//  Copyright © 2016年 Cai. All rights reserved.
//

#import "WithdrawView.h"
#import "Masonry.h"
#import "NSString+Alert.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface WithdrawView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *inputPwdView;//输入密码视图
@property (nonatomic, strong) NSMutableArray *pwdDataSourceArray;

@end

@implementation WithdrawView

- (UIView *)inputPwdView
{
    if (_inputPwdView == nil) {
        _inputPwdView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeight - 100)];
        _inputPwdView.backgroundColor = [UIColor whiteColor];
    }
    return _inputPwdView;
}

- (NSMutableArray *)pwdDataSourceArray
{
    if (_pwdDataSourceArray == nil) {
        _pwdDataSourceArray = [NSMutableArray array];
    }
    return _pwdDataSourceArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        
        [self addSubview:self.inputPwdView];
        
        [self _initView];
    }
    return self;
}

- (void)_initView
{
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(10, 10, 60, 60);
    cancleBtn.contentEdgeInsets = UIEdgeInsetsMake(-5, -5, 15, 15);
    [cancleBtn setImage:[UIImage imageNamed:@"home__share_close"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(removeInputPwdViewAction) forControlEvents:UIControlEventTouchUpInside];
    [_inputPwdView addSubview:cancleBtn];
    
    UILabel *inputPwdLabel = [[UILabel alloc] init];
    inputPwdLabel.text = @"输入密码";
    inputPwdLabel.font = [UIFont boldSystemFontOfSize:16];
    inputPwdLabel.textColor = [UIColor lightGrayColor];
    [_inputPwdView addSubview:inputPwdLabel];
    
    __weak typeof(_inputPwdView) weakInputPwdView = _inputPwdView;
    [inputPwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakInputPwdView);
        make.top.mas_equalTo(25);
    }];
    
    UITextField *inputPwdField = [[UITextField alloc] init];
    inputPwdField.hidden = YES;
    inputPwdField.delegate = self;
    inputPwdField.keyboardType = UIKeyboardTypeNumberPad;
    [self addNotification];
    [_inputPwdView addSubview:inputPwdField];
    
    [inputPwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(40);
        make.trailing.mas_equalTo(-40);
        make.top.equalTo(inputPwdLabel.mas_bottom).offset(40);
        make.height.mas_equalTo(44);
    }];
    
    [inputPwdField becomeFirstResponder];
    
    UIView *inputPwdView = [[UIView alloc] init];
    inputPwdView.layer.borderColor = [UIColor grayColor].CGColor;
    inputPwdView.layer.borderWidth = 1;
    inputPwdView.layer.cornerRadius = 8.0;
    [_inputPwdView addSubview:inputPwdView];
    
    [inputPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(inputPwdField);
        make.trailing.equalTo(inputPwdField);
        make.centerY.equalTo(inputPwdField);
        make.height.equalTo(inputPwdField);
    }];
    
    for (int i = 0; i < 5; i ++) {
        
        __weak typeof(inputPwdView) weakInputView = inputPwdView;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor grayColor];
        [inputPwdView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@((kScreenWidth - 80 - 5)/6.0 + i * ((kScreenWidth - 80 - 5)/6.0)));
            make.width.mas_equalTo(1);
            make.centerY.equalTo(weakInputView);
            make.height.mas_equalTo(40);
        }];
    }
    
    _pwdDataSourceArray = [NSMutableArray array];
    
    for (int i = 0; i < 6; i ++) {
        UITextField *pwdfield = [[UITextField alloc] init];
        pwdfield.enabled = NO;
        pwdfield.textAlignment = NSTextAlignmentCenter;
        pwdfield.secureTextEntry = YES;
        [_inputPwdView addSubview:pwdfield];
        
        [pwdfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@(40 + i * (kScreenWidth - 80 - 5)/6.0));
            make.top.equalTo(inputPwdField);
            make.height.equalTo(inputPwdField);
            make.width.mas_equalTo((kScreenWidth - 80 - 5)/6.0);
        }];
        
        [_pwdDataSourceArray addObject:pwdfield];
    }
    
    UIButton *forgetTradePwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetTradePwdBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    forgetTradePwdBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [forgetTradePwdBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [forgetTradePwdBtn addTarget:self action:@selector(forgetTradePwdBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_inputPwdView addSubview:forgetTradePwdBtn];
    
    [forgetTradePwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(inputPwdField);
        make.top.equalTo(inputPwdField.mas_bottom).offset(20);
    }];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)forgetTradePwdBtnAction
{
    [@"跳转忘记密码" alert];
}

- (void)removeInputPwdViewAction
{
    //发个通知  移除提现界面吧
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveWithdrawNoti" object:nil];
}

- (void)textChange:(NSNotification *)noti
{
    UITextField *text = noti.object;
    NSString *pwd = text.text;
    NSLog(@"password:%@", pwd);
    
    for (UITextField *txf in _pwdDataSourceArray) {
        txf.hidden = YES;
    }
    
    for (int i = 0; i < pwd.length; i ++) {
        ((UITextField *)[_pwdDataSourceArray objectAtIndex:i]).hidden = NO;
    }
    
    for (int i = 0; i < _pwdDataSourceArray.count; i ++) {
        UITextField *pwdTx = [_pwdDataSourceArray objectAtIndex:i];
        if (i < pwd.length) {
            NSString *pwdStr = [pwd substringWithRange:NSMakeRange(i, 1)];
            pwdTx.text = pwdStr;
        }
    }
    
    if (pwd.length == _pwdDataSourceArray.count) {
        [@"请求网路--提现" alert];
        return;
    }
}

#pragma mark -UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string   // return NO to not change text
{
    if ([string isEqualToString:@"\n"]) {
        //回车键
        [textField resignFirstResponder];
        return NO;
    }else if (string.length == 0) {
        //判断是不是删除键
        return YES;
    }else if (textField.text.length >= 6) {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        return NO;
    }else {
        return YES;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

@end
