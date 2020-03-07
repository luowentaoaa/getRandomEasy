//
//  ViewController.m
//  缓存图片
//
//  Created by luowentao on 2020/3/7.
//  Copyright © 2020 luowentao. All rights reserved.
//

#import "ViewController.h"
#import "LLInfo.h"
#import "NSString+Sandbox.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *appInfos;

@property (nonatomic, strong) NSOperationQueue *queue;

@property (nonatomic, strong) NSMutableDictionary *imageCache;

@property (nonatomic, strong) NSMutableDictionary *downloadCache;


// 下载操作的缓存池

@end

@implementation ViewController

- (NSMutableDictionary *)downloadCache{
    if (!_downloadCache) {
        _downloadCache = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return _downloadCache;
}

- (NSDictionary *)imageCache{
    if (!_imageCache) {
        _imageCache = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return _imageCache;
}

- (NSArray *)appInfos{
    if(_appInfos == nil){
        _appInfos = [LLInfo Info];
    }
    return _appInfos;
}

-(NSOperationQueue *)queue{
    if (_queue == nil) {
        _queue = [NSOperationQueue new];
    }
    return _queue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",NSHomeDirectory());
    // Do any additional setup after loading the view.
    NSLog(@"%d",self.appInfos.count);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.appInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"appinfo";
    NSString *str = [NSString stringWithFormat:@"%zd",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
    }
    LLInfo *info = self.appInfos[indexPath.row];
    cell.textLabel.text = info.name;
    cell.detailTextLabel.text = info.phone;
//    if (info.image) {
//        NSLog(@"缓存");
//        cell.imageView.image = info.image;
//        return cell;
//    }
    if (self.imageCache[str]) {
        cell.imageView.image = self.imageCache [str];
        NSLog(@"缓存");
        return cell;
    }
    
    if (self.downloadCache[str]) {
        cell.imageView.image = self.imageCache[str];
        return cell;
    }
    
    // 设置占位图片
    cell.imageView.image = [UIImage imageNamed:@"ini.jpg"];
    
    NSData *data = [NSData dataWithContentsOfFile:[str appendCache]];
    if (data) {
        UIImage *img = [UIImage imageWithData:data];
        self.imageCache[str] = img;
        cell.imageView.image = img;
        NSLog(@"从沙盒加载");
        return cell;
    }
    
    [self downloadImage:indexPath];
    return cell;
}

- (void) downloadImage :(NSIndexPath *)indexPath{
        NSString *str = [NSString stringWithFormat:@"%zd",indexPath.row];
    
        LLInfo *info = self.appInfos[indexPath.row];
        NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
           NSURL *url = [NSURL URLWithString:info.icon];
           NSData *data = [NSData dataWithContentsOfURL:url];
           UIImage *img = [UIImage imageWithData:data];
          
            
           //把图片保存到沙盒中
            if (img) {
                [data writeToFile:[str appendCache] atomically:YES];
            }
         // info.image = img;
           
    
         //  NSLog(@"%@ %@",str,img);
          
          [[NSOperationQueue mainQueue]addOperationWithBlock:^{
              if (img) {
                  [self.imageCache setValue:img forKey:str];
                  [self.downloadCache removeObjectForKey:str];
                  [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
              }
          }];
       }];
       [self.queue addOperation:op];
       [self.downloadCache setValue:op forKey:str];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"队列的操作数 :%zd",self.queue.operationCount);
}

//内存警告
- (void)didReceiveMemoryWarning{
    [self.imageCache removeAllObjects];
   // [self.downloadCache removeAllObjects];
}
@end
