//
//  FilterCollectionViewCell.h
//  LanSongEditor_all
//
//  Created by sno on 2018/6/6.
//  Copyright © 2018年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const kMyCollectionViewCellID;

@interface FilterCollectionViewCell : UICollectionViewCell


- (void)pushCellWithImage:(UIImage *)img name:(NSString *)name;

@end
