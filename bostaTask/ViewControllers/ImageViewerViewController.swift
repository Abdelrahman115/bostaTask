//
//  ImageViewerViewController.swift
//  bostaTask
//
//  Created by Abdelrahman on 08/09/2023.
//

import UIKit
import SDWebImage

class ImageViewerViewController: UIViewController, UIScrollViewDelegate {
    // MARK: - View Properties
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let shareButton = UIButton()
    private var imageURL:String = ""
    
    
    // MARK: - Initializer
    init(imageURL:String){
        self.imageURL = imageURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // set up scroll view
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        view.addSubview(scrollView)
        
        // Set up the image view
        
        imageView.center = scrollView.center
        imageView.contentMode = .scaleAspectFit
        imageView.sd_setImage(with: URL(string: imageURL),completed: nil)
        scrollView.addSubview(imageView)
        
        
        // share button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTabShare))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        imageView.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: 600)
    }

    // MARK: - UIScrollViewDelegate

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    // MARK: - Share Image Functionality

    @objc func didTabShare() {
            let imageToShare = self.imageURL
        let activityViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
}

