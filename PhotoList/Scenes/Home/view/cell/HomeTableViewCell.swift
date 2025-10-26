//
//  HomeTableViewCell.swift
//  PhotoList
//
//  Created by Pham Khanh Huy on 22/10/25.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var size: UILabel!
    
    
    @IBOutlet weak var height_of_image: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photo.contentMode = .scaleToFill
        photo.clipsToBounds = true
        photo.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Cancel any ongoing image loading if applicable
        photo.image = nil
        name.text = nil
        size.text = nil
        UIImageView.cancellables.object(forKey: photo)?.cancel() // cancel Combine download
    }

    var data:Photo? = nil {
        didSet {
            guard let data = self.data else { return }
  
         
            if let url = URL(string: data.download_url) {
                photo.loadImage(from: url, placeholder: UIImage(named: "placeholder"))
            }
            name.text = data.author
            size.text = String(format: "%dx%d", data.width, data.height)

        }
    }
    

    
}
