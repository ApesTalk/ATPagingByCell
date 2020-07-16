//
//  AppStoreCompositionalLayoutController.m
//  ATPagingByCell
//
//  Created by ApesTalk on 2020/7/15.
//  Copyright © 2020 https://github.com/ApesTalk All rights reserved.
//

#import "AppStoreCompositionalLayoutController.h"

@interface AppStoreCompositionalLayoutController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, assign) NSInteger demoType;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation AppStoreCompositionalLayoutController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"Dimiss" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 44, 60, 44);
    [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //一.决定元素大小的 NSCollectionLayoutDimension、NSCollectionLayoutSize
    //1.尺寸相当于父视图的比例
    NSCollectionLayoutDimension *widthDismension = [NSCollectionLayoutDimension fractionalWidthDimension:0.2];
    //2.固定尺寸值
    widthDismension = [NSCollectionLayoutDimension absoluteDimension:100];
    //3.预估值
    widthDismension = [NSCollectionLayoutDimension estimatedDimension:99];
    
    NSCollectionLayoutDimension *heightDismension = [NSCollectionLayoutDimension fractionalWidthDimension:0.2];

    NSCollectionLayoutSize *size = [NSCollectionLayoutSize sizeWithWidthDimension:widthDismension heightDimension:heightDismension];
                           
    
    
    //二.决定Item布局的 NSCollectionLayoutItem
    NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:size];
    
    
    //三.决定Gropu布局的 NSCollectionLayoutGroup(继承于NSCollectionLayoutItem) 水平、垂直、自定义三种形式
    NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:size subitems:@[item]];
    
    //四.决定Section布局的 NSCollectionLayoutSection
    NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
    
    
    
    
//    [self demo0];
//    [self demo1];
    [self demo2];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 12;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return section == 0 ? 5 : 2;
    return 8;
}


/*
 !!!!:numberOfSections和numberOfItems跟NSCollectionLayoutSection、NSCollectionLayoutGroup、NSCollectionLayoutItem的关系
 由于一个UICollectionViewCompositionalLayout只能指定一个NSCollectionLayoutSection，一个NSCollectionLayoutSection只能指定一个NSCollectionLayoutGroup。
 
 对于demo1来说：
 1.如果numberOfSections=1，numberOfItems>3，每3个cell对应一个group布局样式，超过3的继续分group
 2.如果numberOfSections=2，numberOfItems=2, 每2个cell对应一个group布局样式，分为两个group
 
 也就是说numberOfSections对应的每一个section开始布局的时候一定会开始一个group的布局了（即使上一个section对应的rows不是group中样式数量的整数倍，该section的第一个cell也不会接着布局）。每个section中的cell会按group中对应的样式依次布局。
 
 */


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.f green:arc4random()%255/255.f blue:arc4random()%255/255.f alpha:1];
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if(_demoType != 1){
        return nil;
    }
    
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        UICollectionReusableView *h = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"head" forIndexPath:indexPath];
        UILabel *l = [UILabel new];
        l.text = @"section header";
        l.frame = h.bounds;
        [h addSubview:l];
        return h;
    } else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        UICollectionReusableView *f = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"foot" forIndexPath:indexPath];
        UILabel *l = [UILabel new];
        l.text = @"section footer";
        l.frame = f.bounds;
        [f addSubview:l];
        return f;
    } else if([kind isEqualToString:@"Badge"]){
        UICollectionReusableView *b = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"custom" forIndexPath:indexPath];
        b.backgroundColor = [UIColor blackColor];
        b.layer.cornerRadius = 10;
        b.layer.masksToBounds = YES;
        return b;
    }
    return nil;
}




//水平滚动，但cell大小交替变换，且cell居中对齐。比瀑布流UICollectionViewFlowLayout方式确实方便一些。
- (void)demo0
{
    _demoType = 0;
    
    NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:0.5] heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.0]];
    NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
    
    NSCollectionLayoutSize *itemSize1 = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:0.25] heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:0.5]];
    NSCollectionLayoutItem *item1 = [NSCollectionLayoutItem itemWithLayoutSize:itemSize1];
