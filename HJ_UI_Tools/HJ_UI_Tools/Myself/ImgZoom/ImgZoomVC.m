//
//  ImgZoomVC.m
//  CeDaYeWu
//
//  Created by ceyu on 2017/4/6.
//  Copyright © 2017年 吴宏佳. All rights reserved.
//

#import "ImgZoomVC.h"
#import "UIImageView+WebCache.h"

@interface ImgZoomVC ()<UICollectionViewDelegateFlowLayout,ImgZoomCellDelegate>

@end

@implementation ImgZoomVC

static NSString * const reuseIdentifier = @"ImgZoomVCCell";
- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsZero;
    self = [super initWithCollectionViewLayout:layout];
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.pagingEnabled = YES;
    
    [self.collectionView registerClass:[ImgZoomCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgURLs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImgZoomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.imgURL = self.imgURLs[indexPath.item];
    return cell;
}
#pragma mark - <UICollectionViewDelegateFlowLayout>
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return collectionView.frame.size;
}

#pragma mark - <UICollectionViewDelegate>

#pragma mark - ImgZoomCellDelegate
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

#pragma mark - 类ImgZoomCell
@interface ImgZoomCell ()<UIScrollViewDelegate>
{
    BOOL _isZoom;
}
/**图*/
@property (strong, nonatomic) UIImageView* imgView;
/***/
@property (weak, nonatomic) UIScrollView* scrollView;

@end
@implementation ImgZoomCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        frame.origin = CGPointZero;
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:frame];
        [self.contentView addSubview:scrollView];
        scrollView.delegate = self;
        //设置最大伸缩比例
        scrollView.maximumZoomScale= 2.0 ;
        //设置最小伸缩比例
        scrollView.minimumZoomScale= 0.5 ;
        self.scrollView = scrollView;
        
        //
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:scrollView.bounds];
        [scrollView addSubview:imageView];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.userInteractionEnabled = YES;
        //
        UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        oneTap.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:oneTap];
        
        UITapGestureRecognizer *twoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        twoTap.numberOfTapsRequired = 2;
        [imageView addGestureRecognizer:twoTap];
        
        //如果不加下面的话，当单指双击时，会先调用单指单击中的处理，再调用单指双击中的处理
        [oneTap requireGestureRecognizerToFail:twoTap];
        
        self.imgView = imageView;
    }
    return self;
}
-(void)setImgURL:(NSString *)imgURL{
    _imgURL = imgURL;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"loading"]];
    [self.scrollView setZoomScale:1.f animated:YES];
    _isZoom = NO;
}
-(void)tap:(UITapGestureRecognizer*)tap{
    _isZoom = !_isZoom;
    
    switch (tap.numberOfTapsRequired) {
        case 1:
            [self.delegate back];
            break;
            
        case 2:
            [self.scrollView setZoomScale:_isZoom?2.f:1.f  animated:YES];
            break;
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    
    //目前contentsize的width是否大于原scrollview的contentsize，如果大于，设置imageview中心x点为contentsize的一半，以固定imageview在该contentsize中心。如果不大于说明图像的宽还没有超出屏幕范围，可继续让中心x点为屏幕中点，此种情况确保图像在屏幕中心。
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    self.imgView.center = CGPointMake(xcenter, ycenter);
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imgView;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:( UIView *)view {
    
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
}

@end
