//
//  VideoPlayerView.swift
//  AVFoundationStudy
//
//  Created by 김민성 on 5/25/25.
//

import UIKit

import SnapKit

final class VideoPlayerView: UIView {
    
    let playingView = VideoPlayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor  = .gray
        addSubview(playingView)
        playingView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(playingView.snp.width).multipliedBy(9.0/16.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
