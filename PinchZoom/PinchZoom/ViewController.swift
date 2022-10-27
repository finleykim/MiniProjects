//
//  ViewController.swift
//  PinchZoom
//
//  Created by finley on 2022/10/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var orangeBox: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orangeBox.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        orangeBox.center = view.center
        addPinchGesture()
        addPanGesture()
        addDoubleGesture()
        view.backgroundColor = .systemOrange
    }
    
    private func addPinchGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinchZoom(_:)))
        self.view.addGestureRecognizer(pinchGesture)
    }
    
    @objc private func didPinchZoom(_ gesture: UIPinchGestureRecognizer) {
        let newWidth = gesture.scale * self.orangeBox.frame.width
        let newHeight = gesture.scale * self.orangeBox.frame.height
        let minWidth = UIScreen.main.bounds.size.width
        let minHeight = UIScreen.main.bounds.size.height
        
        if newWidth >= minWidth && newHeight >= minHeight { //미니멈설정
            orangeBox.transform = orangeBox.transform.scaledBy(x: gesture.scale, y: gesture.scale)
            gesture.scale = 1 //이 scale factor를 1.0으로 다시 재설정하지 않으면 조금만 Pinch Gesture를 취해도 엄청나게 이미지가 확대되거나 축소됩니다.
        }
    }
    
    private func addPanGesture() {
        let draggingGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanDragging(_:))) //제스처생성 - 제스처에대한 액션은 selector로 추가
        self.view.addGestureRecognizer(draggingGesture) //뷰에 제스처를 추가
    }
    
    //제스처에 대한 액션
    @objc private func didPanDragging(_ gesture: UIPanGestureRecognizer) { //파라메터로 제스처를 받는다
        let gestureView = gesture.view!
        switch gesture.state {
        case .began, .changed:
            let delta = gesture.translation(in: gestureView.superview) //translation: 화면의 좌표계에서 팬 제스처를 해석한다 (UIPanGestureRecognizer.translation(in: 좌표대상)
            var gestureViewCenter = gestureView.center //센터지정 (UIPanGestureRecognizer 뷰의 센터가 센터임
            gestureViewCenter.x += delta.x; gestureViewCenter.y += delta.y // 뷰 중앙의 x값에 펜 제스쳐해석기의 x값(translation의 x값을 더한다) y값도 동일한 진행.
            gestureView.center = gestureViewCenter //뷰의 센터를 펜제스처의 변화된 값을 받아들인 센터 (delta)로 대입한다
            gesture.setTranslation(.zero, in: gestureView.superview) //변환된 값을 설정
        default:
            break
        }
    }
    
    private func addDoubleGesture() {
        let dubbleGesture = UIRotationGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        self.orangeBox.addGestureRecognizer(dubbleGesture)
    }
    
    @objc private func didDoubleTap(_ gesture: UIRotationGestureRecognizer) {
        orangeBox.transform = CGAffineTransform.identity
        orangeBox.center = view.center
    }
    
    private func resizing() { //리사이징 (사이즈원복)
        orangeBox.sizeToFit()
        
    }
}

//TODO: 더블탭액션(원래사이즈로 원복 - resizeAspectFill), 팬드래그 맥시멈두기

