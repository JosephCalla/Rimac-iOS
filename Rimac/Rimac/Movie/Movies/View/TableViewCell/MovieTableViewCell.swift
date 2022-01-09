//
//  MovieTableViewCell.swift
//  Rimac
//
//  Created by Joseph Estanislao Calla Moreyra on 1/9/22.
//

import UIKit

protocol MovieTableCellDelegate {
    func isSelected(movie:Movie)
}

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    var movies:[Movie] = []
    var delegate:MovieTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "MovieCollectionViewCell",
                                           bundle: nil),
                                     forCellWithReuseIdentifier: "MovieCollectionViewCell")
        self.collectionView.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(movies: [Movie]) {
        self.movies = movies
        self.collectionView.reloadData()
    }
}

extension MovieTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell
        let movie = self.movies[indexPath.row]
        cell?.configure(movie: movie)
        return cell!
    }
}

extension MovieTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 140)
    }
}

extension MovieTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = self.movies[indexPath.row]
        self.delegate?.isSelected(movie: movie)
    }
}
