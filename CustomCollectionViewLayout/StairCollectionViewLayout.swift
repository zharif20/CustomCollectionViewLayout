//
//  StairCollectionViewLayout.swift
//  CustomCollectionViewLayout
//
//  Created by Local on 24/09/2018.
//

import Foundation
import UIKit


fileprivate let kReducedHeightColumnIndex = 1
fileprivate let kItemHeightAspect: CGFloat = 1.5

class StairCollectionViewLayout: CustomLayout {
    
    fileprivate var itemSize: CGSize!
    fileprivate var columnXoffset: [CGFloat]!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.totalColumns = 2
    }
    
    fileprivate func isLastItemSingleInRow(_ indexPath: IndexPath) -> Bool {
        return indexPath.item == (totalItemsInSection - 1) && indexPath.item % totalColumns == 0
    }
    
    
    // Calculate initial item's size depend on provided content size and number of columns
    override func calculateItemSize() {
        
        guard let collectionView = collectionView else { return }
        let sideContentInset = self.contentInsets.left - self.contentInsets.right
        
        let contentWidthWithoutIndents = collectionView.bounds.width - sideContentInset
        let itemWidth = (contentWidthWithoutIndents - (CGFloat(self.totalColumns) - 1) * self.interimSpacing) / CGFloat(self.totalColumns)
        let itemHeight = itemWidth * kItemHeightAspect
        
        self.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        // calculate offset by X for each column
        self.columnXoffset = []
        
        for columnIndex in 0...(self.totalColumns - 1) {
            self.columnXoffset.append(CGFloat(columnIndex) * (self.itemSize.width + self.interimSpacing))
        }
        
    }
    
    // Last single item in row logic. If last row is single, move it
    override func columnIndexForItemAt(indexPath: IndexPath) -> Int {
        let  columnIndex = indexPath.item % self.totalColumns
        return self.isLastItemSingleInRow(indexPath) ? kReducedHeightColumnIndex : columnIndex
    }
    
   
    override func calculateItemFrame(indexPath: IndexPath, columnIndex: Int, columnYoffset: CGFloat) -> CGRect {
        let rowIndex = indexPath.item / self.totalColumns
        let halfItemHeight = (self.itemSize.height - self.interimSpacing) / 2 //half item size
        
        var itemHeight = self.itemSize.height
        
        // first row and sencond column || last row and lat item
        if (rowIndex == 0 && columnIndex == kReducedHeightColumnIndex) || self.isLastItemSingleInRow(indexPath) {
            itemHeight = halfItemHeight
        }
        
        return CGRect(x: self.columnXoffset[columnIndex], y: columnYoffset, width: self.itemSize.width, height: itemHeight)
        
        
        
    }
    
    
}
