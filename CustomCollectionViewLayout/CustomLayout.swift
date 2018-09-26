//
//  CustomLayout.swift
//  CustomCollectionViewLayout
//
//  Created by Local on 23/09/2018.
//

import UIKit

class CustomLayout: UICollectionViewLayout {
    
    // MARK: Properties
    fileprivate var cacheLayoutMap = [IndexPath: UICollectionViewLayoutAttributes]() //cache the attribute of the item
    fileprivate var columnsYoffset: [CGFloat]!
    fileprivate var contentSize: CGSize! //total content
    
    fileprivate(set) var totalItemsInSection = 0
    
    var totalColumns = 0
    var interimSpacing: CGFloat = 8
    
    var contentInsets: UIEdgeInsets { return collectionView!.contentInset }
    
    
    // MARK: Funtions
    
    override func prepare() {
        self.cacheLayoutMap.removeAll() //remove previous
        self.columnsYoffset = Array(repeating: 0, count: self.totalColumns)
        
        guard let collectionView = collectionView else { return }
        self.totalItemsInSection = collectionView.numberOfItems(inSection: 0)  //get total items
        
        if self.totalItemsInSection > 0 && self.totalColumns > 0 {
            
            self.calculateItemSize()
            
            var itemIndex = 0
            var contentSizeHeight: CGFloat = 0
            
            let sideContentInsets: CGFloat = self.contentInsets.left + self.contentInsets.right
            
            while itemIndex < self.totalItemsInSection{
                
                let indexPath = IndexPath(item: itemIndex, section: 0)
                let columnIndex = self.columnIndexForItemAt(indexPath: indexPath)
                
                let attributeRect = calculateItemFrame(indexPath: indexPath, columnIndex: columnIndex, columnYoffset: self.columnsYoffset[columnIndex])
                let targetLayoutAttributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
                targetLayoutAttributes.frame = attributeRect
                
                contentSizeHeight = max(attributeRect.maxY, contentSizeHeight)
                self.columnsYoffset[columnIndex] = attributeRect.maxY + self.interimSpacing
                self.cacheLayoutMap[indexPath] = targetLayoutAttributes
                
                itemIndex += 1
            }
            self.contentSize = CGSize(width: collectionView.bounds.width - sideContentInsets, height: contentSizeHeight)
        }
        
    }
    
    override var collectionViewContentSize: CGSize { return self.contentSize }
    
    //check if the frame intersect with rect, provided by collectionview
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributesArray = [UICollectionViewLayoutAttributes]()
        for (_, layoutAttributes) in cacheLayoutMap {
            if layoutAttributes.frame.intersects(rect){
                layoutAttributesArray.append(layoutAttributes)
            }
        }
        return layoutAttributesArray
    }
    
    // MARK: Abstract
    
    // Distribute items in each columns
    func columnIndexForItemAt(indexPath: IndexPath) -> Int {
        return indexPath.item % self.totalColumns
    }
    
    // Calculate item's frame for each item
    // indexpath - target item, columnIndex - item's column index, columnYoffset - layout the y position
    func calculateItemFrame(indexPath: IndexPath, columnIndex: Int, columnYoffset: CGFloat) -> CGRect {
        return CGRect.zero
    }
    
    // Recalculate the layout, calculate before calculateitemfram is called
    func calculateItemSize() {}
    
    
    
    
    
    
    

}
