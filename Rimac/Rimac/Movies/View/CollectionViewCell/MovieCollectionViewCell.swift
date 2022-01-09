//
//  MovieCollectionViewCell.swift
//  Rimac
//
//  Created by Joseph Estanislao Calla Moreyra on 1/9/22.
//

import UIKit
import Alamofire

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var movie:Movie?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(movie:Movie) {
        if let url = URL(string: movie.backdropPath) {
            downloadImage(url: url) { image in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
        titleLabel.text = movie.title
        self.movie = movie
    }
    
    func downloadImage(url:URL, completion: @escaping (UIImage?) -> Void) {
        MyNetworking.shared.downloadImage(url: url) {[weak self] image in
            guard let image = image else {
                completion(nil)
                return
            }
            completion(image)
        }
    }
}
