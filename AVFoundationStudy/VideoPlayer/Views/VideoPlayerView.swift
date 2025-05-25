//
//  VideoPlayerView.swift
//  AVFoundationStudy
//
//  Created by 김민성 on 5/25/25.
//

import UIKit

import SnapKit

final class VideoPlayerView: UIView {
    
    let playingView = VideoPlayingView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(playingView)
        playingView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
