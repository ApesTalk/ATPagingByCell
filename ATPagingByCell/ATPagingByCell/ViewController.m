//
//  ViewController.m
//  ATPagingByCell
//
//  Created by ApesTalk on 2020/7/13.
//  Copyright © 2020 https://github.com/ApesTalk All rights reserved.
//

#import "ViewController.h"
#import "AppStoreCompositionalLayoutController.h"

@interface EmojiCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *label;
@end

@implementation EmojiCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.contentView.backgroundColor = [UIColor lightGrayColor];
        self.contentView.layer.cornerRadius = 16;
        self.contentView.layer.masksToBounds = YES;
        
        _label = [[UILabel alloc]init];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:200];
        _label.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_label];
    }
    return self;
}
@end


@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataList = @[@"🐁", @"🐂", @"🐅", @"🐇", @"🐉", @"🐍", @"🐎", @"🐏", @"🐒", @"🐓", @"🐕", @"🐖"];
            
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"CompositionalLayout" forState:UIControlStateNormal];
    btn.frame = CGRectMake(self.view.bounds.size.width-160, 44, 160, 44);
    [btn addTarget:self action:@selector(compositionalLayout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 38, 0, 38);
    layout.minimumLineSpacing = 10;
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 38 * 2, 200);
            
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 230) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[EmojiCell class] forCellWithReuseIdentifier:@"EmojiCell"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
}

//paging by cell | paging with one cell at a time
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width - layout.sectionInset.left - layout.sectionInset.right;
    CGFloat cellPadding = layout.minimumLineSpacing;
    self.currentPage = (scrollView.contentOffset.x - cellWidth / 2) / (cellWidth + cellPadding) + 1;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width - layout.sectionInset.left - layout.sectionInset.right;
    CGFloat cellPadding = layout.minimumLineSpacing;
    NSInteger page = (scrollView.contentOffset.x - cellWidth / 2) / (cellWidth + cellPadding) + 1;

    if (velocity.x > 0) page++;
    if (velocity.x < 0) page--;
    page = MAX(page, 0);
    
    //!!!!:此处注掉：会导致快速滑动会跨越多个cell
    NSInteger prePage = self.currentPage - 1;
    if(prePage > 0 && page < prePage){
        page = prePage;
    } else if (page > self.currentPage + 1){
        page = self.currentPage + 1;
    }
    
    self.currentPage = page;
    
    CGFloat newOffset = page * (cellWidth + cellPadding);
    targetContentOffset->x = newOffset;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EmojiCell" forIndexPath:indexPath];
    cell.label.text = self.dataList[indexPath.row];
    return cell;
}


- (void)compositionalLayout
{
    AppStoreCompositionalLayoutController *vc = [AppStoreCompositionalLayoutController new];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}
@end
