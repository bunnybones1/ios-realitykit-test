/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Hosts the main game phases for Joyride and Work.
*/

import SwiftUI
import RealityKit

@MainActor
struct ImmersiveView: View {

    @Environment(AppModel.self) private var appModel

    @State private var viewModel = ImmersiveViewModel()

    var body: some View {

        RealityView { content in
            content.add(viewModel.rootEntity)

            // Handle collisions
            _ = content.subscribe(to: CollisionEvents.Began.self, viewModel.handleCollisionBegan(_:))

#if os(visionOS) && !targetEnvironment(simulator)
            HandsShipControlProviderSystem.registerSystem()
            viewModel.rootEntity.addChild(Entity.makeHandTrackingEntities())
#endif
            Gravity.register()

#if os(iOS)
            // MARK: On iOS, set up RealityView to use AR world tracking
            await content.setupWorldTracking()
            content.camera = .worldTracking
#endif
        }
#if os(visionOS)
        .onChange(of: appModel.surroundings, initial: true) { old, new in
            Task {
                appModel.updateImmersion()
                appModel.isTransitioningBetweenSurroundings = true
                try await viewModel.transitionSurroundings(from: old, to: new)
                appModel.isTransitioningBetweenSurroundings = false
            }
        }
#endif
    }
}
