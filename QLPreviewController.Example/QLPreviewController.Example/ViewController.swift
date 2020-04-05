//
//  ViewController.swift
//  QLPreviewController.Example
//
//  Created by Filip Němeček on 27/03/2020.
//  Copyright © 2020 Filip Němeček. All rights reserved.
//

import UIKit
import QuickLook

class ViewController: UITableViewController, QLPreviewControllerDataSource {
    
    // Image taken from here: https://www.pexels.com/photo/close-up-of-peacock-326900/
    
    let previews: [Preview] = [
        Preview(displayName: "Pages document", fileName: "Pages_example", fileExtension: "pages"),
        Preview(displayName: "PDF", fileName: "PDF_example", fileExtension: "pdf"),
        Preview(displayName: "Image", fileName: "Image_example", fileExtension: "jpg"),
        Preview(displayName: "Word document", fileName: "Word_example", fileExtension: "docx"),
        Preview(displayName: "Keynote presentation", fileName: "Keynote_example", fileExtension: "key"),
        Preview(displayName: "3D model", fileName: "cup_saucer_set", fileExtension: "usdz"),
        ].filter({ QLPreviewController.canPreview($0) })
    
    let previewVC = QLPreviewController()
    
    let previewGenerator = QLThumbnailGenerator()
    let thumbnailSize = CGSize(width: 60, height: 90)
    let scale = UIScreen.main.scale

    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewVC.dataSource = self
        
        generatePreviews()
    }
    
    func generatePreviews() {
        let group = DispatchGroup()
        
        for preview in self.previews {
            guard let url = preview.previewItemURL else { continue }
            group.enter()
            let request = QLThumbnailGenerator.Request(fileAt: url, size: self.thumbnailSize, scale: self.scale, representationTypes: .all)
            
            self.previewGenerator.generateBestRepresentation(for: request) { (thumbnail, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                } else if let thumb = thumbnail {
                    preview.thumbnail = thumb.uiImage
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PreviewCell else {
            preconditionFailure()
        }
        
        let preview = previews[indexPath.row]
        cell.configure(with: preview)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        previewVC.currentPreviewItemIndex = indexPath.row
        
        navigationController?.pushViewController(previewVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return previews.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return previews[index]
    }
    
    @IBAction func gitHubButtonTapped(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://github.com/nemecek-filip")!, options: [:], completionHandler: nil)
    }
}

class Preview: NSObject, QLPreviewItem {
    let displayName: String
    let fileName: String
    let fileExtension: String
    
    var thumbnail: UIImage?
    
    init(displayName: String, fileName: String, fileExtension: String) {
        self.displayName = displayName
        self.fileName = fileName
        self.fileExtension = fileExtension
        
        super.init()
    }
    
    var previewItemTitle: String? {
        return displayName
    }
    
    var formattedFileName: String {
        return "\(fileName).\(fileExtension)"
    }
    
    var previewItemURL: URL? {
        return Bundle.main.url(forResource: fileName, withExtension: fileExtension)
    }
}

extension ViewController {
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if let footer = tableView.tableFooterView {
            let newSize = footer.systemLayoutSizeFitting(CGSize(width: tableView.bounds.width, height: 0))
            footer.frame.size.height = newSize.height
        }
    }
}

