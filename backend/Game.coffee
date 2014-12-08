_ = require('lodash')
uuid = require('uuid')
fs = require('fs')

module.exports = class Game
  @games = {}
  @openGameId = null

  @_capitalize: (word) ->
    word[0].toUpperCase() + word[1..-1].toLowerCase()

  @adjectives = (@_capitalize(word) for word in fs.readFileSync('adjectives', {'encoding': 'utf-8'}).trim().split('\n'))
  @animals = (@_capitalize(word) for word in fs.readFileSync('animals', {'encoding': 'utf-8'}).trim().split('\n'))


  @_generateGameId: ->
    @_getAdjective() + @_getAdjective() + @_getAnimal()

  @_getAdjective: ->
    @adjectives[Math.floor(Math.random() * @adjectives.length)]

  @_getAnimal: ->
    @animals[Math.floor(Math.random() * @animals.length)]

  @getById: (id) ->
    @games[id]

  @resetOpenGame: ->
    @openGameId = @_generateGameId()
    @games[@openGameId] = new Game()

  @createPrivateGame: ->
    gameId = @_generateGameId()
    @games[gameId] = new Game()
    return gameId

  constructor: ->
    @moves = []
    @rand = Math.random()
    @subscribers = []

  # Push a move onto the game's move log and update all subscribers.
  pushMove: (move, agentId, time = Math.round(Date.now() / 10) ) ->
    move.agentId = agentId
    move.t = time
    @moves.push(move)
    @_updateAllSubscribers()

  # Register a subscriber with an id and a callback, and send an initial update
  # to that subscriber.
  subscribe: (id, callback) ->
    subscriber = {id, callback}
    @subscribers.push(subscriber)
    @_updateSubscriber(subscriber)

  # Deregister the subscriber with the given id.
  unsubscribe: (id) ->
    @subscribers = _.reject(@subscribers, (s) -> s.id == id)

  # Send an update to the given subscriber.
  _updateSubscriber: (subscriber) ->
    data = {moves: @moves, rand: @rand, currentTime: Math.round(Date.now() / 10)}
    subscriber.callback(data)

  # Send an update to all subscribers.
  _updateAllSubscribers: ->
    @_updateSubscriber(sub) for sub in @subscribers
