//
//  Game.swift
//  score-ios
//
//  Created by Daniel on 9/11/24.
//

import SwiftUI
import GameAPI

protocol GameType : Identifiable where ID == UUID {
    // On Card and Details
    var opponent: Team { get }
    var city: String { get }
    var state: String { get }
    var date: Date { get }
    var sport: Sport { get }
    var sex: Sex { get }
    
    // On Details
    // TODO add more, maybe longitude and latitude for Transit integration? Idk
    var address: String { get }
    
    // TODO: game score details

    var timeUpdates: [TimeUpdate] { get }
    var gameUpdates: [GameUpdate] { get }
}

struct Game : GameType, Identifiable {
    var id: UUID = UUID()
    var opponent: Team
    var city: String
    var state: String
    var date: Date
    var sport: Sport
    var address: String
    var sex: Sex
    var timeUpdates: [TimeUpdate] = []
    var gameUpdates: [GameUpdate] = []
    
    enum CodingKeys: String, CodingKey {
            case id, city, state, date, sport, gender, location, opponentId, result, time, scoreBreakdown, boxScore
    }
    
    init(game: GamesQuery.Data.Game) {
        self.city = game.city
        self.state = game.state
        self.date = Game.parseDate(dateString: game.date, timeString: game.time ?? "12:00 p.m.")
        self.sex = game.gender == "Mens" ? .Men : .Women
//        self.sport = Sport(rawValue: game.sport) ?? .All
        self.sport = Sport(normalizedValue: game.sport) ?? .All
        self.opponent = Team.defaultTeam()
        self.address = game.location ?? "N/A"
        self.timeUpdates = parseScoreBreakdown(game.scoreBreakdown)
        self.gameUpdates = parseBoxScore(decodeBoxScoreArray(boxScores: game.boxScore))
    }
    
    // initializer with provided arguments
    init(
            opponent: Team,
            city: String,
            state: String,
            date: Date,
            sport: Sport,
            address: String?,
            sex: Sex,
            timeUpdates: [TimeUpdate],
            gameUpdates: [GameUpdate]
        ) {
            self.opponent = opponent
            self.city = city
            self.state = state
            self.date = date
            self.sport = sport
            self.address = address ?? ""
            self.sex = sex
            self.timeUpdates = timeUpdates
            self.gameUpdates = gameUpdates
        }
    
}

extension Game {
    // parse score breakdown into TimeUpdate
    mutating func parseScoreBreakdown(_ breakdown: [[String?]?]?) -> [TimeUpdate] {
            var updates: [TimeUpdate] = []
            // Parse breakdown and map into `TimeUpdate` array
            // [["1", "2"], ["2", "3"]]
        
        if (breakdown != nil) {
            let scoreBreakDown = breakdown!
            let corScores = scoreBreakDown[0]
            let oppScores = scoreBreakDown[1]
            var corTotal = 0
            var oppTotal = 0
            if (corScores != nil && oppScores != nil) {
                corScores!.indices.forEach({ index in
                    let timeStamp = index+1
                    if (corScores![index] != nil && oppScores![index] != nil) {
                        let corScore = Int(corScores![index]!) ?? 0
                        let oppScore = Int(oppScores![index]!) ?? 0
                        let timeUpdate = TimeUpdate(timestamp: timeStamp, isTotal: false, cornellScore: corScore, opponentScore: oppScore)
                        corTotal += corScore
                        oppTotal += oppScore
                        updates.append(timeUpdate)
                    }
                    if (index == corScores!.count - 1) {
                        let total = TimeUpdate(timestamp: index + 1, isTotal: true, cornellScore: corTotal, opponentScore: oppTotal)
                        updates.append(total)
                    }
                })
            }
        }
            return updates
        }

