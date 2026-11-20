//
//  AuthorizationHelper.swift
//  score-ios
//
//  Created by Duru Alaylı on 10/7/26.
//

import Apollo
import ApolloAPI
import Foundation
import GameAPI

struct AuthorizationInterceptor: GraphQLInterceptor {
    func intercept<Request: GraphQLRequest>(
        request: Request,
        next: NextInterceptorFunction<Request>
    ) async throws -> InterceptorResultStream<Request> {
        var request = request
        let key = Request.Operation.operationName == RefreshAccessTokenMutation.operationName
            ? KeychainHelper.refreshTokenKey
            : KeychainHelper.accessTokenKey
        if let token = KeychainHelper.read(key) {
            request.additionalHeaders["Authorization"] = "Bearer \(token)"
        }
        return await next(request)
    }
}

struct AuthInterceptorProvider: InterceptorProvider {
    func graphQLInterceptors<Operation: GraphQLOperation>(for operation: Operation) -> [any GraphQLInterceptor] {
        DefaultInterceptorProvider.shared.graphQLInterceptors(for: operation) + [AuthorizationInterceptor()]
    }
}
