# Score

<p align="center"><img src="https://github.com/user-attachments/assets/d3025ab3-ce0b-4f83-852b-343627154fd8" width=150 /></p>

Score is Cornell’s all-in-one sports discovery hub that makes Cornell sports easily accessible and engaging for the entire community. A free and open-source app, Score helps facilitate the seamless discovery, tracking, and engagement of Cornell sports, allowing students to conveniently stay informed on sports games and feel motivated to actively participate in the campus sports culture. 


## Getting Started

1. Clone the repository.
2. Download and uncompress the `ScoreSecrets/` folder, which AppDev members can find it pinned in the `#score-ios` Slack channel. Once done, drag the following folder into the root of the project through **FINDER (NOT Xcode)**. The folder should contain the following files:
   - `GoogleService-Info.plist`
   - `Keys.plist`
3. To generate the Apollo API, in the root of the project directory run the following commands.
   
   Dev:
   ```
   ./apollo-ios-cli generate -p "ScoreSecrets/apollo-codegen-config-dev.json" -f
   ```
   Prod:
   ```
   ./apollo-ios-cli generate -p "ScoreSecrets/apollo-codegen-config-prod.json" -f
   ```
   
5. Build the project and you should be good to go! Select the `score-ios` schema to use our development server and `score-ios-prod` to use our production server.

## Common Issues

- If you're unable to reproduce a new Apollo generated API folder (i.e. missing package errors), add the gameAPI folder as a package dependency. Go to File -> Add Package Dependencies -> Add Local -> select the folder
  - The .zip folder can also found pinned in the `#score-ios` Slack channel.
