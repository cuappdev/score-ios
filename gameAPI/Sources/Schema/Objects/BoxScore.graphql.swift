// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension Objects {
  /// Represents an individual entry in the box score of a game.
  ///
  /// Attributes:
  ///     - `team`: The team involved in the scoring event.
  ///     - `period`: The period or inning of the event.
  ///     - `time`: The time of the scoring event.
  ///     - `description`: A description of the play or scoring event.
  ///     - `scorer`: The name of the scorer.
  ///     - `assist`: The name of the assisting player.
  ///     - `score_by`: Indicates which team scored.
  ///     - `cor_score`: Cornell's score at the time of the event.
  ///     - `opp_score`: Opponent's score at the time of the event.
  static let BoxScore = ApolloAPI.Object(
    typename: "BoxScore",
    implementedInterfaces: []
  )
}