## AVFoundation HSL 공부용 개인 프로젝트

### HSL(HTTP Live Streaming)
- 가장 널리 사용되는 비디오 스트리밍 포맷.
  비디오 파일을 다운로드할 수 있는 작은 파일 조각(fmp4)로 나누고, HTTP 프로토콜을 이용하여 전송.
- 네트워크 상태에 따라 데이터 전송률을 변경하는 적응형 비트 전송률이 특징.
- 애플에서 개발 -> 현재는 다양한 장치에서 사용됨.  
  이 덕분에 `AVFoundation`에서 HSL 기능을 지원.
- 많은 기능을 추상화하여 간단하게 구현 가능
- 예시 m3u8 URL:  
  https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8

### `AVFoudnation` 프레임워크 사용
- `AVAsset`:
  `AVFoundation`에서 사용되는 미디어 애셋.
  `AVAsset`은 `AVAssetTrack`의 container
    
  <img src="https://github.com/user-attachments/assets/8e4c3109-f2fc-4758-9868-6c012d98c62b" width=400>

  이 앱에서는 `AVFoudnation`의 추상화된 기능에 많이 의존하는 편이므로, 현재로써는 `AVAsset` 객체를 직접 다루지는 않음.  
- `AVPlayerItem`:  
  m3u8 URL을 사용하여 AVPlayerItem 객체 생성 가능  
- `AVPlayer`:  
  미디어의 시간 조절, 재생 등을 컨트롤하는 객체.  
  `play()` 등의 메서드를 가짐.  
  시간 표현에는 `CMTime` 타입 사용  
- `AVPlayerLayer`:  
  `AVPlayer` 객체를 시각적으로 표현하는 (presents the visual contents) 객체.  
  실제로 동영상이 나타나는 layer에 해당.  
  AutoLayout을 적용하기 위해, `VideoPlayer` 라는 view를 구현하고, 이 view의 layer에 `subLayer`로 `AVPlayerLayer` 인스턴스를 추가하였음.  
  (`AVPlayerLayer`가 나타날 위치는 `ViderPlayer` 의 AutoLayout 제약사항으로 결정)  
- 간단한 기능만을 빠르게 구현하려면 `AVKit`으로 사용 가능. 그러나 OTT 플랫폼과 같이 동영상 플레이어 UI를 커스텀하고자 하는 경우  
  UI 커스텀을 공부해 보기 위해 `AVKit`는 사용하지 않았음.  

### 시연 영상

<video src="https://github.com/user-attachments/assets/a9456988-571a-4e00-bfcb-af2f39f0cd09" width=250>

