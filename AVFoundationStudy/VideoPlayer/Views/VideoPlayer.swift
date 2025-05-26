//
//  VideoPlayer.swift
//  AVFoundationStudy
//
//  Created by 김민성 on 5/25/25.
//

import AVFoundation
import UIKit

import SnapKit

final class VideoPlayer: UIView {
    
    // AVFoundation 관련 속성
    private var playerItem: AVPlayerItem?
    private var player: AVPlayer?
    private var playerLayer = AVPlayerLayer(player: nil)
    
    // shade가 보이고 사라지는 애니메이션 관리
    private let shadeAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut)
    
    // 좌, 우 더블 탭 제스처
    private var leftDoubleTapGesture: UITapGestureRecognizer!
    private var rightDoubleTapGesture: UITapGestureRecognizer!
    
    
    // MARK: - UI Properties
    
    private let shade: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.alpha = 0
        return view
    }()
    
    private let leftTapArea: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.2)
        return view
    }()
    
    private let rightTapArea: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.2)
        return view
    }()
    
    let fullScreenButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "arrow.down.left.and.arrow.up.right"), for: .normal)
        button.tintColor = .white
        button.alpha = 0
        return button
    }()
    
    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.backgroundColor = .gray.withAlphaComponent(0.5)
        button.tintColor = .white
        button.alpha = 0
        return button
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .brown
        
        // configure layer hierarchy
        playerLayer.videoGravity = .resizeAspect
        layer.addSublayer(playerLayer)
        
        // configure view hierarchy
        addSubview(shade)
        addSubview(leftTapArea)
        addSubview(rightTapArea)
        addSubview(playButton)
        addSubview(fullScreenButton)
        
        // setting gesture, action
        playButton.addTarget(self, action: #selector(pausePlayButtonDidTap), for: .touchUpInside)
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundDidTap))
        leftDoubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(playerDidDoubleTap))
        rightDoubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(playerDidDoubleTap))
        leftDoubleTapGesture.numberOfTapsRequired = 2
        rightDoubleTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(singleTapGesture)
        leftTapArea.addGestureRecognizer(leftDoubleTapGesture)
        rightTapArea.addGestureRecognizer(rightDoubleTapGesture)
        
        // AutoLayout
        shade.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        playButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(50)
        }
        
        fullScreenButton.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().inset(30)
            make.size.equalTo(44)
        }
        
        leftTapArea.snp.makeConstraints { make in
            make.verticalEdges.left.equalToSuperview()
            make.right.equalTo(shade.snp.centerX).offset(-40)
        }
        
        rightTapArea.snp.makeConstraints { make in
            make.verticalEdges.right.equalToSuperview()
            make.left.equalTo(shade.snp.centerX).offset(40)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        // 옵저버 해제 (메모리 누수 방지)
        NotificationCenter.default.removeObserver(self)
        player?.currentItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        player?.currentItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackLikelyToKeepUp))
        player?.currentItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackBufferEmpty))
    }
    
}

// AVFoundation 관련 메서드
extension VideoPlayer {
    
    func addNewPlayer(with item: AVPlayerItem) {
        self.playerItem = item
        self.player = AVPlayer(playerItem: item)
        self.playerLayer.player = player
    }
    
}

// 영상 재생 관련 메서드
private extension VideoPlayer {
    
    @objc func pausePlayButtonDidTap() {
        guard let player else { return }
        if player.rate == 0 {
            player.play()
            playButton.setImage(.init(systemName: "pause.fill"), for: .normal)
        } else {
            player.pause()
            playButton.setImage(.init(systemName: "play.fill"), for: .normal)
        }
    }
    
    @objc func backgroundDidTap() {
        if shade.alpha == 0 {
            fadeControlUnits(show: true)
        } else if shade.alpha == 1 {
            fadeControlUnits(show: false)
        }
    }
    
    @objc func playerDidDoubleTap(sender: UITapGestureRecognizer) {
        Task {
            if sender == leftDoubleTapGesture {
                await moveTo5SecondsEarlier()
            } else if sender == rightDoubleTapGesture {
                await moveTo5SecondsLater()
            }
        }
    }
    
    func moveTo5SecondsLater() async {
        guard let player else { return }
        let currentTime = player.currentTime()
        let fiveSeconds = CMTime(seconds: 5, preferredTimescale: 600)
        let targetTime = CMTimeAdd(currentTime, fiveSeconds)
        
        // Swift Concurrency 사용
        let isCompleted = await player.seek(to: targetTime)
        if isCompleted {
            print("seeking completed!!")
        } else {
            print("seeking failed!!")
        }
        
//        completion handler 사용 시
//        player.seek(to: targetTime) { isCompleted in
//            if isCompleted {
//                print("hopping completed!!")
//            } else {
//                print("hopping failed!!")
//            }
//        }
    }
    
    func moveTo5SecondsEarlier() async {
        guard let player else { return }
        let currentTime = player.currentTime()
        let fiveSeconds = CMTime(seconds: 5, preferredTimescale: 600)
        let targetTime = CMTimeSubtract(currentTime, fiveSeconds)
        
        // Swift Concurrency 사용
        let isCompleted = await player.seek(to: targetTime)
        if isCompleted {
            print("seeking completed!!")
        } else {
            print("seeking failed!!")
        }
        
//        completion handler 사용 시
//        player.seek(to: targetTime) { isCompleted in
//            if isCompleted {
//                print("hopping completed!!")
//            } else {
//                print("hopping failed!!")
//            }
//        }
    }
}


private extension VideoPlayer {
    
    func fadeControlUnits(show: Bool) {
        shadeAnimator.stopAnimation(true)
        shadeAnimator.addAnimations {[weak self] in
            self?.shade.alpha = show ? 1 : 0
            self?.playButton.alpha = show ? 1 : 0
            self?.fullScreenButton.alpha = show ? 1 : 0
        }
        shadeAnimator.startAnimation()
    }
    
}