//    item1.contentInsets = NSDirectionalEdgeInsetsMake(20, 20, 20, 20);//内边距 会改变其size
//    item1.edgeSpacing = [NSCollectionLayoutEdgeSpacing spacingForLeading:nil top:[NSCollectionLayoutSpacing flexibleSpacing:10] trailing:nil bottom:nil];//外边距，值可能会被优化 【相对于group底部对齐】
    item1.edgeSpacing = [NSCollectionLayoutEdgeSpacing spacingForLeading:[NSCollectionLayoutSpacing flexibleSpacing:10] top:[NSCollectionLayoutSpacing flexibleSpacing:10] trailing:[NSCollectionLayoutSpacing flexibleSpacing:10] bottom:[NSCollectionLayoutSpacing flexibleSpacing:10]];//【相对于group居中对齐】
    
    //一个group可以指定多个item，指定多个，对应的cell会按items的样式依次布局
    NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0] heightDimension:[NSCollectionLayoutDimension fractionalWidthDimension:0.25]];
    NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitems:@[item, item1]];
    group.interItemSpacing = [NSCollectionLayoutSpacing fixedSpacing:5];
    
    
    
    //一个section只能指定一个group
    NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
    section.contentInsets = NSDirectionalEdgeInsetsFromString(@"{5.0, 5.0, 5.0, 5.0}");
    //Orthogonal正交 在正交轴上怎么滚动？
//    section.orthogonalScrollingBehavior = UICollectionLayoutSectionOrthogonalScrollingBehaviorGroupPaging;
    
    UICollectionViewCompositionalLayoutConfiguration *config = [UICollectionViewCompositionalLayoutConfiguration new];
    config.scrollDirection = UICollectionViewScrollDirectionHorizontal;//水平滚动
    
    
    //layout只能指定一个section
    UICollectionViewCompositionalLayout *layout = [[UICollectionViewCompositionalLayout alloc]initWithSection:section configuration:config];
    
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height-100) collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor lightGrayColor];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
}


//垂直滚动，一个大cell + 两个小cell
- (void)demo1
{
    _demoType = 1;
    
    
    //配置装饰
    NSCollectionLayoutAnchor *badgeAnchor = [NSCollectionLayoutAnchor layoutAnchorWithEdges:NSDirectionalRectEdgeTop|NSDirectionalRectEdgeTrailing fractionalOffset:CGPointMake(0.5, -0.5)];//装饰视图中心点等于cell的右上角顶点
    NSCollectionLayoutSize *badgeSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension absoluteDimension:20] heightDimension:[NSCollectionLayoutDimension absoluteDimension:20]];
    NSCollectionLayoutSupplementaryItem *badge = [NSCollectionLayoutSupplementaryItem supplementaryItemWithLayoutSize:badgeSize elementKind:@"Badge" containerAnchor:badgeAnchor];
    
    
    

    //顶部item
    NSCollectionLayoutSize *topItemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0] heightDimension:[NSCollectionLayoutDimension fractionalWidthDimension:9.0/16.0]];
    NSCollectionLayoutItem *topItem = [NSCollectionLayoutItem itemWithLayoutSize:topItemSize];
    
    //底部item
    NSCollectionLayoutSize *bottomItemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:0.5] heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.0]];
    NSCollectionLayoutItem *bottomItem = [NSCollectionLayoutItem itemWithLayoutSize:bottomItemSize supplementaryItems:@[badge]];
    bottomItem.contentInsets = NSDirectionalEdgeInsetsMake(8, 8, 8, 8);

    //底部group
    NSCollectionLayoutSize *bottomGroupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0] heightDimension:[NSCollectionLayoutDimension fractionalWidthDimension:0.5]];
//    NSCollectionLayoutGroup *bottomGroup = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:bottomGroupSize subitems:@[bottomItem, bottomItem]];//该api放两个相同的item是不起效的
    NSCollectionLayoutGroup *bottomGroup = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:bottomGroupSize subitem:bottomItem count:2];//会在这个分组中放入两个相同的item。并且这里设置了2，即使bottomItemSize width设置比较大，依然会平分
    
    //组合group 🐂🍺 注意这里的尺寸一点要是组合的大小
    NSCollectionLayoutSize *fullGroupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0] heightDimension:[NSCollectionLayoutDimension fractionalWidthDimension:9.0/16.0 + 0.5]];
    NSCollectionLayoutGroup *nestedGroup = [NSCollectionLayoutGroup verticalGroupWithLayoutSize:fullGroupSize subitems:@[topItem, bottomGroup]];//NSCollectionLayoutGroup继承自NSCollectionLayoutItem

    
    
    
    //虽然一个section只能指定一个group，但可以group中可以组合item和其他group
    NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:nestedGroup];
