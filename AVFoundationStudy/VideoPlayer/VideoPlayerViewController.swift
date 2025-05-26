//
//  VideoPlayerViewController.swift
//  AVFoundationStudy
//
//  Created by 김민성 on 5/25/25.
//

import UIKit
import AVFoundation

class VideoPlayerViewController: UIViewController {

    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    let rootView = VideoPlayerView()
    
    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoPlayer()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = view.bounds
    }

    private func setupVideoPlayer() {
        // 1. HLS m3u8 파일의 URL 생성
        guard let url = URL(
            string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8"
        ) else {
            print("Invalid URL")
            return
        }
        
        // 2. AVPlayerItem 생성
        // AVPlayerItem은 m3u8 파일을 자동으로 파싱하고 적절한 비디오 스트림을 선택함.
        let playerItem = AVPlayerItem(url: url)
        rootView.playingView.addNewPlayer(with: playerItem)
        
        // 3. AVPlayer 생성 및 AVPlayerItem 할당
//        player = AVPlayer(playerItem: playerItem)

        // 4. AVPlayerLayer 생성 및 AVPlayer 할당
//        playerLayer = AVPlayerLayer(player: player)
        
        // playerLayer의 비율 조정
//        playerLayer?.videoGravity = .resizeAspect

        // 5. playerLayer를 뷰의 레이어에 추가
//        if let playerLayer = playerLayer {
//            view.layer.addSublayer(playerLayer)
//        }
        
        // 6. 플레이어 상태 변화 감지
        // 예를 들어, 재생 준비가 완료되었을 때 자동으로 재생 시작.
        addPlayerItemObservers(playerItem: playerItem)

        // 7. 재생 시작
//        player?.play()
    }
    
    private func addPlayerItemObservers(playerItem: AVPlayerItem) {
        // 재생이 끝까지 완료될 경우 notification 감지
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: playerItem)
        
        // 비디오의 로딩 상태 (버퍼링 등)를 감지합니다.
        playerItem.addObserver(self,
                               forKeyPath: #keyPath(AVPlayerItem.status),
                               options: [.new, .initial],
                               context: nil)
        
        playerItem.addObserver(self,
                               forKeyPath: #keyPath(AVPlayerItem.isPlaybackLikelyToKeepUp),
                               options: [.new, .initial],
                               context: nil)
        
        playerItem.addObserver(self,
                               forKeyPath: #keyPath(AVPlayerItem.isPlaybackBufferEmpty),
                               options: [.new, .initial],
                               context: nil)
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        guard let playerItem = object as? AVPlayerItem else { return }

        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }

            switch status {
            case .readyToPlay:
                print("AVPlayerItem status: readyToPlay - 비디오 재생 준비 완료")
                print("AVPlayerItem duration: \(playerItem.duration)")
//                print("playerItem.tracks: \(playerItem.tracks)")
                print("AVPlayerItem 재생")
            case .failed:
                print("AVPlayerItem status: failed - 비디오 재생 실패. Error: \(playerItem.error?.localizedDescription ?? "Unknown error")")
            case .unknown:
                print("AVPlayerItem status: unknown")
            @unknown default:
                break
            }
            
        } else if keyPath == #keyPath(AVPlayerItem.isPlaybackLikelyToKeepUp) {
            if playerItem.isPlaybackLikelyToKeepUp {
                print("AVPlayerItem status: Playback likely to keep up (버퍼링 완료)")
                // 버퍼링이 완료되었을 때 재생을 재개하거나 표시할 수 있습니다.
            } else {
                print("AVPlayerItem status: Playback not likely to keep up (버퍼링 중...)")
            }
            
        } else if keyPath == #keyPath(AVPlayerItem.isPlaybackBufferEmpty) {
            if playerItem.isPlaybackBufferEmpty {
                print("AVPlayerItem status: Playback buffer empty (버퍼링 시작)")
                // 로딩 인디케이터 표시
            }
        }
    }
    
    @objc private func playerDidFinishPlaying(notification: Notification) {
        print("비디오 재생 완료.")
        // 재생 완료 후 처리할 로직 추가
    }

}
