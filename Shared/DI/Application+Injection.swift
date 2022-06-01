//
//  Application+Injection.swift
//  AsyncProducers (iOS)
//
//  Created by Borja Arias Drake on 04.05.2022..
//

import Foundation
import Resolver
import SwiftUI

enum Environment {
    case developent, production, testing
}

@MainActor
extension Resolver: ResolverRegistering {
    private static var environment: Environment = .developent
    private static let sharedContainer = Resolver(child: nil)
    private static let productionContainer = Resolver(child: sharedContainer)
    private static let developmentContainer = Resolver(child: sharedContainer)
    private static let testingContainer = Resolver(child: sharedContainer)

    public static func registerAllServices() {
        switch Resolver.environment {
        case .developent:
            Self.setupForDevelopment()
        case .testing:
            Self.setupForTesting()
        case .production:
            Self.setupForProduction()
        }
    }

    private static func setupSharedContainer() {
        sharedContainer.register { _ -> AnyGridViewPresenter in
            let N = 50
            let producers = [ColorProducer(maxRow: N,
                                           maxCol: N,
                                           color: Color("Blue"),
                                           count: 9_000_000,
                                           updateInterval: 0.5),
                             ColorProducer(maxRow: N,
                                           maxCol: N,
                                           color: Color("Green"),
                                           count: 9_000_000,
                                           updateInterval: 0.5),
                             ColorProducer(maxRow: N,
                                           maxCol: N,
                                           color: Color("HighlighterPink"),
                                           count: 9000,
                                           updateInterval: 0.5),
                             ColorProducer(maxRow: N,
                                           maxCol: N,
                                           color: Color("Purple"),
                                           count: 9_000_000,
                                           updateInterval: 0.5),
                             ColorProducer(maxRow: N,
                                           maxCol: N,
                                           color: Color("Pink"),
                                           count: 9_000_000,
                                           updateInterval: 1.1)]
            let serializer = ImageAccessSerializer(rowCount: N, colCount: N)
            return AnyGridViewPresenter(concrete: GridViewDefaultPresenter(process: PaintingProcess(producers: producers, serializer: serializer), n: N))
        }
    }

    private static func setupForDevelopment() {
        Resolver.reset()
        Self.setupSharedContainer()
        Resolver.root = developmentContainer
    }

    private static func setupForTesting() {
        Resolver.reset()
        Self.setupSharedContainer()
        Resolver.root = testingContainer
    }

    private static func setupForProduction() {
        Resolver.reset()
        Self.setupSharedContainer()
        Resolver.root = productionContainer
    }
}

extension Resolver {
    typealias AsyncResolverFactory<Service> = () async -> Service?

    final func asyncRegister<Service>(_: Service.Type = Service.self,
                                      name _: Resolver.Name? = nil,
                                      factory: @escaping AsyncResolverFactory<Service>)
    {
        Task {
            let service = await factory()
            Resolver.sharedContainer.register { service }
        }
    }
}
