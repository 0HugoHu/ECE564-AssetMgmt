//
//  SFileDetailCell.swift
//  SwiftyFileBrowser
//
//  Created by Hansen on 2021/11/24.
//

import UIKit

class SFileDetailCell: SFileBaseTableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.p_setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = ""
        self.detailLabel.text = ""
        self.thumbnailImageView.image = nil
        self.appIconView.image = nil
        self.accessoryType = .none
//        self.downloadBtn.isHidden = true
    }
    
    func p_setUpUI() {
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.detailLabel)
        self.contentView.addSubview(self.thumbnailImageView)
        self.contentView.addSubview(self.appIconView)
//        self.contentView.addSubview(self.downloadBtn)
        
        let bgView = UIView.init()
        bgView.backgroundColor = .clear
        self.selectedBackgroundView = bgView
        self.tintColor = UIColor.darkGray
        p_layout()
    }
    
    func p_layout() {
       
        self.thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        self.thumbnailImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10.scale).isActive = true
        self.thumbnailImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.thumbnailImageView.widthAnchor.constraint(equalToConstant: 44.scale).isActive = true
        self.thumbnailImageView.heightAnchor.constraint(equalToConstant: 44.scale).isActive = true
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.leftAnchor.constraint(equalTo: self.thumbnailImageView.rightAnchor, constant: 5.scale).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0.scale).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -45.scale).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: 20.scale).isActive = true

        self.detailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.detailLabel.leftAnchor.constraint(equalTo: self.thumbnailImageView.rightAnchor, constant: 5.scale).isActive = true
        self.detailLabel.topAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 5.scale).isActive = true
        self.detailLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -45.scale).isActive = true
        self.detailLabel.heightAnchor.constraint(equalToConstant: 16.scale).isActive = true

//        self.downloadBtn.translatesAutoresizingMaskIntoConstraints = false
//        self.downloadBtn.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
//        self.downloadBtn.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5.scale).isActive = true
//        self.downloadBtn.widthAnchor.constraint(equalToConstant: 36.scale).isActive = true
//        self.downloadBtn.heightAnchor.constraint(equalToConstant: 36.scale).isActive = true
    }
    
    @objc func p_downloadBtnAction() {
        if let curFile = self.file {
            self.delegate?.fileDownloadButtonAction(indexPath: indexPath, file: curFile)
        }
    }
    
    // MARK: - lazy load -
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel.init()
        titleLabel.lineBreakMode = .byTruncatingMiddle
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .black
        titleLabel.backgroundColor = .clear
        return titleLabel
    }()
    
    lazy var detailLabel: UILabel = {
        let detailLabel = UILabel.init()
        detailLabel.lineBreakMode = .byTruncatingMiddle
        detailLabel.font = UIFont.systemFont(ofSize: 12)
        detailLabel.textColor = .darkGray
        detailLabel.backgroundColor = .clear
        return detailLabel
    }()
    
    lazy var thumbnailImageView: UIImageView = {
        let thumbnailImageView = UIImageView.init()
        thumbnailImageView.contentMode = .scaleAspectFit
        return thumbnailImageView
    }()
    
    lazy var appIconView: UIImageView = {
        let appIconView = UIImageView.init()
        return appIconView
    }()
    
//    lazy var downloadBtn: AppleDownloadButton = {
//        let downloadBtn = AppleDownloadButton.init(frame: .zero, isDownloaded: false, style: .iOS, palette: Palette.init(initialColor: .systemBlue, rippleColor: nil, buttonBackgroundColor: .clear, downloadColor: .systemBlue, deviceColor: .systemBlue))
//        downloadBtn.delegate = self
//        downloadBtn.isHidden = true
//        downloadBtn.addTarget(self, action: #selector(p_downloadBtnAction), for: .touchUpInside)
//        return downloadBtn
//    }()
}

extension SFileDetailCell: SFileCellSetupProtocol {
    
    func setupCell(indexPath: IndexPath?, file: SFile) {
        self.indexPath = indexPath
        self.file = file
        
        DispatchQueue.main.async {
            self.titleLabel.text = self.file?.fileName
            self.detailLabel.text = self.file?.detailText
            
            switch (self.file?.fileType ?? .unknow) {
            case .folder:
                self.thumbnailImageView.image = self.file?.thumbnail ?? UIImage.imageNamed("icon_folder_close", bundleForClass: SFileDetailCell.self)
                self.appIconView.image = self.file?.appIcon
                self.accessoryType = .disclosureIndicator
//                self.downloadBtn.isHidden = true
            default:
                self.thumbnailImageView.image = self.file?.thumbnail ?? UIImage.imageNamed("icon_file_unknow", bundleForClass: SFileDetailCell.self)
                self.appIconView.image = self.file?.appIcon
                self.accessoryType = .none
                self.update(fileState: self.file?.state ?? .downloaded)
            }
        }
    }
    
    func update(fileState: SFileState) {
//        switch (fileState) {
//        case .notDownloaded:
//            self.downloadBtn.isHidden = false
//            self.downloadBtn.downloadState = .toDownload
//        case .readyToDownload:
//            self.downloadBtn.isHidden = false
//            self.downloadBtn.downloadState = .willDownload
//        case .downloading(let progress):
//            self.downloadBtn.isHidden = false
//            self.downloadBtn.downloadState = .readyToDownload
//            DispatchQueue.main.async {
//                self.downloadBtn.downloadPercent = CGFloat(progress)
//            }
//        case .pausedDownload(let progress):
//            self.downloadBtn.isHidden = false
//            self.downloadBtn.downloadState = .readyToDownload
//            DispatchQueue.main.async {
//                self.downloadBtn.downloadPercent = CGFloat(progress)
//            }
//        case .downloaded:
//            self.downloadBtn.isHidden = true
//            self.downloadBtn.downloadState = .downloaded
//        case .downloadError(_):
//            self.downloadBtn.isHidden = false
//            self.downloadBtn.downloadState = .toDownload
//        }
    }
    
    class func identifierOfCell() -> String {
        return "SFileDetailCell"
    }
}

//extension SFileDetailCell: AppleDownloadButtonDelegate {
//    func stateChanged(button: AppleDownloadButton, newState: AppleDownloadButtonState) {
//        
//    }
//}