//    section.orthogonalScrollingBehavior = UICollectionLayoutSectionOrthogonalScrollingBehaviorContinuous;
    
    NSCollectionLayoutSize *headerSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0] heightDimension:[NSCollectionLayoutDimension estimatedDimension:44]];
    NSCollectionLayoutBoundarySupplementaryItem *headerItem = [NSCollectionLayoutBoundarySupplementaryItem boundarySupplementaryItemWithLayoutSize:headerSize elementKind:UICollectionElementKindSectionHeader alignment:NSRectAlignmentTop];
//    headerItem.pinToVisibleBounds = YES;
    
    //配置组头组尾
    NSCollectionLayoutSize *footerSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0] heightDimension:[NSCollectionLayoutDimension estimatedDimension:60]];
    NSCollectionLayoutBoundarySupplementaryItem *footerItem = [NSCollectionLayoutBoundarySupplementaryItem boundarySupplementaryItemWithLayoutSize:footerSize elementKind:UICollectionElementKindSectionFooter alignment:NSRectAlignmentBottom];
    
    section.boundarySupplementaryItems = @[headerItem, footerItem];
    
    
    
    UICollectionViewCompositionalLayout *layout = [[UICollectionViewCompositionalLayout alloc]initWithSection:section];

    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height-100) collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor lightGrayColor];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"foot"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:@"Badge" withReuseIdentifier:@"custom"];
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
}


//仿AppStore的游戏和app tab页面布局
- (void)demo2
{
    _demoType = 2;
    NSArray *sectionTitles = @[@"热门App", @"大家都在用", @"今天看什么", @"新鲜App", @"给小朋友", @"热门类别", @"生活微记录", @"合影不受限", @"付费App排行", @"免费App排行", @"快速链接"];

    
    UICollectionViewCompositionalLayoutConfiguration *config = [UICollectionViewCompositionalLayoutConfiguration new];
    config.interSectionSpacing = 30;
    
    
    UICollectionViewCompositionalLayout *layout = [[UICollectionViewCompositionalLayout alloc]initWithSectionProvider:^NSCollectionLayoutSection * _Nullable(NSInteger section, id<NSCollectionLayoutEnvironment> environment) {
        return [self generateSectionForSection:section];
    }];
    layout.configuration = config;
    
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height-100) collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor lightGrayColor];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
//    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
//    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"foot"];
//    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:@"Badge" withReuseIdentifier:@"custom"];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];

}

