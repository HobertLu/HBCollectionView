//
//  HBCollectionViewLayout.swift
//  HBCollectionView
//
//  Created by hobert.lu@dji.com on 15/4/23.
//  Copyright (c) 2015年 hobert.lu@dji.com. All rights reserved.
//

import UIKit
import Foundation

class HBCollectionViewLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        self.itemSize = CGSizeMake(200.0, 200.0)
        self.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.minimumLineSpacing = 50.0
        self.sectionInset = UIEdgeInsetsMake(200, 0.0, 200, 0.0)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
//    -(CGSize)collectionViewContentSize
//    
//    返回collectionView的内容的尺寸
//    -(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
//    
//    返回rect中的所有的元素的布局属性
//    返回的是包含UICollectionViewLayoutAttributes的NSArray
//    UICollectionViewLayoutAttributes可以是cell，追加视图或装饰视图的信息，通过不同的UICollectionViewLayoutAttributes初始化方法可以得到不同类型的UICollectionViewLayoutAttributes：
//    
//    layoutAttributesForCellWithIndexPath:
//    layoutAttributesForSupplementaryViewOfKind:withIndexPath:
//    layoutAttributesForDecorationViewOfKind:withIndexPath:
//    -(UICollectionViewLayoutAttributes _)layoutAttributesForItemAtIndexPath:(NSIndexPath _)indexPath
//    
//    返回对应于indexPath的位置的cell的布局属性
//    -(UICollectionViewLayoutAttributes _)layoutAttributesForSupplementaryViewOfKind:(NSString _)kind atIndexPath:(NSIndexPath *)indexPath
//    
//    返回对应于indexPath的位置的追加视图的布局属性，如果没有追加视图可不重载
//    -(UICollectionViewLayoutAttributes * )layoutAttributesForDecorationViewOfKind:(NSString_)decorationViewKind atIndexPath:(NSIndexPath _)indexPath
//    
//    返回对应于indexPath的位置的装饰视图的布局属性，如果没有装饰视图可不重载
//    -(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//    
//    当边界发生改变时，是否应该刷新布局。如果YES则在边界变化（一般是scroll到其他地方）时，将重新计算需要的布局信息。

//    - (CGPoint)targetContentOffsetForProposedContentOffset: (CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
//    {
//    //proposedContentOffset是没有对齐到网格时本来应该停下的位置
//    CGFloat offsetAdjustment = MAXFLOAT;
//    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
//    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
//    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
//    
//    //对当前屏幕中的UICollectionViewLayoutAttributes逐个与屏幕中心进行比较，找出最接近中心的一个
//    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
//    CGFloat itemHorizontalCenter = layoutAttributes.center.x;
//    if (ABS(itemHorizontalCenter - horizontalCenter) &lt; ABS(offsetAdjustment)) {
//    offsetAdjustment = itemHorizontalCenter - horizontalCenter;
//    }
//    }
//    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
//    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment = MAXFLOAT
        var horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView!.bounds) / 2)
        var targetRect = CGRectMake(proposedContentOffset.x, 0, self.collectionView!.bounds.width, self.collectionView!.bounds.height)
        let array = super.layoutAttributesForElementsInRect(targetRect)
        
        for layout in array! {
            var itemHorizontalCenter = layout.center.x
            if abs(itemHorizontalCenter - horizontalCenter) < abs(horizontalCenter) {
                offsetAdjustment = Float(itemHorizontalCenter) - Float( horizontalCenter)
            }
        }
        return CGPointMake(CGFloat(Float(proposedContentOffset.x ) + Float(offsetAdjustment)), proposedContentOffset.y)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var array: Array = super.layoutAttributesForElementsInRect(rect)!
        var visibleRect: CGRect = CGRect()
        visibleRect.origin = (self.collectionView?.contentOffset)!
        visibleRect.size = (self.collectionView?.bounds.size)!
        let ACTIVE_DISTANCE: CGFloat = 300.0
        let ZOOM_FACTOR: CGFloat = 0.5
        
        for var i = 0; i < array.count; i++ {
            var attributes = array[i] as! UICollectionViewLayoutAttributes
            if CGRectIntersectsRect(attributes.frame, rect) {
                var distance: CGFloat = CGRectGetMidX(visibleRect) - attributes.center.x
//                println("attributes.center.x\(attributes.center.x) + CGRectGetMidX(visibleRect) \(CGRectGetMidX(visibleRect))")
//                println("abs(distance)\(abs(distance)) + ACTIVE_DISTANCE\(ACTIVE_DISTANCE)")
                if (abs(distance) < ACTIVE_DISTANCE) {
                    var zoom: CGFloat = 1 + ZOOM_FACTOR*(1 - abs(distance / ACTIVE_DISTANCE))
                    attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0)
                    attributes.zIndex = 1
                }
            }
        }
        
        return array
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    
}
