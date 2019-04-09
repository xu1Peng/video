//
//  MainViewController.m
//  LanSongEditor_all
//
//  Created by sno on 16/12/12.
//  Copyright © 2016年 sno. All rights reserved.
//

#import "MainViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#import "LanSongUtils.h"
#import "UIColor+Util.h"
#import "Masonry.h"
#import "CameraFullPortVC.h"
#import "Demo1PenMothedVC.h"
#import "FilterVideoDemoVC.h"
#import "CameraSegmentRecordVC.h"

#import "GameVideoDemoVC.h"
#import "AEModuleDemoVC.h"
#import "AEPreviewDemoVC.h"

#import "VideoEffectVC.h"
#import "BitmapPadPreviewDemoVC.h"
#import "LSOLocalVideoVC.h"
#import "UIPenDemoVC.h"
#import "RecordUIViewDemoVC.h"
#import "UIPenParticleDemoVC.h"
#import "AETextVideoDemoVC.h"
#import "AePreviewListDemoVC.h"
#import "CommonEditListVC.h"
#import "AEModuleAutoSearchVC.h"


@interface MainViewController ()
{
    UIView  *container;
    UILabel *labPath; // 视频路径.
}
@end

#define kVideoFilterDemo 1
//移动缩放旋转演示
#define kDemo1PenMothed 3
#define kVideoUIDemo 4
#define kUIPenDemo 5
#define kCommonEditDemo 6
#define kUIPenParticleDemoVC 7
#define kDirectPlay 8

//竖屏
#define kSegmentRecordFullPort 10
//分段录制
#define kSegmentRecordSegmentRecord 12

#define kDemo2PenMothed 13
#define kLanSongExtractFrame 14
#define kLikeDouYinDemo 15

#define kAEPreviewDemo 16
#define kGameVideoDemo 17
#define kAEModuleTextDemo 18



#define kUseDefaultVideo 801
#define kSelectVideo 802

@implementation MainViewController
{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"蓝松短视频SDK";
    
    self.view.backgroundColor=[UIColor lightGrayColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    /*
     初始化SDK
     */
     if([LanSongEditor initSDK:nil]==NO){
        [LanSongUtils showDialog:@"SDK已经过期,请更新到最新的版本/或联系我们:"];
     }else{
//         [self showSDKInfo];
     }
    /*
     删除sdk中所有的临时文件.
     */
    [LSOFileUtil deleteAllSDKFiles];
    [self initView];
    
    [self testFile];
}
- (void)viewDidAppear:(BOOL)animated
{
    [LanSongUtils setViewControllerPortrait];
} /**
 点击后, 进去界面.
 */
-(void)onClicked:(UIView *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    UIViewController *pushVC=nil;
    
    if([self needCheckBox:sender]){
        //检查是否正常.
        if([LSOFileUtil fileExist:[AppDelegate getInstance].currentEditVideo]==NO){
            [LanSongUtils showDialog:@"请选择默认视频 或 相册视频"];
            return ;
        }
    }
    switch (sender.tag) {
        case kUseDefaultVideo:
            {
                NSString *defaultVideo=@"dy_xialu2";
                NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:defaultVideo withExtension:@"mp4"];
                if(sampleURL!=nil){
                    labPath.text=[NSString stringWithFormat:@"使用默认视频:%@",defaultVideo];
                    [AppDelegate getInstance].currentEditVideo=[LSOFileUtil urlToFileString:sampleURL];
                }else{
                    [LanSongUtils showDialog:@"选择默认视频  ERROR!!"];
                }
                sender.backgroundColor=[UIColor greenColor];
                break;
            }
        case kSelectVideo:
            {
                sender.backgroundColor=[UIColor yellowColor];
                UIViewController  *pushVC2=[[LSOLocalVideoVC alloc] init];
                [self.navigationController pushViewController:pushVC2 animated:YES];
            }
            break;
        case kSegmentRecordFullPort:
            pushVC=[[CameraFullPortVC alloc] init];  
            break;
        case kSegmentRecordSegmentRecord:
            pushVC=[[CameraSegmentRecordVC alloc] init];  //分段录制.
            break;
        case kDemo1PenMothed:
            pushVC=[[Demo1PenMothedVC alloc] init];  //移动缩放旋转1
            break;
        case kVideoFilterDemo:
            pushVC=[[FilterVideoDemoVC alloc] init];  //滤镜
            break;
        case kUIPenDemo:
            pushVC=[[UIPenDemoVC alloc] init];  //UI图层;
            break;
        case kUIPenParticleDemoVC:
            pushVC=[[UIPenParticleDemoVC alloc] init];  //UI图层粒子效果;
            break;
        case kLikeDouYinDemo:
            pushVC=[[VideoEffectVC alloc] init];
            break;
        case kAEPreviewDemo:
            pushVC=[[AePreviewListDemoVC alloc] init];
            break;
        case kAEModuleTextDemo:  //文字演示.
            pushVC=[[AETextVideoDemoVC alloc] init];
            break;
        case kCommonEditDemo:
             pushVC=[[CommonEditListVC alloc] init];  //普通功能演示
            break;
        case kDirectPlay:
            {
                 [LanSongUtils startVideoPlayerVC:self.navigationController dstPath:[AppDelegate getInstance].currentEditVideo];
            }
            break;
        case kGameVideoDemo:
            pushVC=[[GameVideoDemoVC alloc] init];  //游戏录制类演示
            break;
        default:
            break;
    }
    if (pushVC!=nil) {
        [self.navigationController pushViewController:pushVC animated:YES];
    }
}