- (NSCollectionLayoutSection *)generateSectionForSection:(NSInteger)section
{
    NSCollectionLayoutGroup *group;
    UICollectionLayoutSectionOrthogonalScrollingBehavior behavior = UICollectionLayoutSectionOrthogonalScrollingBehaviorContinuous;
    switch (section) {
        case 0:
        {
            //顶部banner item
            behavior = UICollectionLayoutSectionOrthogonalScrollingBehaviorGroupPagingCentered;
            
            CGFloat bannerSize = [UIScreen mainScreen].bounds.size.width - 60;
            NSCollectionLayoutSize *bannerItemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0] heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.0]];
            NSCollectionLayoutItem *bannerItem = [NSCollectionLayoutItem itemWithLayoutSize:bannerItemSize];
            bannerItem.contentInsets = NSDirectionalEdgeInsetsMake(0, 15, 0, 0);

            NSCollectionLayoutSize *bannerGroupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension absoluteDimension:bannerSize] heightDimension:[NSCollectionLayoutDimension absoluteDimension:bannerSize]];
            group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:bannerGroupSize subitem:bannerItem count:1];//水平
            
            break;
        }
        case 1:
        case 2:
        case 4:
        case 7:
        case 9:
        case 10:
        {
            //每列三行的cell样式
            CGFloat oneThirdWidth = [UIScreen mainScreen].bounds.size.width - 60;
            CGFloat oneThirdHeight = 80;
            NSCollectionLayoutSize *oneThirdItemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0] heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.0/3.0]];
            NSCollectionLayoutItem *oneThirdItem = [NSCollectionLayoutItem itemWithLayoutSize:oneThirdItemSize];
            oneThirdItem.contentInsets = NSDirectionalEdgeInsetsMake(0, 15, 0, 0);

            NSCollectionLayoutSize *oneThirdGroupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension absoluteDimension:oneThirdWidth] heightDimension:[NSCollectionLayoutDimension absoluteDimension:oneThirdHeight * 3.0]];
            group = [NSCollectionLayoutGroup verticalGroupWithLayoutSize:oneThirdGroupSize subitem:oneThirdItem count:3];//垂直
            
            break;
        }
        case 3:
        {
            //今天看什么banner
            behavior = UICollectionLayoutSectionOrthogonalScrollingBehaviorGroupPagingCentered;

            CGFloat bannerSize = [UIScreen mainScreen].bounds.size.width - 160;
            NSCollectionLayoutSize *bannerItemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0] heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.0]];
            NSCollectionLayoutItem *bannerItem = [NSCollectionLayoutItem itemWithLayoutSize:bannerItemSize];
            bannerItem.contentInsets = NSDirectionalEdgeInsetsMake(0, 15, 0, 0);

            NSCollectionLayoutSize *bannerGroupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension absoluteDimension:bannerSize] heightDimension:[NSCollectionLayoutDimension absoluteDimension:bannerSize * 9.0 / 16.0]];
            group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:bannerGroupSize subitem:bannerItem count:1];//水平
            
            break;
        }
        case 5:
        {
            //给小朋友
            CGFloat bannerSize = [UIScreen mainScreen].bounds.size.width - 60;
            NSCollectionLayoutSize *bannerItemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0] heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.0]];
            NSCollectionLayoutItem *bannerItem = [NSCollectionLayoutItem itemWithLayoutSize:bannerItemSize];
            bannerItem.contentInsets = NSDirectionalEdgeInsetsMake(0, 15, 0, 0);

            NSCollectionLayoutSize *bannerGroupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension absoluteDimension:bannerSize] heightDimension:[NSCollectionLayoutDimension absoluteDimension:bannerSize * 9.0 / 16.0]];
            group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:bannerGroupSize subitem:bannerItem count:1];//水平
            break;
        }
        case 6:
        {
            //热门类别
            CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width;
            CGFloat cellHeight = 50;
            NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0] heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.0]];
            NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
            item.contentInsets = NSDirectionalEdgeInsetsMake(0, -15, 0, -30);

            NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension absoluteDimension:cellWidth] heightDimension:[NSCollectionLayoutDimension absoluteDimension:cellHeight * 8]];
            group = [NSCollectionLayoutGroup verticalGroupWithLayoutSize:groupSize subitem:item count:8];//垂直
            break;
        }
        case 8:
        {
            //每列两行的cell样式
            CGFloat oneSecondWidth = [UIScreen mainScreen].bounds.size.width - 60;
            CGFloat oneSecondHeight = 120;
            NSCollectionLayoutSize *oneSecondItemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0] heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.0/2.0]];
            NSCollectionLayoutItem *oneSecondItem = [NSCollectionLayoutItem itemWithLayoutSize:oneSecondItemSize];
            oneSecondItem.contentInsets = NSDirectionalEdgeInsetsMake(0, 15, 0, 0);

            NSCollectionLayoutSize *oneSecondGroupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension absoluteDimension:oneSecondWidth] heightDimension:[NSCollectionLayoutDimension absoluteDimension:oneSecondHeight * 2.0]];
            group = [NSCollectionLayoutGroup verticalGroupWithLayoutSize:oneSecondGroupSize subitem:oneSecondItem count:2];//垂直
            break;
        }
        case 11:
        {
            //快速链接
            CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width;
            CGFloat cellHeight = 50;
            NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0] heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.0]];
            NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
            item.contentInsets = NSDirectionalEdgeInsetsMake(0, -15, 0, -30);

            NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension absoluteDimension:cellWidth] heightDimension:[NSCollectionLayoutDimension absoluteDimension:cellHeight * 8]];
            group = [NSCollectionLayoutGroup verticalGroupWithLayoutSize:groupSize subitem:item count:8];//垂直
            break;
            break;
        }
    }
    
    NSCollectionLayoutSection *layoutSection = [NSCollectionLayoutSection sectionWithGroup:group];
    layoutSection.orthogonalScrollingBehavior = behavior;
    layoutSection.contentInsets = NSDirectionalEdgeInsetsMake(0, 15, 0, 30);
    return layoutSection;
}

@end
