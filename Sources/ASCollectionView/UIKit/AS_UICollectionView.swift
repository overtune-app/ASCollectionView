// ASCollectionView. Created by Apptek Studios 2019

import Foundation
import SwiftUI

@available(iOS 13.0, *)
public class AS_CollectionViewController: UIViewController
{
	weak var coordinator: ASCollectionViewCoordinator?
	{
		didSet
		{
			collectionView.coordinator = coordinator
		}
	}

	var collectionViewLayout: UICollectionViewLayout
	lazy var collectionView: AS_UICollectionView = {
		let cv = AS_UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
		cv.coordinator = coordinator
		return cv
	}()

	public init(collectionViewLayout layout: UICollectionViewLayout)
	{
		collectionViewLayout = layout
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}

	override public func loadView()
	{
		view = collectionView
	}

	override public func viewDidLoad()
	{
		super.viewDidLoad()
		view.backgroundColor = .clear
	}

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print("NAVIGATION CONTROLLER: \(navigationController)")
//        print("NAVIGATION CONTROLLER: \(navigationController?.isNavigationBarHidden)")
        
//        navigationController?.navigationBar.isOpaque = true
//        navigationController?.isNavigationBarHidden = true
//        navigationController?.navigationBar.isHidden = true
//        navigationController?.navigationBar.alpha = 0.0
        
//        navigationController?.navigationBar.addObserver(self, forKeyPath: "alpha", options: .new, context: nil)
    }
    
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let navigationBar = object as? UINavigationBar {
            navigationBar.isHidden = true
        }else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    

	override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
	{
		// Get current central cell
		self.coordinator?.prepareForOrientationChange()


		coordinator.animate(alongsideTransition: { _ in
			self.view.setNeedsLayout()
			self.view.layoutIfNeeded()
			if
				let desiredOffset = self.coordinator?.getContentOffsetForOrientationChange(),
				self.collectionView.contentOffset != desiredOffset
			{
				self.collectionView.contentOffset = desiredOffset
			}
		})
		{ _ in
			// Completion
			self.coordinator?.completedOrientationChange()
		}
		
		super.viewWillTransition(to: size, with: coordinator)
	}

	override public func viewSafeAreaInsetsDidChange()
	{
		super.viewSafeAreaInsetsDidChange()
		// The following is a workaround to fix the interface rotation animation under SwiftUI
		collectionViewLayout.invalidateLayout()
	}

	override public func viewDidLayoutSubviews()
	{
		super.viewDidLayoutSubviews()
		coordinator?.didUpdateContentSize(collectionView.contentSize)
	}
}

@available(iOS 13.0, *)
class AS_UICollectionView: UICollectionView
{
	weak var coordinator: ASCollectionViewCoordinator?
	override func didMoveToWindow()
	{
		if window != nil
		{
			coordinator?.onMoveToParent()
		}
		else
		{
			coordinator?.onMoveFromParent()
		}
	}
}