    mutating func parseBoxScore(_ boxScore: [BoxScoreItem]) -> [GameUpdate] {
        var updates: [GameUpdate] = []
        // Parse boxScore and map into `GameUpdate` array
        
        for entry in boxScore {
            let team = entry.team
            let period = entry.period
            let description = entry.description
            let time = entry.time ?? "N/A"
            let corScore = entry.corScore
            let oppScore = entry.oppScore
            
            let timestamp: Int
            if period == "1st" {
                timestamp = 1
            } else if period == "2nd" {
                timestamp = 2
            } else if let parsed = Int(period.dropLast(2)) {
                timestamp = parsed
            } else {
                // Invalid period
                timestamp = -1
            }
            
            let isCornell = team == "COR"
            let eventParty = EventParty(team: team)
            
            let gameUpdate = GameUpdate(timestamp: timestamp, isTotal: false, cornellScore: corScore, opponentScore: oppScore, time: time, isCornell: isCornell, eventParty: eventParty, description: description)
            
            updates.append(gameUpdate)
        }
        
        return updates
    }
    
    // update the opponent team
    func fetchAndUpdateOpponent(opponentId: String, completion: @escaping (Game) -> Void) {
            fetchOpponentTeam(id: opponentId) { team in
                DispatchQueue.main.async {
                    var updatedGame = self
                    updatedGame.opponent = team ?? Team.defaultTeam()
                    completion(updatedGame)
                }
        }
    }
    
    static func parseDate(dateString: String, timeString: String) -> Date {
        // parse the date without year
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d (EEE)" // Matches "Feb 23 (Fri)"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures consistent parsing
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // Adjust timezone if necessary
        let parsedDate = dateFormatter.date(from: dateString) ?? Date()
        
        // parse the time
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a" // Matches "4:00 p.m."
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        timeFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let parsedTime = timeFormatter.date(from: timeString) ?? Date()
        
        // get the current year
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        // set the year of the parsed date to the current year
        // Set the year of the parsed date to the current year
        var dateComponents = calendar.dateComponents([.month, .day], from: parsedDate)
        dateComponents.year = currentYear
        let timeComponents = calendar.dateComponents([.hour, .minute], from: parsedTime)
        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute

        // returns the date with the year set to the current year, callback to current date if parsing fails
        return calendar.date(from: dateComponents) ?? Date()
    }
}

struct TimeUpdate {
    var id: UUID = UUID()
    var timestamp: Int
    var isTotal: Bool
    var cornellScore: Int
    var opponentScore: Int
}

// for decoding a boxScore from backend
struct BoxScoreItem: Decodable {
    let team: String
    let period: String
    let time: String?
    let description: String
    let scorer: String?
    let assist: String?
    let scoreBy: String?
    let corScore: Int
    let oppScore: Int
    
    init(item: GamesQuery.Data.Game.BoxScore?) {
        if let item = item {
            self.team = item.team ?? ""
            self.period = item.period ?? ""
            self.time = item.time ?? ""
            self.description = item.description ?? "N/A"
            self.scorer = item.scorer ?? ""
            self.assist = item.assist ?? ""
            self.scoreBy = item.scoreBy ?? ""
            self.corScore = item.corScore ?? 0
            self.oppScore = item.oppScore ?? 0
        } else {
            self.team = ""
            self.period = ""
            self.time = ""
            self.description = "N/A"
            self.scorer = ""
            self.assist = ""
            self.scoreBy = ""
            self.corScore = 0
            self.oppScore = 0
        }
    }
}

func decodeBoxScoreArray(boxScores: [GamesQuery.Data.Game.BoxScore?]?) -> [BoxScoreItem] {
    var result: [BoxScoreItem] = []
    if let boxScores = boxScores {
        for score in boxScores {
            if score != nil {
                result.append(BoxScoreItem(item: score))
            }
        }
    }
    return result
}

func fetchOpponentTeam(id: String, completion: @escaping (Team?) -> Void) {
    NetworkManager.shared.fetchTeamById(by: id) { team, error in
        if let result = team {
            completion(Team(team: result))
        } else if let error = error {
//            print("Error in fetchOpponentTeam: \(error.localizedDescription)")
            completion(nil)
        }
    }
}

struct Team {
    var id: String
    var color: String
    var image: String
    var name: String
    
    init(team: GetTeamByIdQuery.Data.Team) {
        self.id = team.id ?? "N/A"
        self.color = team.color
        self.image = team.image ?? "DEFAULT IMAGE URL" // TODO: make a defualt image url
        self.name = team.name
    }
    
    init(id: String, color: String, image: String, name: String) {
        self.id = id
        self.color = color
        self.image = image
        self.name = name
    }
}

