//
//  SFileIconsCell.swift
//  SwiftyFileBrowser
//
//  Created by walker on 2021/11/24.
//

import UIKit

class SFileIconsCell: SFileBaseCollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.p_setUpUI()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.p_setUpUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = ""
        self.detailLabel.text = ""
        self.thumbnailImageView.image = nil
        self.appIconView.image = nil
//        self.downloadBtn.isHidden = true
        self.downloadMaskView.isHidden = true
    }
    
    override var isEditing: Bool {
        didSet {
            self.selectedBtn.isHidden = !self.isEditing
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.selectedBtn.setImage(UIImage.init(systemName: self.isSelected ? "checkmark.circle.fill" : "circle" ), for: .normal)
        }
    }
    
    func p_setUpUI() {
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.detailLabel)
        self.contentView.addSubview(self.thumbnailImageView)
        self.contentView.addSubview(self.appIconView)
        self.contentView.addSubview(self.downloadFlag)
        self.contentView.addSubview(self.downloadMaskView)
//        self.downloadMaskView.addSubview(self.downloadBtn)
        self.contentView.addSubview(self.selectedBtn)
        
        self.tintColor = UIColor.darkGray
        
        
        self.p_layout()
    }
    
    func p_layout() {
        
        self.thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        self.thumbnailImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.thumbnailImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5.scale).isActive = true
        self.thumbnailImageView.widthAnchor.constraint(equalToConstant: 90.scale).isActive = true
        self.thumbnailImageView.heightAnchor.constraint(equalToConstant: 90.scale).isActive = true
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 100.scale).isActive = true
        self.titleLabel.widthAnchor.constraint(equalToConstant: 100.scale).isActive = true
        
        self.detailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.detailLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.detailLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 2.scale).isActive = true
        self.detailLabel.widthAnchor.constraint(equalToConstant: 100.scale).isActive = true
        
        self.downloadFlag.translatesAutoresizingMaskIntoConstraints = false
        self.downloadFlag.rightAnchor.constraint(equalTo: self.thumbnailImageView.rightAnchor).isActive = true
        self.downloadFlag.topAnchor.constraint(equalTo: self.thumbnailImageView.topAnchor).isActive = true
        self.downloadFlag.widthAnchor.constraint(equalToConstant: 20.scale).isActive = true
        self.downloadFlag.heightAnchor.constraint(equalToConstant: 20.scale).isActive = true
        
//        self.downloadBtn.translatesAutoresizingMaskIntoConstraints = false
//        self.downloadBtn.centerXAnchor.constraint(equalTo: self.thumbnailImageView.centerXAnchor).isActive = true
//        self.downloadBtn.centerYAnchor.constraint(equalTo: self.thumbnailImageView.centerYAnchor).isActive = true
//        self.downloadBtn.widthAnchor.constraint(equalToConstant: 40.scale).isActive = true
//        self.downloadBtn.heightAnchor.constraint(equalToConstant: 40.scale).isActive = true
        
        self.downloadMaskView.translatesAutoresizingMaskIntoConstraints = false
        self.downloadMaskView.centerXAnchor.constraint(equalTo: self.thumbnailImageView.centerXAnchor).isActive = true
        self.downloadMaskView.centerYAnchor.constraint(equalTo: self.thumbnailImageView.centerYAnchor).isActive = true
        self.downloadMaskView.widthAnchor.constraint(equalTo: self.thumbnailImageView.widthAnchor).isActive = true
        self.downloadMaskView.heightAnchor.constraint(equalTo: self.thumbnailImageView.heightAnchor).isActive = true
        
        self.selectedBtn.translatesAutoresizingMaskIntoConstraints = false
        self.selectedBtn.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0.scale).isActive = true
        self.selectedBtn.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0.scale).isActive = true
        self.selectedBtn.widthAnchor.constraint(equalToConstant: 26.scale).isActive = true
        self.selectedBtn.heightAnchor.constraint(equalToConstant: 26.scale).isActive = true
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
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    lazy var detailLabel: UILabel = {
        let detailLabel = UILabel.init()
        detailLabel.lineBreakMode = .byTruncatingMiddle
        detailLabel.font = UIFont.systemFont(ofSize: 12)
        detailLabel.textColor = .darkGray
        detailLabel.backgroundColor = .clear
        detailLabel.numberOfLines = 2
        detailLabel.textAlignment = .center
        return detailLabel
    }()
    
    lazy var thumbnailImageView: UIImageView = {
        let thumbnailImageView = UIImageView.init()
        thumbnailImageView.layer.cornerRadius = 4.0
        thumbnailImageView.layer.masksToBounds = true
        thumbnailImageView.contentMode = .scaleAspectFit
        return thumbnailImageView
    }()
    
    lazy var downloadMaskView: UIView = {
        let downloadMaskView = UIView.init()
        downloadMaskView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        downloadMaskView.layer.cornerRadius = 4.0
        downloadMaskView.layer.masksToBounds = true
        downloadMaskView.isHidden = false
        return downloadMaskView
    }()
    
    lazy var appIconView: UIImageView = {
        let appIconView = UIImageView.init()
        return appIconView
    }()
    
    lazy var downloadFlag: UIImageView = {
        let downloadFlag = UIImageView.init()
        downloadFlag.image = UIImage.imageNamed("icon_download_flag", bundleForClass: SFileIconsCell.self)
        downloadFlag.isHidden = true
        return downloadFlag
    }()
    
