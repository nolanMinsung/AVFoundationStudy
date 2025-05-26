//
//  VideoPlayerView.swift
//  AVFoundationStudy
//
//  Created by 김민성 on 5/25/25.
//

import UIKit

import SnapKit

/// `VideoPlayerViewController`의 root view.
final class VideoPlayerView: UIView {
    
    // 영상이 화면을 가득 채우고 있는지 여부를 나타내는 custom flag.
    private var isFullScreen: Bool = false
    
    let playingView = VideoPlayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor  = .gray
        addSubview(playingView)
        applyPortraitConstraints()
        playingView.fullScreenButton.addTarget(self, action: #selector(fullScreenButtonDidTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// Layout 관련 메서드
extension VideoPlayerView {
    
    func applyPortraitConstraints() {
        playingView.snp.remakeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(playingView.snp.width).multipliedBy(9.0/16.0)
        }
        isFullScreen = false
    }
    
    func applyLandscapeConstraints() {
        playingView.snp.remakeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        isFullScreen = true
    }
    
}

// 전체화면, 회전 관련 메서드
private extension VideoPlayerView {
    
    @objc func fullScreenButtonDidTap() {
        if isFullScreen {
            playingView.fullScreenButton.setImage(
                .init(systemName: "arrow.down.left.and.arrow.up.right"),
                for: .normal
            )
            rotate(to: .portrait)
        } else {
            playingView.fullScreenButton.setImage(
                .init(systemName: "arrow.up.right.and.arrow.down.left"),
                for: .normal
            )
            rotate(to: .landscapeRight)
        }
    }
    
    private func rotate(to orientation: UIInterfaceOrientation) {
        if #available(iOS 16, *) {
            guard let windowScene = window?.windowScene else { return }
            windowScene.requestGeometryUpdate(
                .iOS(interfaceOrientations: (orientation == .portrait) ? .portrait : .landscapeRight)
            )
        } else {
            /// Warning: BUG IN CLIENT OF UIKIT: Setting UIDevice.orientation is not supported. Please use `UIWindowScene.requestGeometryUpdate(_:)`
            UIDevice.current.setValue(orientation, forKey: "orientation")
        }
    }
    
}
