//
//  NearStoreListVC.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/15.
//

import UIKit
import RealmSwift
import Foundation

enum ListMode{
    case NearStore
    case RecentViewedStore
    case FavoriteStore
}

class StoreListVC: UIViewController, StoreListCellDelegate {

    
 
    // MARK: - UI Settings
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        return button
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    lazy var topViewLabel: UILabel = {
        let label = UILabel()
        label.text = "ViewTitleLabel"
        label.textColor = .titleBlue
        label.font = .BasicFont(.semiBold, size: 18)
        return label
    }()
    
    lazy var storeTableView: UITableView = {
        let tv = UITableView()
       
        return tv
    }()
    
    var storeData: [StoreData]?
    var contentMode: ListMode = .NearStore
    let realm = try! Realm()
    var recentViewedData: Results<RecentViewedData>!
    var getStoreDetailManager = GetStoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSet()
        layout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setDisplayData()
    }
    
    func setDisplayData() {
        switch contentMode {
        case .NearStore:
            topViewLabel.text = "내근처 세탁소"
        case .FavoriteStore:
            topViewLabel.text = "찜한 세탁소"
        case .RecentViewedStore:
            topViewLabel.text = "최근 본 세탁소"
        }
    }
    
    func tableViewSet() {
        storeTableView.delegate = self
        storeTableView.dataSource = self
        storeTableView.separatorColor = .clear
        storeTableView.backgroundColor = .mainBackground

        storeTableView.register(UINib(nibName: "StoreListCustomView", bundle: nil), forCellReuseIdentifier: "StoreListCustomView")
    }
    
    func favoriteReload() {
//        self.storeTableView.deleteRows(at: <#T##[IndexPath]#>, with: <#T##UITableView.RowAnimation#>)
        self.storeTableView.reloadData()
        
    }
   // MARK: - UI Layout Setting
    func layout() {
        view.backgroundColor = .mainBackground
        view.addSubview(topView)
        topView.addSubview(backButton)
        topView.addSubview(searchButton)
        topView.addSubview(topViewLabel)
        view.addSubview(storeTableView)
        
        topView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.screenHeight * 0.108)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalToSuperview().offset(-15)
        }
        searchButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-26)
            $0.centerY.equalTo(backButton.snp.centerY)
        }
        topViewLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton.snp.centerY)
        }
        storeTableView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(Device.screenWidth * 0.95)
            $0.bottom.equalToSuperview()
        }
        
    }
    
    @objc private func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension StoreListVC: UITableViewDelegate, UITableViewDataSource {
    // 섹션의 개수를 데이터의 개수만큼 생성하고, 각 섹션의 로우는 1개로 정한다.
    func numberOfSections(in tableView: UITableView) -> Int {
        return storeData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    // 각 섹션에 해당하는 데이터를 넣으므로 indexPath.row 가 아니고 .section이 된다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.storeTableView.dequeueReusableCell(withIdentifier: "StoreListCustomView", for: indexPath as IndexPath) as! StoreListCustomView

        cell.storeNameLabel.text = storeData![indexPath.section].name
        cell.storeAddressLabel.text = storeData![indexPath.section].address
        cell.storeData = storeData![indexPath.section]
        cell.delegate = self
        
        
        if realm.objects(FavoriteData.self).filter("id == %@", storeData![indexPath.section].id ?? "").first != nil {
            cell.favoriteButtonStatus = .on
            cell.favoriteButton.tintColor = .red
        } else {
            cell.favoriteButtonStatus = .off
            cell.favoriteButton.tintColor = .gray
        }
       // 셀 선택시 회색으로 바뀌지 않게 설정
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        // Cell Shadow 작업중..
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = false
        let shadowPath2 = UIBezierPath(rect: CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.height-3))
        // 그림자 시작위치
        cell.layer.shadowOffset = CGSize(width: 0, height: 1)
        // 그림자 크기와 방향
        cell.layer.shadowPath = shadowPath2.cgPath
        // 그림자 색상
        cell.layer.shadowColor = UIColor.gray.cgColor
        // 그림자 투명도
        cell.layer.shadowOpacity = 0.5
        // 그림자 radius
        cell.layer.shadowRadius = 10


        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = StoreDetailVC()
        
        vc.modalPresentationStyle = .overFullScreen
        vc.storeDetailData = self.storeData![indexPath.section]
        present(vc, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }


}