extension Team {
    static func defaultTeam() -> Team {
        return Team(id: "N/A", color: "gray", image: "default_image_url", name: "Unknown")
    }
}

struct GameUpdate : Hashable {
    var id: UUID = UUID() // discard
    var timestamp: Int // period
    var isTotal: Bool // discard
    var cornellScore: Int // corScore
    var opponentScore: Int // oppScore
    var time: String // time
    var isCornell: Bool //
    var eventParty: EventParty // team
    var description: String // description
}

enum EventParty {
    case Cornell
    case Neither
    case Opponent
    
    init(team: String?) {
        switch team {
            case "COR":
                self = .Cornell
            default:
                self = .Opponent
        }
    }
}

// Enums for various types
enum Opponent : String {
    case Penn
    case Princeton
    case Harvard
    case Yale
    case Brown
    case Dartmouth
    case Columbia
}

enum Sport : String, Identifiable, CaseIterable, CustomStringConvertible {
    // https://health.cornell.edu/services/sports-medicine/sports-clearance/ncaa-teams
    var id: Self { self }
    
    case All
    
    // Both
    case Basketball
    case CrossCountry
    case IceHockey
    case Lacrosse
    case Soccer
    case Squash
    case SwimmingDiving
    case Tennis
    case TrackField
    
    // Women
    case Fencing
    case FieldHockey
    case Gymnastics
    case Rowing
    case Sailing
    case Softball
    case Volleyball
    
    // Men
    case Baseball
    case Football
    case Golf
    case RowingHeavyweight
    case RowingLightweight
    case SprintFootball
    case Wrestling
    
    // init from a string from backend (might include spaces)
    init?(normalizedValue: String) {
        // Normalize the input by removing spaces and making it case insensitive
        let cleanedValue = normalizedValue.replacingOccurrences(of: " ", with: "").lowercased()
        for sport in Sport.allCases {
            if sport.rawValue.lowercased() == cleanedValue {
                self = sport
                return
            }
        }
        return nil
    }
    
    // Make a to string function
    var description: String {
        switch self {
        case .All:
            return "All"
        case .Basketball:
            return "Basketball"
        case .CrossCountry:
            return "Cross Country"
        case .IceHockey:
            return "Ice Hockey"
        case .Lacrosse:
            return "Lacrosse"
        case .Soccer:
            return "Soccer"
        case .Squash:
            return "Squash"
        case .SwimmingDiving:
            return "Swimming"
        case .Tennis:
            return "Tennis"
        case .TrackField:
            return "Track and Field"
        case .Fencing:
            return "Fencing"
        case .FieldHockey:
            return "Field Hockey"
        case .Gymnastics:
            return "Gymnastics"
        case .Rowing:
            return "Rowing"
        case .Sailing:
            return "Sailing"
        case .Softball:
            return "Softball"
        case .Volleyball:
            return "Volleyball"
        case .Baseball:
            return "Baseball"
        case .Football:
            return "Football"
        case .Golf:
            return "Golf"
        case .RowingHeavyweight:
            return "HW Rowing"
        case .RowingLightweight:
            return "LW Rowing"
        case .SprintFootball:
            return "Sprint Football"
        case .Wrestling:
            return "Wrestling"
        }
    }
}

enum Sex : Identifiable, CaseIterable, CustomStringConvertible {
    var id: Self { self }
    
    case Both
    case Men
    case Women
    
    var description: String {
        switch self {
        case .Both:
            return "All"
        case .Men:
            return "Men's"
        case .Women:
            return "Women's"
        }
    }
    
    var filterDescription: String {
        switch self {
        case .Both:
            return "All"
        case .Men:
            return "Mens"
        case .Women:
            return "Womens"
        }
    }
    // This is strictly for filtering purposes, all datum should have one of Men or Women
    static func index(of sex: Sex) -> Int? {
        return allCases.firstIndex(of: sex)
    }
}

