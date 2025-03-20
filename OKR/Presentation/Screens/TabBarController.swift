//
//  TabBarController.swift
//  OKR
//
//  Created by Zayata Budaeva on 25.02.2025.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    // MARK: - Tab Setup

    private func setupTabs() {
        let requestVC = createNav(
            with: "Заявка",
            image: UIImage(systemName: "doc.text"),
            vc: RequestViewController(
                viewModel: RequestViewModel(
                    sendRequestUseCase: SendRequestUseCase(
                        requestRepository: RequestRepositoryImpl(
                            networkService: NetworkService()
                        )
                    )
                )
            )
        )
        let profileVC = createNav(with: "Профиль", image: UIImage(systemName: "person.crop.circle"), vc: ProfileViewController(
            viewModel: ProfileViewModel(
                logoutUseCase: LogoutUseCase(
                    authRepository: AuthRepositoryImpl()
                ), getInfoUseCase: GetInfoUseCase(userRepository: UserRepositoryImpl())
            )
        )
        )

        self.setViewControllers([requestVC, profileVC], animated: true)
        self.selectedIndex = 0

        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()

            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }

    private func createNav(with title: String, image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: image)
        return nav
    }
}
