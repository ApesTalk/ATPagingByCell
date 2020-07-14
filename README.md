# ATPagingByCell

A example of perfectly paging by smaller cell (only one cell at a time) not by screen, which like AppStore's banner and Alipay's banner. 
一个使用UICollectionView实现非全屏cell的paging效果，就像AppStore游戏tab顶部banner和支付宝财富tab的财富直通车banner一样的效果（主要是非全屏cell的情况下实现不管是慢速拖拽还是快速拖拽都每次只轮播一个cell）。

借助UICollectionView的pagingenabled属性，我们能快速做出漂亮的滑动翻页paging效果，可以满足我们引导页、图片预览、banner等等轮播需求。但当我们的cell宽度不是占满整个UICollectionView的时候，比如我们经常遇到一屏要展示三个cell的效果，而且还要实现一次滑动一个cell的效果。这时候，我们不得不实现``- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset``方法或者自定义UICollectionViewFlowLayout实现``- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity``通过矫正其偏移量来将距离UICollectionView中心点最近的cell居中显示。

但是，很显然，单纯这样处理一下，在慢慢拖拽滑动的情况下不会有问题，在快速滑动时会跨cell，也就是一个假的paging效果，如下图所示：

![伪paging by cell](https://github.com/ApesTalk/ATPagingByCell/blob/master/emoji0.gif)


如果我们仔细看AppStore的游戏tab顶部banner或者支付宝财富tab的财富直通车banner的paging效果，会发现它们才是真正的paging效果，不管你怎么快速滑动，它每次就是只滑动一个cell，非常的完美。那他们是怎么实现的，为毛我们处理不了这种细节问题？？？再看看我们目前遇到的问题，只要我们限制不让其每次滑动跨cell就行了，不多解释了，关键代码如下：


```
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
        page = self.currentPage - 1;
    } else if (page > self.currentPage + 1){
        page = self.currentPage + 1;
    }
    
    self.currentPage = page;
    
    CGFloat newOffset = page * (cellWidth + cellPadding);
    targetContentOffset->x = newOffset;
}
```

最终效果如下：

![like AppStore and Alipay](https://github.com/ApesTalk/ATPagingByCell/blob/master/emoji1.gif)




