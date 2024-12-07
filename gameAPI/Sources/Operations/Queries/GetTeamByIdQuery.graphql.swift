// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetTeamByIdQuery: GraphQLQuery {
  public static let operationName: String = "GetTeamById"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetTeamById($id: String!) { team(id: $id) { __typename id color image name } }"#
    ))

  public var id: String

  public init(id: String) {
    self.id = id
  }

  public var __variables: Variables? { ["id": id] }

  public struct Data: GameAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { GameAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("team", Team?.self, arguments: ["id": .variable("id")]),
    ] }

    public var team: Team? { __data["team"] }

    /// Team
    ///
    /// Parent Type: `TeamType`
    public struct Team: GameAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { GameAPI.Objects.TeamType }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", String?.self),
        .field("color", String.self),
        .field("image", String?.self),
        .field("name", String.self),
      ] }

      public var id: String? { __data["id"] }
      public var color: String { __data["color"] }
      public var image: String? { __data["image"] }
      public var name: String { __data["name"] }
    }
  }
}