-(void)initView
{
    UIScrollView *scrollView = [UIScrollView new];
    [self.view  addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    container = [UIView new];
    [scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    UIView *view=[self newDefaultButton:container];
    
    
    view=[self newButton:view index:kSegmentRecordFullPort hint:@"竖屏录制"];
    view=[self newButton:view index:kSegmentRecordSegmentRecord hint:@"分段录制"];
    view=[self newButton:view index:kDemo1PenMothed hint:@"图层--移动旋转缩放叠加"];
    view=[self newButton:view index:kVideoFilterDemo hint:@"滤镜---图层的方法"];
    view=[self newButton:view index:kUIPenDemo hint:@"UI图层"];
    view=[self newButton:view index:kUIPenParticleDemoVC hint:@"UI图层-粒子效果"];
    
    view=[self newButton:view index:kLikeDouYinDemo hint:@"类似抖音效果"];
    view=[self newButton:view index:kAEPreviewDemo hint:@"AE模板特效"];
    view=[self newButton:view index:kAEModuleTextDemo hint:@"AE模板--文字旋转"];
    
    view=[self newButton:view index:kGameVideoDemo hint:@"游戏视频录制类"];
    view=[self newButton:view index:kCommonEditDemo hint:@"视频基本编辑>>>"];
    view=[self newButton:view index:kDirectPlay hint:@"直接播放视频"];
    
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.mas_bottom).with.offset(40);
    }];
}
-(BOOL)needCheckBox:(UIView *)sender
{
    return  sender.tag !=kUseDefaultVideo &&
    sender.tag!=kSelectVideo &&
    sender.tag!=kSegmentRecordFullPort &&
    sender.tag!=kSegmentRecordSegmentRecord;
}
-(UIView *)newDefaultButton:(UIView *)topView
{
    UIButton *btn1=[[UIButton alloc] init];
    btn1.tag=kUseDefaultVideo;
    
    [btn1 setTitle:@"使用默认视频" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn1.backgroundColor=[UIColor greenColor];
    
    [btn1 addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchDown];
    [container addSubview:btn1];
    
    UIButton *btn2=[[UIButton alloc] init];
    btn2.tag=kSelectVideo;
    
    [btn2 setTitle:@"文件夹" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn2.backgroundColor=[UIColor yellowColor];
    
    [btn2 addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchDown];
    
    [container addSubview:btn2];
    
    
    labPath=[[UILabel alloc] init];
    labPath.text=@"请选择视频文件.";
    labPath.textColor=[UIColor redColor];
    
    [container addSubview:labPath];
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.04;
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(container.mas_top).with.offset(padding);
            make.left.mas_equalTo(container.mas_left).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(size.width*0.7f-20, 50));  //按钮的高度.
    }];
    
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(container.mas_top).with.offset(padding);
        make.left.mas_equalTo(size.width*0.7f);
        make.size.mas_equalTo(CGSizeMake(size.width*0.25f, 50));  //按钮的高度.
    }];
    
    [labPath mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btn2.mas_bottom).with.offset(5);
        make.left.mas_equalTo(container.mas_left).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(size.width, 30));  //按钮的高度.
    }];
    
    return labPath;
}
-(UIButton *)newButton:(UIView *)topView index:(int)index hint:(NSString *)hint
{
    UIButton *btn=[[UIButton alloc] init];
    btn.tag=index;
    
    [btn setTitle:hint forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor whiteColor];
    
    [btn addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchDown];
    
    [container addSubview:btn];
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.04;
    
    if (topView==container) {
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(container.mas_top).with.offset(padding);
            make.left.mas_equalTo(container.mas_left);
            make.size.mas_equalTo(CGSizeMake(size.width, 50));  //按钮的高度.
        }];
    }else{
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topView.mas_bottom).with.offset(padding);
            make.left.mas_equalTo(container.mas_left);
            make.size.mas_equalTo(CGSizeMake(size.width, 50));
        }];
    }
    return btn;
}
-(void)showSDKInfo
{
    NSString *available=[NSString stringWithFormat:@"当前版本:%@, 到期时间是:%d 年 %d 月之前",[LanSongEditor getVersion],
                         [LanSongEditor getLimitedYear],[LanSongEditor getLimitedMonth]];
    [LanSongUtils showDialog:available];  //显示对话框.
}
-(void)btnDown:(UIView *)sender
{
    sender.backgroundColor=[UIColor grayColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//是否自动旋转,返回YES可以自动旋转
- (BOOL)shouldAutorotate {
    return YES;
}
//返回支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


-(void)testFile
{
    
    NSString *defaultVideo=@"dy_xialu2";
    NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:defaultVideo withExtension:@"mp4"];
    if(sampleURL!=nil){
        labPath.text=[NSString stringWithFormat:@"使用默认视频:%@",defaultVideo];
        [AppDelegate getInstance].currentEditVideo=[LSOFileUtil urlToFileString:sampleURL];
    }else{
        [LanSongUtils showDialog:@"选择默认视频  ERROR!!"];
    }

    
    AEModuleAutoSearchVC *vc=[[AEModuleAutoSearchVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
