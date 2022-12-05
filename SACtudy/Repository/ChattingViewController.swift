//
//  ChattingViewController.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/04.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class ChattingViewController: BaseViewController {
    
    let backButton: UIBarButtonItem
    let nickname: String
    let viewModel: ChattingViewModel
    let rootView = ChattingView()
    
    init(nickname: String, viewModel: ChattingViewModel) {
        self.nickname = nickname
        self.viewModel = viewModel
        self.backButton = UIBarButtonItem(image: Asset.Images.arrow.image, style: .plain, target: nil, action: nil)
        super.init(nibName: nil, bundle: nil)
        binding()
        addNotificationObserver()
    }
    
    deinit {
        removeNotificationObserver()
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        navigationItem.leftBarButtonItem = backButton
        navigationItem.titleView = UILabel(text: nickname, font: .title3)
    }
    
    override func addTapGesture() {
        let gesture = UITapGestureRecognizer()
        view.addGestureRecognizer(gesture)

        gesture.rx.event
            .withUnretained(self)
            .bind { vc, _ in
                vc.view.endEditing(true)
            }
            .disposed(by: disposeBag)
    }

}

extension ChattingViewController {
    func binding() {
        let input = ChattingViewModel.Input(
            viewDidLoad: self.rx.viewDidLoad,
            chattingText: rootView.textView.rx.text,
            sendButtonTap: rootView.textView.sendButton.rx.tap.map{ [weak self] in
                self?.rootView.textView.text ?? ""
                
            })
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        output.chatList
            .bind(to: rootView.collectionView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        
        
        rootView.textView.sendButton.rx.tap
            .map { _ in "" }
            .bind(to: rootView.textView.rx.text)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind(with: self) { vc, _ in
                vc.navigationController?.popToRootViewController(animated: true)}
            .disposed(by: disposeBag)
    }
    
    func createDataSource() -> RxCollectionViewSectionedAnimatedDataSource<ChattingViewModel.Section> {
        return RxCollectionViewSectionedAnimatedDataSource { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.isMine ? MyChatCell.reuseIdentifier : ChatCell.reuseIdentifier, for: indexPath) as? ChatCellType else { return UICollectionViewCell() }
            
            cell.inputData(data: item)
            return cell
        } configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ChattingAnnounceHeaderView.reuseIdentifier, for: indexPath) as? ChattingAnnounceHeaderView else { return UICollectionReusableView() }
            
            view.inputData(nick: self?.nickname ?? "")
            return view
        }
    }
}

extension ChattingViewController {
    
    func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let safeBottomInset = view.safeAreaInsets.bottom
        let distance = frame.height - safeBottomInset
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn]) { [weak self] in
            self?.rootView.bottomConstraint?.layoutConstraints.first.value?.constant = -(distance + 16)
            self?.rootView.collectionView.contentOffset.y += distance
            self?.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let safeBottomInset = view.safeAreaInsets.bottom
        let distance = frame.height - safeBottomInset
        
        UIView.animate(withDuration: duration) { [weak self] in
            self?.rootView.bottomConstraint?.layoutConstraints.first.value?.constant = -16
            self?.rootView.collectionView.contentOffset.y -= distance
            self?.view.layoutIfNeeded()
        }
    }
    
}
