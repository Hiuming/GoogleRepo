//
//  ViewController.swift
//  GoogleRepo
//
//  Created by Huynh Minh Hieu on 26/09/2024.
//

import UIKit
import RxSwift
import SDWebImage
import SnapKit
import UIScrollView_InfiniteScroll
import SkeletonView

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var avatarImg: UIImageView!
    var triggerLoad = PublishSubject<Void>()
    
    var repoTitle: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    var repoSubTitle: UILabel = {
        let label = UILabel()
         label.font = UIFont.systemFont(ofSize: 15, weight: .light)
         return label
     }()
    
    var followersLbl: UILabel = {
        let label = UILabel()
         label.font = UIFont.systemFont(ofSize: 15, weight: .light)
         return label
     }()
    var addressLbl: UILabel = {
        let label = UILabel()
         label.font = UIFont.systemFont(ofSize: 15, weight: .light)
         return label
     }()
    var refLinkLbl: UILabel = {
        let label = UILabel()
         label.font = UIFont.systemFont(ofSize: 15, weight: .light)
         return label
     }()
    
    private var disposeBag = DisposeBag()
    
    
    private let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.binds()
    }
    
    
    func binds() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).mapToVoid()
        let commonTrigger = viewWillAppear
        
        
        
        let input = ViewModel.Input(trigger: commonTrigger,triggerLoadItem: triggerLoad.asObservable())
        let output = viewModel.transform(input)
        self.triggerLoad.onNext(())
        
        output.loading.subscribe(onNext: { [weak self] loading in
            guard let self = self else { return }
            if loading {
                self.startLoading()
            } else {
                self.stopLoading()
            }
        }).disposed(by: self.disposeBag)
        
        
        output.repo
            .skip(1)
            .map {"\($0?.login ?? "")".firstUppercased}
            .drive(repoTitle.rx.text)
            .disposed(by: self.disposeBag)
        
        output.repo
            .skip(1)
            .map {"\($0?.description ?? "")"}
            .drive(repoSubTitle.rx.text)
            .disposed(by: self.disposeBag)
        
        output.repo
            .skip(1)
            .map {"\($0?.blog ?? "")"}
            .drive(refLinkLbl.rx.text)
            .disposed(by: self.disposeBag)
        
        output.repo
            .skip(1)
            .map { item in
                let followers = Double(item?.followers ?? 0).shortStringRepresentation
                let att1 = [NSAttributedString.Key.foregroundColor: UIColor.black,
                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .semibold)]
                let att2 = [NSAttributedString.Key.foregroundColor: UIColor.black,
                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light)]
                
                let followerText = NSMutableAttributedString(string: followers + " ", attributes: att1)
                let followerStr = NSMutableAttributedString(string: "followers", attributes: att2)
                
                followerText.append(followerStr)
                return followerText
            }
            .drive(followersLbl.rx.attributedText)
            .disposed(by: self.disposeBag)
        
        output.repo
            .skip(1)
            .map {"\($0?.location ?? "")"}
            .drive(addressLbl.rx.text)
            .disposed(by: self.disposeBag)
        
        output.repo
            .skip(1)
            .map {URL(string: $0?.avatarurl ?? "www.google.com")!}.drive(onNext: { [weak self] value in
            self?.avatarImg.sd_setImage(with: value)
        }).disposed(by: self.disposeBag)
        
        
        output.repoItemList
            .skip(1)
            .drive(tableView.rx.items) { tableView, index, element in
                tableView.finishInfiniteScroll()
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "githubitemcell",for: IndexPath(index: index)) as? GithubItemCell else {return UITableViewCell()}
            cell.setup(item: element)
            return cell
        }
        .disposed(by: self.disposeBag)
        
  
        
    }
    
    private func setupHeader() {
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 200))
        
        avatarImg = UIImageView()
        
        let followerIcon = UIImageView(image: UIImage(systemName: "person.2"))
        followerIcon.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        followerIcon.tintColor = .lightGray
        let followerStackView = UIStackView(arrangedSubviews: [followerIcon,followersLbl])
        followerStackView.distribution = .fill
        followerStackView.spacing = 4
        followerStackView.axis = .horizontal
        
        let addressIcon = UIImageView(image: UIImage(systemName: "mappin.circle"))
        addressIcon.frame = CGRect(x: 0, y: 0, width: 12, height: 12)
        addressIcon.tintColor = .lightGray
        let addressStackView = UIStackView(arrangedSubviews: [addressIcon,addressLbl])
        addressStackView.distribution = .fill
        addressStackView.spacing = 4
        addressStackView.axis = .horizontal
        
        let refLinkIcon = UIImageView(image: UIImage(systemName: "link"))
        refLinkIcon.frame = CGRect(x: 0, y: 0, width: 12, height: 12)
        refLinkIcon.tintColor = .lightGray
        let refLinkStackView = UIStackView(arrangedSubviews: [refLinkIcon,refLinkLbl])
        refLinkStackView.distribution = .fill
        refLinkStackView.spacing = 4
        refLinkStackView.axis = .horizontal
        
        
        let stackView = UIStackView(arrangedSubviews: [repoTitle, repoSubTitle, followerStackView, addressStackView, refLinkStackView])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.distribution = .fill
        
        
        containView.addSubview(avatarImg)
        containView.addSubview(stackView)
        
        avatarImg.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(10)
            make.height.width.equalTo(128)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(avatarImg.snp.trailing).offset(10)
            make.top.equalToSuperview().inset(10)
        }
        
        self.tableView.tableHeaderView = containView
        
        
        avatarImg.isSkeletonable = true
    }
    
    private func setupUI() {
        setupHeader()
        tableView.register(UINib(nibName: "GithubItemCell", bundle: nil), forCellReuseIdentifier: "githubitemcell")
        tableView.register(CustomHeaderView.self, forHeaderFooterViewReuseIdentifier: "CustomHeaderView")
        tableView.separatorStyle = .none
        
        tableView.addInfiniteScroll { [weak self] _  in
            guard let self = self else {return}
            self.triggerLoad.onNext(())
        }
        tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
    }
    
    private func startLoading() {
        Task { @MainActor in
            avatarImg.showAnimatedSkeleton()
        }
    }
    
    private func stopLoading() {
        Task { @MainActor in
            avatarImg.hideSkeleton(transition: .crossDissolve(0.25))
        }
    }
    
    
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let customHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView") as! CustomHeaderView
                return customHeaderView
            }

        // This is WRONG:
        return UIView()
    }
}
