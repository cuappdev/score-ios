// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GamesQuery: GraphQLQuery {
  public static let operationName: String = "Games"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Games { games { __typename id city date gender location opponentId result sport state time scoreBreakdown boxScore { __typename team period time description scorer assist scoreBy corScore oppScore } } }"#
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
        .field("location", String?.self),
        .field("opponentId", String.self),
        .field("result", String?.self),
        .field("sport", String.self),
        .field("state", String.self),
        .field("time", String?.self),
        .field("scoreBreakdown", [[String?]?]?.self),
        .field("boxScore", [BoxScore?]?.self),
      ] }

      public var id: String? { __data["id"] }
      public var city: String { __data["city"] }
      public var date: String { __data["date"] }
      public var gender: String { __data["gender"] }
      public var location: String? { __data["location"] }
      public var opponentId: String { __data["opponentId"] }
      public var result: String? { __data["result"] }
      public var sport: String { __data["sport"] }
      public var state: String { __data["state"] }
      public var time: String? { __data["time"] }
      public var scoreBreakdown: [[String?]?]? { __data["scoreBreakdown"] }
      public var boxScore: [BoxScore?]? { __data["boxScore"] }

      /// Game.BoxScore
      ///
      /// Parent Type: `BoxScore`
      public struct BoxScore: GameAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { GameAPI.Objects.BoxScore }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("team", String?.self),
          .field("period", String?.self),
          .field("time", String?.self),
          .field("description", String?.self),
          .field("scorer", String?.self),
          .field("assist", String?.self),
          .field("scoreBy", String?.self),
          .field("corScore", Int?.self),
          .field("oppScore", Int?.self),
        ] }

        public var team: String? { __data["team"] }
        public var period: String? { __data["period"] }
        public var time: String? { __data["time"] }
        public var description: String? { __data["description"] }
        public var scorer: String? { __data["scorer"] }
        public var assist: String? { __data["assist"] }
        public var scoreBy: String? { __data["scoreBy"] }
        public var corScore: Int? { __data["corScore"] }
        public var oppScore: Int? { __data["oppScore"] }
      }
    }
  }
}
