//
//  AppStoreCompositionalLayoutController.h
//  ATPagingByCell
//
//  Created by ApesTalk on 2020/7/15.
//  Copyright © 2020 https://github.com/ApesTalk All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppStoreCompositionalLayoutController : UIViewController

@end

/*
 
 0.如何组合样式？item和group嵌套
 1.横向滚动的section 如何一上来滚动到指定位置
 2.怎么检测到滚动到指定cell进行播放的切换  visibleItemsInvalidationHandler回调里处理
 
 https://developer.apple.com/videos/play/wwdc2019/215/
 
 https://developer.apple.com/documentation/uikit/uicollectionviewcompositionallayout
 https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views
 https://juejin.im/post/5ee5e90ee51d4578a6798b9e
 https://juejin.im/post/5d00c430f265da1b8466de01
 */
