//
//  CustomHeaderView.swift
//  GoogleRepo
//
//  Created by Huynh Minh Hieu on 28/09/2024.
//

import Foundation
import UIKit
import SnapKit
class CustomHeaderView: UITableViewHeaderFooterView {
    let titleLbl: UILabel = {
        let label = UILabel()
        label.text = "Popular repositories"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
