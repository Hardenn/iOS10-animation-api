//
//  ViewController.swift
//  iOS10AnimationApi
//
//  Created by ndmitrieva on 07.07.16.
//  Copyright © 2016 *. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    // MARK: - Константы
    
    private static let AnimationDuration: TimeInterval = 5.0
    private static let AnimationXPosition: CGFloat = 300.0
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var tappedInfoLabel: UILabel!
    
    lazy var squareView: UIImageView = { [weak self] in
        let view = UIImageView(frame: CGRect(x: 20, y: 130, width: 70, height: 70))
        view.isUserInteractionEnabled = true
        view.image = UIImage(named: "robot")
        view.layer.shadowOpacity = 0.2
        view.contentMode = UIViewContentMode.scaleAspectFit
        view.tintColor = UIColor.red()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        view.addGestureRecognizer(gestureRecognizer)
        view.addGestureRecognizer(tapGestureRecognizer)
        
        return view
    }()
    
    
    // MARK: - Свойства
    
    var animator: UIViewPropertyAnimator!
    
    
    // MARK: - Жизненный цикл
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.addSubview(squareView)
        configureAndPauseSpringAnimation()
    }

    
    // MARK: - Actions
    
    @IBAction func animateAction(_ sender: AnyObject)
    {
        animate()
    }
    
    func onTap()
    {
        // Проверка на animator.isManualHitTestingEnabled
        //        tappedInfoLabel.text = "Received touch"
        //        return
        
        switch animator.state {
        case .active:
            if animator.isRunning {
                animator.pauseAnimation();
            }
            else {
                animator.startAnimation()
            }
        default:
            break
        }
    }
    
    func onPan(_ gr : UIPanGestureRecognizer)
    {
        animator.pauseAnimation()
        
        let s = gr.location(in: view)
        let f = min(s.x / view.bounds.size.width, 1.0)
        let fraction = max(0.0, f)
        animator.fractionComplete = fraction
    }
    
    
    // MARK: - Приватные методы

    private func configureAndPauseSpringAnimation()
    {
        // Скорость анимации
        let parameters = UISpringTimingParameters(dampingRatio: 0.5)
        
        // Конфигурирование аниматора с учетом длительности и скорости
        animator = UIViewPropertyAnimator(duration: ViewController.AnimationDuration,
                                          timingParameters: parameters)
        
        // Получение тапа в недвигающемся вью
        //animator.isManualHitTestingEnabled = true
        
        // Собственно набор анимаций (как во всем знакомом UIView.animate(withDuration:, animations:))
        animator.addAnimations {
            let width = UIScreen.main().bounds.width - 345
            self.squareView.center = CGPoint(x: width, y: self.squareView.center.y)
            self.squareView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI)).scaleBy(x: 1.5, y: 1.5)
        }
        
        // Запуск проигрывания анимации (есть возможность отложенного запуска)
        // animator.startAnimation(afterDelay: 10)
        animator.pauseAnimation()
    }
    
    private func configureAndStartCubicAnimation()
    {
        // Скорость анимации
        let parameters = UICubicTimingParameters(animationCurve: .easeIn)
        
        // Конфигурирование аниматора с учетом длительности и скорости
        animator = UIViewPropertyAnimator(duration: ViewController.AnimationDuration,
                                          timingParameters: parameters)
        
        // Собственно набор анимаций (как в UIView.animate(withDuration:, animations:))
        animator.addAnimations {
            self.squareView.center = CGPoint(x: ViewController.AnimationXPosition,
                                             y: self.squareView.center.y)
            self.squareView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
            self.squareView.backgroundColor = UIColor.red()
        }
        
        // Completion block
        animator.addCompletion { _ in
            self.squareView.backgroundColor = UIColor.orange()
        }
        
        // Запуск проигрывания анимации
        animator.startAnimation()
    }
    
    private func configureOldCubicAnimation()
    {
        UIView.animate(withDuration: ViewController.AnimationDuration) {
            self.squareView.center = CGPoint(x: ViewController.AnimationXPosition,
                                             y: self.squareView.center.y)
            self.squareView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        }
    }
    
    private func animate()
    {
        configureAndStartCubicAnimation()
    }
    
}

