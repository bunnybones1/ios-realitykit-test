/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Collisions related extensions for the ImmersiveViewModel.
*/

import QuartzCore
import RealityKit

extension ImmersiveViewModel {

    func handleCollisionBegan(_ collision: CollisionEvents.Began) {

        guard shouldHandleCollision(collision) else { return }

        Task {
            try await handleGameplay(for: collision)
        }
    }

    func handleGameplay(for collision: CollisionEvents.Began) async throws {

        let entities = UnorderedPair(collision.entityA, collision.entityB)

        guard let spaceship = entities.first(where: { $0 == spaceship }),
            spaceship.components.has(DamageComponent.self)
        else {
            return
        }
        
        guard let other = entities.other(than: spaceship) else {
            return
        }

    }


    func shouldHandleCollision(_ collision: CollisionEvents.Began) -> Bool {
        // If the given pair of entities has collided too recently, wait until enough time has
        // passed to commit resources to handling collision.
        let entities = UnorderedPair(collision.entityA, collision.entityB)
        let now = CACurrentMediaTime()
        if let reference = debounce[entities] {
            if now - reference < Self.debounceThreshold {
                return false
            }
        }
        debounce[entities] = now
        return true
    }
}
