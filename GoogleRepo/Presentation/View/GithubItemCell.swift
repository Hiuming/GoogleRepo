//
//  GithubItemCell.swift
//  GoogleRepo
//
//  Created by Huynh Minh Hieu on 27/09/2024.
//

import UIKit

class GithubItemCell: UITableViewCell {
    

    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoDes: UILabel!
    @IBOutlet weak var starLbl: UILabel!
    @IBOutlet weak var forkLbl: UILabel!
    
    @IBOutlet weak var backgroundCellView: UIView!
    
    @IBOutlet weak var tagPublic: UIButton!
    
    @IBOutlet weak var circleLanguageColor: UIView!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var languageStackView: UIStackView!
    
    @IBOutlet weak var iconFork: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let bgView = UIView()
        bgView.backgroundColor = .clear
        selectedBackgroundView = bgView
        
        backgroundCellView.layer.cornerRadius = 10
        backgroundCellView.layer.borderColor = UIColor.lightGray.cgColor
        backgroundCellView.layer.borderWidth = 0.5
        
        repoName.font = UIFont.systemFont(ofSize: 17)
        repoDes.font = UIFont.systemFont(ofSize: 15, weight: .light)
        
        
        tagPublic.layer.cornerRadius = 10
        tagPublic.layer.borderWidth = 0.5
        tagPublic.layer.borderColor = UIColor.lightGray.cgColor
        
        circleLanguageColor.layer.cornerRadius = circleLanguageColor.frame.width/2
        
        languageStackView.isHidden = true
        tagPublic.isUserInteractionEnabled = false
        
        iconFork.image = UIImage(named: "icon_fork")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    public func setup(item: RepoItem) {
        repoName.text = item.name ?? ""
        repoDes.text = item.description ?? ""
        starLbl.text = Double(item.stargazersCount ?? 0).shortStringRepresentation
        forkLbl.text = Double(item.forks ?? 0).shortStringRepresentation
        tagPublic.setTitle("\(item.visibility ?? "")".firstUppercased, for: .normal)
        if let language = item.language, !language.isEmpty {
            languageLabel.text = language
            let color = Utils.getLanguageColor(language: language)
            circleLanguageColor.backgroundColor = color
            languageStackView.isHidden = false
        }
    }
    
    override func prepareForReuse() {
        languageStackView.isHidden = true
        circleLanguageColor.backgroundColor = .clear
    }
    
    
}
