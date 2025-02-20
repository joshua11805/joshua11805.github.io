//
//  SignOutViewDelegate.swift
//  HealthQuest
//
//  Created by JoshuaShin on 12/11/24.
//

import UIKit
import SwiftUI

//creating an appdelegate that needs have a didTapSignOut() function
protocol SignOutViewDelegate: AnyObject {
    func didTapSignOut()
}

//UIKit View
class SignOutView: UIView {
    weak var delegate: SignOutViewDelegate?

    //creating the button
    private let signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    
    private func setupView() {
        backgroundColor = .systemBackground
        addSubview(signOutButton)

        //setting up the bounds of the button, currently set it at the center of the screen
        //but for future reference this easily be reused as a UI component
        NSLayoutConstraint.activate([
            signOutButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            signOutButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            signOutButton.widthAnchor.constraint(equalToConstant: 200),
            signOutButton.heightAnchor.constraint(equalToConstant: 50)
        ])

            signOutButton.addTarget(self, action: #selector(signOutTapped), for: .touchUpInside)
    }

    @objc private func signOutTapped() {
        delegate?.didTapSignOut()
    }
}

//The SignOutUIViewRepresentable, contains the UIKit SignOutView
//this extra layer is needed to use UIKit Views with SwiftUI
struct SignOutUIViewRepresentable: UIViewRepresentable {
    
    //the coordinator is necessary to receive updates from the UIView
    //in this case I need to know if the user clicked the SignOut Button
    //so I can trigger the actual signout functions.
    class Coordinator: NSObject, SignOutViewDelegate {
        var parent: SignOutUIViewRepresentable

        init(parent: SignOutUIViewRepresentable) {
            self.parent = parent
        }

        func didTapSignOut() {
            parent.onSignOut()
        }
    }

    //the actual signout functionality is handled by AuthController
    var onSignOut: () -> Void

    //creates and configures SignOutView
    func makeUIView(context: Context) -> SignOutView {
        let signOutView = SignOutView()
        //eseentially telling the view's delegate to report all updates to our coordinator
        //also it is important that our coordinator conforms to the same protocol as signOutView's delegate, which it does
        signOutView.delegate = context.coordinator
        return signOutView
    }

//I have no need to make updates to the UIView, but it's needed for this view to conform to UIViewRepresentable
    func updateUIView(_ uiView: SignOutView, context: Context) {
    }
//creating the coordinator, is called automiatlcaly by
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}

