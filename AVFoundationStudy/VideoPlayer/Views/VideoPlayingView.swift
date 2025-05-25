//
//  VideoPlayingView.swift
//  AVFoundationStudy
//
//  Created by 김민성 on 5/25/25.
//

import AVFoundation
import UIKit

final class VideoPlayingView: UIView {
    
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    var playerLayer = AVPlayerLayer(player: nil)
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.addSublayer(playerLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPlayerItem(_ item: AVPlayerItem) {
        playerItem = item
        
    }
    
}
