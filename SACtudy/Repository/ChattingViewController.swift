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
    let menuButton: UIBarButtonItem
    let nickname: String
    let viewModel: ChattingViewModel
    let rootView = ChattingView()
    
    init(nickname: String, viewModel: ChattingViewModel) {
        self.nickname = nickname
        self.viewModel = viewModel
        self.backButton = UIBarButtonItem(image: Asset.Images.arrow.image, style: .plain, target: nil, action: nil)
        self.menuButton = UIBarButtonItem(image: Asset.Images.more.image, style: .plain, target: nil, action: nil)
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
        navigationItem.rightBarButtonItem = menuButton
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
        
        rootView.topMenu.bottomInsetView.gestureRecognizers?.first?
            .rx.event
            .withUnretained(self)
            .map { vc, _ in vc.rootView.topMenu.isHidden }
            .bind(to: rootView.topMenu.rx.isRevealed)
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
                
            },
            menuButtonTap: menuButton.rx.tap
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        output.chatList
            .bind(to: rootView.collectionView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        output.isStduyEnded
            .bind(with: self) { vc, matchState in
                let title = matchState.isEnd ? "스터디 종료" : "스터디 취소"
                vc.rootView.topMenu.cancelStudyButton
                    .configuration?.attributedTitle = AttributedString(text: title, font: .title3, color: Asset.Colors.black.color)
            }
            .disposed(by: disposeBag)
        
        rootView.textView.sendButton.rx.tap
            .map { _ in "" }
            .bind(to: rootView.textView.rx.text)
            .disposed(by: disposeBag)
        
        rootView.topMenu.cancelStudyButton.rx.tap
            .withLatestFrom(output.isStduyEnded.asObservable())
            .bind(with: self) { vc, matchState in
                let viewModel = CancelStudyViewModel(uid: matchState.uid)
                let title = matchState.isEnd ? "스터디를 종료하시겠습니까?" : "스터디를 취소하시겠습니까?"
                let subtitle = matchState.isEnd ? "상대방이 스터디를 취소했기 때문에\n패널티가 부과되지 않습니다" : "스터디를 취소하시면 패널티가 부과됩니다."
                let view = PopupView(title: title, subtitle: subtitle)
                let popup = CancelStudyViewController(viewModel: viewModel, rootView: view)
                popup.modalTransitionStyle = .crossDissolve
                popup.modalPresentationStyle = .overFullScreen
                vc.transition(popup, isModal: true)
            }
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind(with: self) { vc, _ in
                vc.navigationController?.popToRootViewController(animated: true)}
            .disposed(by: disposeBag)
        
        Observable<Void>.merge(menuButton.rx.tap.asObservable(), rootView.topMenu.cancelStudyButton.rx.tap.asObservable())
            .withUnretained(self)
            .map { vc, _ in vc.rootView.topMenu.isHidden }
            .bind(to: rootView.topMenu.rx.isRevealed)
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
