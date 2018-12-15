//
//  ViewController.m
//  TableViewCellOptimization
//
//  Created by 梁宇航 on 2018/12/14.
//  Copyright © 2018年 梁宇航. All rights reserved.
//

#import "ViewController.h"
#import "DemoService.h"
#import "ImageDownload.h"
#import "DemoModel.h"
#import <YYWebImage.h>
#import <YYModel.h>
#import "NextViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy)NSArray *datas;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableDictionary *imageLoadDic;

@end

@implementation ViewController

#define ScreenH  [[UIScreen mainScreen] bounds].size.height
#define ScreenW  [[UIScreen mainScreen] bounds].size.width

- (NSMutableDictionary *)imageLoadDic{
    if (!_imageLoadDic) {
        _imageLoadDic = @{}.mutableCopy;
    }
    return _imageLoadDic;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.datas = @[];
    
    [self baseSetting];
    
    [self setupUI];
    
    [self loadDatas];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
  
    NSArray *loadImageManagers = [self.imageLoadDic allValues];
    //当前图片下载操作全部取消
    [loadImageManagers makeObjectsPerformSelector:@selector(cancelLoadImage)];
}

- (void)baseSetting{

    self.title = @"DemoTitle";
}

#pragma mark - setupUI
- (void)setupUI{
 
    CGFloat topMargin = 64;

    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, topMargin, ScreenW, ScreenH - topMargin)];
    
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:tableView];

    self.tableView = tableView;
}

#pragma mark - loadDatas
- (void)loadDatas{
    
    [DemoService fetchDataSuccess:^(NSArray *array) {
   
        self.datas = array;
        [self.tableView reloadData];
    }];
}

#pragma mark - <UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    DemoModel *model = self.datas[indexPath.row];
    cell.textLabel.text = model.text;
   
    
    if (model.iconImage) {
        cell.imageView.image = model.iconImage;
    }else{
        cell.imageView.image = [UIImage imageNamed:@"placeholder"];

        /**
         runloop - 滚动时候 - trackingMode，
         - 默认情况 - defaultRunLoopMode
         ==> 滚动的时候，进入`trackingMode`，defaultMode下的任务会暂停
         停止滚动的时候 - 进入`defaultMode` - 继续执行`trackingMode`下的任务 - 例如这里的loadImage
         */
//        [self performSelector:@selector(p_loadImgeWithIndexPath:)
//                   withObject:indexPath afterDelay:0.0
//                      inModes:@[NSDefaultRunLoopMode]];

        //拖动的时候不显示
        if (!tableView.dragging && !tableView.decelerating) {
            //下载图片数据 - 并缓存

            [self p_loadImgeWithIndexPath:indexPath];
        }
    }
    return cell;
}


- (void)p_loadImgeWithIndexPath:(NSIndexPath *)indexPath{
    
    DemoModel *model = self.datas[indexPath.row];
    
    
    //保存当前正在下载的操作
    ImageDownload *manager = self.imageLoadDic[indexPath];
    if (!manager) {
        
        manager = [ImageDownload new];
        //开始加载-保存到当前下载操作字典中
        [self.imageLoadDic setObject:manager forKey:indexPath];
    }
    
    [manager loadImageWithModel:model success:^{
        //主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.imageView.image = model.iconImage;
        });
        
        //加载成功-从保存的当前下载操作字典中移除
        [self.imageLoadDic removeObjectForKey:indexPath];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.navigationController pushViewController:[NextViewController new] animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark - <UIScrollViewDelegate>

//手一直在拖拽控件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    [self p_loadImage];
}

- (void)p_loadImage{

    //拿到界面内-所有的cell的indexpath
    NSArray *visableCellIndexPaths = self.tableView.indexPathsForVisibleRows;

    for (NSIndexPath *indexPath in visableCellIndexPaths) {

        DemoModel *model = self.datas[indexPath.row];

        if (model.iconImage) {
            continue;
        }

        [self p_loadImgeWithIndexPath:indexPath];
    }
}

//手放开了-使用惯性-产生的动画效果
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    if(!decelerate){
        //直接停止-无动画
        [self p_loadImage];
    }else{
        //有惯性的-会走`scrollViewDidEndDecelerating`方法，这里不用设置
    }
}

@end
