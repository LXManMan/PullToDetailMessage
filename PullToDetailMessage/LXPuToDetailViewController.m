
//
//  LXPuToDetailViewController.m
//  PullToDetailMessage
//
//  Created by chuanglong02 on 16/10/27.
//  Copyright © 2016年 漫漫. All rights reserved.
//

#import "LXPuToDetailViewController.h"
#define Font(f)  [UIFont systemFontOfSize:f]
static NSString *cellID = @"cell";
@interface LXPuToDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)UILabel *headLab;
@end

@implementation LXPuToDetailViewController

{
    CGFloat _maxContentOffSet_Y;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    _maxContentOffSet_Y  = 100;
    
    [self.view addSubview:self.tableView];
    
    // second view
    [self.view addSubview:self.webView];
    
    self.webView.hidden = YES;
    UILabel *hv = self.headLab;
    // headLab
    [self.webView addSubview:hv];
    [self.headLab bringSubviewToFront:self.view];
    
    // 开始监听_webView.scrollView的偏移量
    [_webView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if(object == _webView.scrollView && [keyPath isEqualToString:@"contentOffset"])
    {
//        NSLog(@"----old:%@----new:%@",change[@"old"],change[@"new"]);
        [self headLabAnimation:[change[@"new"] CGPointValue].y];
    }else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}
- (void)headLabAnimation:(CGFloat)offsetY
{
    _headLab.alpha = -offsetY/60;
    _headLab.center = CGPointMake(Device_Width/2, -offsetY/2.f);
    // 图标翻转，表示已超过临界值，松手就会返回上页
    if(-offsetY>_maxContentOffSet_Y){
        _headLab.textColor = [UIColor redColor];
        _headLab.text = @"释放，返回详情";
    }else{
        _headLab.textColor = [UIColor grayColor];
        _headLab.text = @"上拉，返回详情";
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if([scrollView isKindOfClass:[UITableView class]]) // tableView界面上的滚动
    {
        if (offsetY <0) {
            return;
        }
        // 能触发翻页的理想值:tableView整体的高度减去屏幕本省的高度
        CGFloat valueNum = _tableView.contentSize.height -Device_Height-64;
        if ((offsetY - valueNum) > _maxContentOffSet_Y)
        {
            [self goToDetailAnimation]; // 进入图文详情的动画
        }
    }
    
    else // webView页面上的滚动
    {
        NSLog(@"-----webView-------");
        if(offsetY<0 && -offsetY>_maxContentOffSet_Y)
        {
            [self backToFirstPageAnimation]; // 返回基本详情界面的动画
        }
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 25;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = @"你嗲我啊";
    return cell;
}
// 进入详情的动画
- (void)goToDetailAnimation
{
    self.webView.hidden = NO;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        _webView.frame = CGRectMake(0, 0, Device_Width, Device_Height-64);
        _tableView.frame = CGRectMake(0, -Device_Height, Device_Width, Device_Height-64);
    } completion:^(BOOL finished) {
        
    }];
}


// 返回第一个界面的动画
- (void)backToFirstPageAnimation
{
    self.webView.hidden = YES;

    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        _tableView.frame = CGRectMake(0, 0, Device_Width, Device_Height-64);
        _webView.frame = CGRectMake(0, -Device_Height, Device_Width, Device_Height-64);
        
    } completion:^(BOOL finished) {
        
    }];
}
- (UILabel *)headLab
{
    if(!_headLab){
        _headLab = [[UILabel alloc] init];
        _headLab.text = @"上拉，返回详情";
        _headLab.textAlignment = NSTextAlignmentCenter;
        _headLab.font = Font(13);
        
    }
    
    _headLab.frame = CGRectMake(0, 64, Device_Width, 40.f);
    _headLab.alpha = 0.f;
    _headLab.textColor = [UIColor grayColor];
    
    
    return _headLab;
}
- (UITableView *)tableView
{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, Device_Height-64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 40.f;
        UILabel *tabFootLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Device_Width, 60)];
        tabFootLab.text = @"继续拖动，查看图文详情";
        tabFootLab.font = Font(13);
        tabFootLab.textAlignment = NSTextAlignmentCenter;
//                tabFootLab.backgroundColor = [UIColor orangeColor];
        _tableView.tableFooterView = tabFootLab;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    }
    
    return _tableView;
}
- (UIWebView *)webView
{
    if(!_webView){
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, _tableView.contentSize.height, Device_Width, Device_Height-64)];
        _webView.delegate = self;
        _webView.scrollView.delegate = self;
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]]];
    }
    
    return _webView;
}
@end
