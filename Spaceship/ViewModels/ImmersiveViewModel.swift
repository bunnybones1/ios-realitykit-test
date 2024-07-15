/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
View model for the ImmersiveView.
*/

import ARKit
import RealityKit

@MainActor
final class ImmersiveViewModel {

#if os(visionOS)
    let sceneReconstruction = SceneReconstruction()
    let headTrackingSession = ARKitSession()
    let headTrackingProvider = WorldTrackingProvider()
#endif


    let rootEntity = Entity()
    var spaceship: ModelEntity?

    static var debounceThreshold = 0.05
    var debounce: [UnorderedPair<Entity>: TimeInterval] = [:]


    init() {
        configureRoot()
#if os(visionOS)
        Task {
            try await headTrackingSession.run([headTrackingProvider])
        }
#endif
        
        
        // Create a cube entity
        let mesh = MeshResource.generateBox(size: 0.3)
        let material = SimpleMaterial(color: .blue, isMetallic: true)
        let cubeEntity = ModelEntity(mesh: mesh, materials: [material])
        
        // Create an anchor entity and add the cube entity to it
        let anchorEntity = AnchorEntity(plane: .any)
        anchorEntity.addChild(cubeEntity)
        rootEntity.addChild(anchorEntity)
        
        
        let offsetFromDevice: SIMD3<Float> = [0, 0.75, -0.75]
        anchorEntity.position = offsetFromDevice
        
        // Add the anchor entity to the ARView scene
//        arView.scene.addAnchor(anchorEntity)
    }

    func configureRoot() {
        rootEntity.name = "Root"
    }
}
