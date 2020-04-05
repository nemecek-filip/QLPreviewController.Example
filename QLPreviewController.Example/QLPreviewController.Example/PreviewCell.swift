//
//  PreviewCell.swift
//  QLPreviewController.Example
//
//  Created by Filip Němeček on 05/04/2020.
//  Copyright © 2020 Filip Němeček. All rights reserved.
//

import UIKit

class PreviewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with preview: Preview) {
        titleLabel.text = preview.displayName
        subtitleLabel.text = preview.formattedFileName
        
        if let thumb = preview.thumbnail {
            thumbnailImageView.image = thumb
        }
    }

}
