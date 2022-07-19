// ASCollectionView. Created by Apptek Studios 2019

import Foundation
import SwiftUI
import UIKit

@available(iOS 13.0, *)
public protocol Decoration: View
{
	init()
}

@available(iOS 13.0, *)
class ASCollectionViewDecoration<Content: Decoration>: ASCollectionViewSupplementaryView
{
	override init(frame: CGRect)
	{
        if(frame.width == .infinity || frame.height == .infinity){
            super.init(frame: CGRect(origin: frame.origin, size: .zero))
        }else{
            super.init(frame: frame)
        }		
		setContent(supplementaryID: ASSupplementaryCellID(sectionIDHash: 0, supplementaryKind: "Decoration"), content: Content())
	}
}