//    lazy var downloadBtn: AppleDownloadButton = {
//        let downloadBtn = AppleDownloadButton.init(frame: .zero, isDownloaded: false, style: .iOS, palette: Palette.init(initialColor: .white, rippleColor: .white.withAlphaComponent(0.6), buttonBackgroundColor: .clear, downloadColor: .white, deviceColor: .white))
//        downloadBtn.delegate = self
//        downloadBtn.isHidden = true
//        downloadBtn.addTarget(self, action: #selector(p_downloadBtnAction), for: .touchUpInside)
//        return downloadBtn
//    }()
    
    lazy var selectedBtn: UIButton = {
        let selectedBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 26.scale, height: 26.scale))
        selectedBtn.setImage(UIImage.init(systemName: "circle"), for: .normal)
        selectedBtn.contentVerticalAlignment = .fill
        selectedBtn.contentHorizontalAlignment = .fill
        selectedBtn.isHidden = true
        selectedBtn.isUserInteractionEnabled = false
        return selectedBtn
    }()
}

extension SFileIconsCell: SFileCellSetupProtocol {
    
    static func identifierOfCell() -> String {
        return "SFileIconsCell"
    }
    
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
                self.downloadFlag.isHidden = true
//                self.downloadBtn.isHidden = true
                self.downloadMaskView.isHidden = true
                
            default:
                self.thumbnailImageView.image = self.file?.thumbnail ?? UIImage.imageNamed("icon_file_unknow_blue", bundleForClass: SFileDetailCell.self)
                self.appIconView.image = self.file?.appIcon
                self.update(fileState: self.file?.state ?? .downloaded)
            }
        }
    }
    
    func update(fileState: SFileState) {
//        switch (fileState) {
//        case .notDownloaded:
//            self.downloadFlag.isHidden = false
//            self.downloadBtn.isHidden = true
//            self.downloadMaskView.isHidden = true
//            self.downloadBtn.downloadState = .toDownload
//        case .readyToDownload:
//            self.downloadFlag.isHidden = true
//            self.downloadBtn.isHidden = false
//            self.downloadMaskView.isHidden = false
//            self.downloadBtn.downloadState = .willDownload
//        case .downloading(let progress):
//            self.downloadFlag.isHidden = true
//            self.downloadBtn.isHidden = false
//            self.downloadMaskView.isHidden = false
//            self.downloadBtn.downloadState = .readyToDownload
//            DispatchQueue.main.async {
//                self.downloadBtn.downloadPercent = CGFloat(progress)
//            }
//        case .pausedDownload(let progress):
//            self.downloadFlag.isHidden = true
//            self.downloadBtn.isHidden = true
//            self.downloadMaskView.isHidden = false
//            self.downloadBtn.downloadState = .readyToDownload
//            DispatchQueue.main.async {
//                self.downloadBtn.downloadPercent = CGFloat(progress)
//            }
//        case .downloaded:
//            self.downloadFlag.isHidden = true
//            self.downloadBtn.isHidden = true
//            self.downloadMaskView.isHidden = true
//            self.downloadBtn.downloadState = .downloaded
//        case .downloadError(_):
//            self.downloadFlag.isHidden = false
//            self.downloadBtn.isHidden = true
//            self.downloadMaskView.isHidden = true
//            self.downloadBtn.downloadState = .toDownload
//        }
    }
}

//extension SFileIconsCell: AppleDownloadButtonDelegate {
//    func stateChanged(button: AppleDownloadButton, newState: AppleDownloadButtonState) {
//        
//    }
//}
