// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetAllGamesQuery: GraphQLQuery {
  public static let operationName: String = "GetAllGames"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetAllGames { games { __typename id city date gender opponentId result sport state time location } }"#
    ))

  public init() {}

  public struct Data: GameAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { GameAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("games", [Game?]?.self),
    ] }

    public var games: [Game?]? { __data["games"] }

    /// Game
    ///
    /// Parent Type: `GameType`
    public struct Game: GameAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { GameAPI.Objects.GameType }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", String?.self),
        .field("city", String.self),
        .field("date", String.self),
        .field("gender", String.self),
        .field("opponentId", String.self),
        .field("result", String?.self),
        .field("sport", String.self),
        .field("state", String.self),
        .field("time", String?.self),
        .field("location", String?.self),
      ] }

      public var id: String? { __data["id"] }
      public var city: String { __data["city"] }
      public var date: String { __data["date"] }
      public var gender: String { __data["gender"] }
      public var opponentId: String { __data["opponentId"] }
      public var result: String? { __data["result"] }
      public var sport: String { __data["sport"] }
      public var state: String { __data["state"] }
      public var time: String? { __data["time"] }
      public var location: String? { __data["location"] }
    }
  }
}