React = require('react/addons')
_     = require('underscore')
game  = require('../game_client.coffee')

module.exports = React.createClass(
  gameCanStart: ->
    @props.data.game.teams[0].players.length > 0 && 
    @props.data.game.teams[1].players.length > 0

  startGame: ->
    game.start()

  render: ->
    teams = @props.data.game.teams.map (team) -> team.players.map (player) ->
      <li key={player.id}>{player.name}</li>

    <div className="row">
      <div className="col-sm-push-3 col-sm-6">
        <div className="row">

          <div className="col-sm-6">
            <h2>Team 1</h2>
            <ul>{teams[0]}</ul>
          </div>
          <div className="col-sm-6">
            <h2>Team 2</h2>
            <ul>{teams[1]}</ul>
          </div>

        </div>

        <div className="row">
          <div className="col-sm-12">
            <button
              disabled={!@gameCanStart()}
              className="btn btn-primary btn-lg"
              onClick={@startGame}
              >
              Start game
            </button>
          </div>
        </div>

      </div>
    </div>
)