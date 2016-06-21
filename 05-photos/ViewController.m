//
//  ViewController.m
//  05-photos
//
//  Created by DC016 on 16/6/13.
//  Copyright © 2016年 ld. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *collectView;
@property(nonatomic,strong)NSMutableArray *images;
@end

@implementation ViewController
-(NSMutableArray *)images{
    if (!_images) {
        _images=[NSMutableArray array];
    }
    return _images;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"今天天气真好，外面才36°而已......");
    //-----获取相册-----
    //设置搜索规则
    PHFetchOptions *option=[[PHFetchOptions alloc]init];
    //获取所有图片：数组
    PHFetchResult *result=[PHAsset fetchAssetsWithOptions:option];
    //图片管理类：主要工作转成UIIage
    PHImageManager *imageManger=[PHImageManager defaultManager];
    //获取图片时的设置
    PHImageRequestOptions *imageRequestOption=[[PHImageRequestOptions alloc]init];
//    //改成同步，解决代码块中的异步线程问题
//    imageRequestOption.synchronous=YES;
    //从资源中获取图片
    //把PHAsset转化成UIImage
    for (PHAsset *asset in result) {
        [imageManger requestImageForAsset:asset targetSize:CGSizeMake(50, 50) contentMode:PHImageContentModeDefault options:imageRequestOption resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.images.count inSection:0];
            //可能会调用多次，取决于需要看多大的图片
             [self.images addObject:result];
            //因数组中插入一张图片才能进行局部刷新
            [self.collectView insertItemsAtIndexPaths:@[indexPath]];
            
        }];
    }
//    //刷新collectView
//    //缺点：若是图片太多的话，同步会影响效率
//     [self.collectView reloadData];
}
#pragma mark  设置显示cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}

#pragma mark 绘制cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //@"cell"故事版里有设置cell的identifier
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:cell.bounds];
    imageView.image=self.images[indexPath.row];
    [cell addSubview:imageView];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
