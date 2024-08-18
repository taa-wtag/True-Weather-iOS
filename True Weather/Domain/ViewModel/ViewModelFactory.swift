import Foundation
import UIKit

class ViewModelFactory {
    static func initViewModel (for viewController: UIViewController) {
        switch viewController {
        case is CitySearchViewController:
            if let controller = viewController as? CitySearchViewController {
                controller.viewModel = CitySearchViewModel(delegate: controller)
            }
        case is WeatherViewController:
            if let controller = viewController as? WeatherViewController {
                controller.viewModel = WeatherViewModel(delegate: controller)
            }
        case is CityViewController:
            if let controller = viewController as? CityViewController {
                controller.viewModel = CityViewModel(delegate: controller)
            }
        default:
            return
        }
    }
}
