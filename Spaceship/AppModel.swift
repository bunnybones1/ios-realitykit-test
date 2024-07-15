/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Model data shared by all phases of the app.
*/

import SwiftUI
import RealityKit

@Observable
final class AppModel {


#if os(visionOS)
    var surroundings: Surroundings = .passthrough
    var immersionStyle: ImmersionStyle = .mixed

    func updateImmersion() {
        immersionStyle = surroundings.immersionStyle
    }
#endif
}
