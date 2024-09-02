import Foundation
@testable import True_Weather

class MockLocationService: LocationServiceProtocol {

    var requestAuthorizationCalled = false
    var isAuthorizedBool = false
    var requestLocationOnceCalled = false

    func requestAuthorization() {
        requestAuthorizationCalled = true
    }

    func isAuthorized() -> Bool {
        isAuthorizedBool
    }

    func requestLocationOnce() {
        requestLocationOnceCalled = true
    }
}
