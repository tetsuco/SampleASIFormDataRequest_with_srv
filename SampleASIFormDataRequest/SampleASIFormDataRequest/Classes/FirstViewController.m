//
//  FirstViewController.m
//  SampleASIFormDataRequest
//
//  Created by tetsuco on 11/09/01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"


@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [pb release];
    [sw release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // ボタン表示
    [self uplaodFileButton];
    
    // プログレスバー表示
    [self progressBar];
    
    // ラベルを表示
    [self label];
    
    // スイッチ表示
    [self switchPb];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//--------------------------------------------------
// ファイルアップロードボタン
//--------------------------------------------------
// ボタンを追加
- (void)uplaodFileButton
{
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bt.frame = CGRectMake(60, 150, 200, 40);
    [bt setTitle:@"ファイルアップロード" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(uplaodDataButtonAction:)forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:bt];
}

// ボタンアクション
- (void)uplaodDataButtonAction:(UIButton*)button
{
    // アップロード
    [self uploadStart];
}


//--------------------------------------------------
// プログレスバー
//--------------------------------------------------
// プログレスバーを追加
- (void)progressBar
{
    pb = [[[UIProgressView alloc]
           initWithProgressViewStyle:UIProgressViewStyleDefault] autorelease];
    pb.frame = CGRectMake(60, 20, 200, 10);
    pb.progress = 0.0;
    [self.view addSubview:pb];
}


//--------------------------------------------------
// ラベル
//--------------------------------------------------
// ラベルを追加
- (void)label
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, 265, 200, 50);
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    label.textAlignment = UITextAlignmentLeft;
    label.text = @"プログレスバーを使用する";
    [self.view addSubview:label];
}


//--------------------------------------------------
// スイッチ
//--------------------------------------------------
// スイッチを追加
- (void)switchPb
{
    sw = [[[UISwitch alloc] init] autorelease];
    sw.center = CGPointMake(250, 290);
    sw.on = NO;
    [self.view addSubview:sw];
}


//--------------------------------------------------
// アップロード処理
//--------------------------------------------------
- (void)uploadStart {
    NSURL *url = [NSURL URLWithString:@"http://localhost/test/uploadsample.php"];
    ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:url] autorelease];
    
    [request setPostValue:@"hoge" forKey:@"file_name"];  // ファイル名(仮名:hoge)
    [request setPostValue:@"jpg" forKey:@"extension"];  // 拡張子
    
    // データをセット
    NSString *path = [[NSBundle mainBundle] pathForResource:@"A5B8A1BCA5D7A3B1" ofType:@"jpg"];
    NSData *image = [NSData dataWithContentsOfFile:path];
    [request setData:image forKey:@"upfile"];
    
    [request setTimeOutSeconds:120];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(postSucceeded:)];
    [request setDidFailSelector:@selector(postFailed:)];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    
    if (sw.on == 0) {
        // プログレスバーを使用せずに非同期通信する場合に使用
        [request startAsynchronous];
        
        NSLog(@"プログレスバー未使用");
    } else {
        // プログレスバーを使用する
        ASINetworkQueue *networkQueue = [[ASINetworkQueue alloc] init];
        [networkQueue setUploadProgressDelegate:pb];
        [networkQueue setShowAccurateProgress:YES];
        [networkQueue addOperation:request];    // 非同期通信
        [networkQueue go];
        
        NSLog(@"プログレスバー使用");
    }
}

- (void)postSucceeded:(ASIFormDataRequest *)request
{
    NSString *resString = [request responseString];
    NSLog(@"%@", resString);
}

- (void)postFailed:(ASIFormDataRequest *)request
{
    NSString *resString = [request responseString];
    NSLog(@"%@", resString);
}

@end
