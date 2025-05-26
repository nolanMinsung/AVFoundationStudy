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
    
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    var playerLayer = AVPlayerLayer(player: nil)
    
    
    let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.backgroundColor = .gray.withAlphaComponent(0.5)
        button.tintColor = .white
        return button
    }()
    
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .brown
        playerLayer.videoGravity = .resizeAspect
        layer.addSublayer(playerLayer)
        addSubview(playButton)
        playButton.addTarget(self, action: #selector(pausePlayButtonDidTap), for: .touchUpInside)
        
        // AutoLayout
        playButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(50)
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
    
    func addNewPlayer(with item: AVPlayerItem) {
        self.playerItem = item
        self.player = AVPlayer(playerItem: item)
        self.playerLayer.player = player
    }
    
    @objc private func pausePlayButtonDidTap() {
        if player?.rate == 0 {
            player?.play()
            playButton.setImage(.init(systemName: "pause.fill"), for: .normal)
        } else {
            player?.pause()
            playButton.setImage(.init(systemName: "play.fill"), for: .normal)
        }
    }
    
}