// TEMP Dummy data
extension Game {
    static let dummyData: [Game] = [
        Game(opponent:  Team(id: "673d2c20569abe4465e9f792", color: "blue", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Cornell_University_seal.svg/1200px-Cornell_University_seal.svg.png", name: "Cornell"), city: "Pennsylvania", state: "PA", date: Date.dateComponents(year: 2024, month: 12, day: 6, hour: 14, minute: 0), sport: .Basketball, address: "0 Fake St", sex: .Men, timeUpdates: [], gameUpdates: []),
        Game(opponent:  Team(id: "673d2c20569abe4465e9f792", color: "blue", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Cornell_University_seal.svg/1200px-Cornell_University_seal.svg.png", name: "Cornell"), city: "Pennsylvania", state: "PA", date: Date.dateComponents(year: 2024, month: 12, day: 6, hour: 14, minute: 0), sport: .Basketball, address: "0 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: true, cornellScore: 10, opponentScore: 7, time: "05/19/2023", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD"), GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2023", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent:  Team(id: "673d2c20569abe4465e9f792", color: "blue", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Cornell_University_seal.svg/1200px-Cornell_University_seal.svg.png", name: "Cornell"), city: "Cambridge", state: "MA", date: Date.dateComponents(year: 2024, month: 5, day: 21, hour: 10, minute: 0), sport: .Football, address: "1 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent:  Team(id: "673d2c20569abe4465e9f792", color: "blue", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Cornell_University_seal.svg/1200px-Cornell_University_seal.svg.png", name: "Cornell"), city: "Princeton", state: "NJ", date: Date.dateComponents(year: 2024, month: 5, day: 20, hour: 10, minute: 0), sport: .Basketball, address: "2 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent:  Team(id: "673d2c20569abe4465e9f792", color: "blue", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Cornell_University_seal.svg/1200px-Cornell_University_seal.svg.png", name: "Cornell"), city: "New Haven", state: "CT", date: Date.dateComponents(year: 2024, month: 5, day: 22, hour: 10, minute: 0), sport: .Soccer, address: "3 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent:  Team(id: "673d2c20569abe4465e9f792", color: "blue", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Cornell_University_seal.svg/1200px-Cornell_University_seal.svg.png", name: "Cornell"), city: "Providence", state: "RI", date: Date.dateComponents(year: 2024, month: 5, day: 23, hour: 10, minute: 0), sport: .CrossCountry, address: "4 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent:  Team(id: "673d2c20569abe4465e9f792", color: "blue", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Cornell_University_seal.svg/1200px-Cornell_University_seal.svg.png", name: "Cornell"), city: "Hanover", state: "NH", date: Date.dateComponents(year: 2024, month: 5, day: 24, hour: 10, minute: 0), sport: .IceHockey, address: "5 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent:  Team(id: "673d2c20569abe4465e9f792", color: "blue", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Cornell_University_seal.svg/1200px-Cornell_University_seal.svg.png", name: "Cornell"), city: "New York", state: "NY", date: Date.dateComponents(year: 2024, month: 5, day: 25, hour: 10, minute: 0), sport: .Lacrosse, address: "6 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        
        Game(opponent:  Team(id: "673d2c20569abe4465e9f792", color: "blue", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Cornell_University_seal.svg/1200px-Cornell_University_seal.svg.png", name: "Cornell"), city: "Pennsylvania", state: "PA", date: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 10, minute: 0), sport: .Basketball, address: "0 Fake St", sex: .Men, timeUpdates: [], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent:  Team(id: "673d2c20569abe4465e9f792", color: "blue", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Cornell_University_seal.svg/1200px-Cornell_University_seal.svg.png", name: "Cornell"), city: "Cambridge", state: "MA", date: Date.dateComponents(year: 2024, month: 5, day: 21, hour: 10, minute: 0), sport: .Football, address: "1 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent:  Team(id: "673d2c20569abe4465e9f792", color: "blue", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Cornell_University_seal.svg/1200px-Cornell_University_seal.svg.png", name: "Cornell"), city: "Princeton", state: "NJ", date: Date.dateComponents(year: 2024, month: 5, day: 20, hour: 10, minute: 0), sport: .Basketball, address: "2 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent:  Team(id: "673d2c20569abe4465e9f792", color: "blue", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Cornell_University_seal.svg/1200px-Cornell_University_seal.svg.png", name: "Cornell"), city: "New Haven", state: "CT", date: Date.dateComponents(year: 2024, month: 5, day: 22, hour: 10, minute: 0), sport: .Soccer, address: "3 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent:  Team(id: "673d2c20569abe4465e9f792", color: "blue", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Cornell_University_seal.svg/1200px-Cornell_University_seal.svg.png", name: "Cornell"), city: "Providence", state: "RI", date: Date.dateComponents(year: 2024, month: 5, day: 23, hour: 10, minute: 0), sport: .CrossCountry, address: "4 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent:  Team(id: "673d2c20569abe4465e9f792", color: "blue", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Cornell_University_seal.svg/1200px-Cornell_University_seal.svg.png", name: "Cornell"), city: "Hanover", state: "NH", date: Date.dateComponents(year: 2024, month: 5, day: 24, hour: 10, minute: 0), sport: .IceHockey, address: "5 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent:  Team(id: "673d2c20569abe4465e9f792", color: "blue", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Cornell_University_seal.svg/1200px-Cornell_University_seal.svg.png", name: "Cornell"), city: "New York", state: "NY", date: Date.dateComponents(year: 2024, month: 5, day: 25, hour: 10, minute: 0), sport: .Lacrosse, address: "6 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")])
    ]
//    static let dummyData: [Game] = [
//        Game(opponent: "Penn", city: "Pennsylvania", state: "PA", date: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 10, minute: 0), sport: .Basketball, address: "0 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
//        Game(opponent: "Harvard", city: "Cambridge", state: "MA", date: Date.dateComponents(year: 2024, month: 5, day: 21, hour: 10, minute: 0), sport: .Football, address: "1 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
//        Game(opponent: "Princeton", city: "Princeton", state: "NJ", date: Date.dateComponents(year: 2024, month: 5, day: 20, hour: 10, minute: 0), sport: .Basketball, address: "2 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
//        Game(opponent: "Yale", city: "New Haven", state: "CT", date: Date.dateComponents(year: 2024, month: 5, day: 22, hour: 10, minute: 0), sport: .Soccer, address: "3 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
//        Game(opponent: "Brown", city: "Providence", state: "RI", date: Date.dateComponents(year: 2024, month: 5, day: 23, hour: 10, minute: 0), sport: .CrossCountry, address: "4 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
//        Game(opponent: "Dartmouth", city: "Hanover", state: "NH", date: Date.dateComponents(year: 2024, month: 5, day: 24, hour: 10, minute: 0), sport: .IceHockey, address: "5 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
//        Game(opponent: "Columbia", city: "New York", state: "NY", date: Date.dateComponents(year: 2024, month: 5, day: 25, hour: 10, minute: 0), sport: .Lacrosse, address: "6 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
//        
//        Game(opponent: "Penn", city: "Pennsylvania", state: "PA", date: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 10, minute: 0), sport: .Basketball, address: "0 Fake St", sex: .Men, timeUpdates: [], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
//        Game(opponent: "Harvard", city: "Cambridge", state: "MA", date: Date.dateComponents(year: 2024, month: 5, day: 21, hour: 10, minute: 0), sport: .Football, address: "1 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
//        Game(opponent: "Princeton", city: "Princeton", state: "NJ", date: Date.dateComponents(year: 2024, month: 5, day: 20, hour: 10, minute: 0), sport: .Basketball, address: "2 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
//        Game(opponent: "Yale", city: "New Haven", state: "CT", date: Date.dateComponents(year: 2024, month: 5, day: 22, hour: 10, minute: 0), sport: .Soccer, address: "3 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
//        Game(opponent: "Brown", city: "Providence", state: "RI", date: Date.dateComponents(year: 2024, month: 5, day: 23, hour: 10, minute: 0), sport: .CrossCountry, address: "4 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
//        Game(opponent: "Dartmouth", city: "Hanover", state: "NH", date: Date.dateComponents(year: 2024, month: 5, day: 24, hour: 10, minute: 0), sport: .IceHockey, address: "5 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
//        Game(opponent: "Columbia", city: "New York", state: "NY", date: Date.dateComponents(year: 2024, month: 5, day: 25, hour: 10, minute: 0), sport: .Lacrosse, address: "6 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")])
//    ]
}

