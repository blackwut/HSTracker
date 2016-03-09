//
//  TagChanceActions.swift
//  HSTracker
//
//  Created by Benjamin Michotte on 9/03/16.
//  Copyright © 2016 Benjamin Michotte. All rights reserved.
//

import Foundation

class TagChangeActions {

    func findAction(tag: GameTag, _ game: Game, _ id: Int, _ value: Int, _ prevValue: Int) -> (() -> Void)? {
        switch tag {

        case .ZONE:
            return { self.zoneChange(game, id, value, prevValue) }

        case .PLAYSTATE:
            return { self.playstateChange(game, id, value) }

        case .CARDTYPE:
            return { self.cardTypeChange(game, id, value) }

        case .LAST_CARD_PLAYED:
            return { self.lastCardPlayedChange(game, value) }

        case .DEFENDING:
            return { self.defendingChange(game, id, value) }

        case .ATTACKING:
            return { self.attackingChange(game, id, value) }

        case .PROPOSED_DEFENDER:
            return { self.proposedDefenderChange(game, value) }

        case .PROPOSED_ATTACKER:
            return { self.proposedAttackerChange(game, value) }

        case .NUM_MINIONS_PLAYED_THIS_TURN:
            return { self.numMinionsPlayedThisTurnChange(game, value) }

        case .PREDAMAGE:
            return { self.predamageChange(game, id, value) }

        case .NUM_TURNS_IN_PLAY:
            return { self.numTurnsInPlayChange(game, id, value) }

        case .NUM_ATTACKS_THIS_TURN:
            return { self.numAttacksThisTurnChange(game, id, value) }

        case .ZONE_POSITION:
            return { self.zonePositionChange(game, id) }

        case .CARD_TARGET:
            return { self.cardTargetChange(game, id, value) }

        case .EQUIPPED_WEAPON:
            return { self.equippedWeaponChange(game, id, value) }

        case .EXHAUSTED:
            return { self.exhaustedChange(game, id, value) }

        case .CONTROLLER:
            return { self.controllerChange(game, id, prevValue, value) }

        case .FATIGUE:
            return { self.fatigueChange(game, value, id) }

        case .STEP:
            return { self.stepChange(game) }

        case .TURN:
            return { self.turnChange(game) }

        default:
            return nil
        }
    }

    private func lastCardPlayedChange(game: Game, _ value: Int) {
        game.lastCardPlayed = value
    }

    private func defendingChange(game: Game, _ id: Int, _ value: Int) {
        if let entity = game.entities[id] {
            if entity.getTag(.CONTROLLER) == game.opponent.id {
                game.handleDefendingEntity(value == 1 ? game.entities[id] : nil)
            }
        }
    }

    private func attackingChange(game: Game, _ id: Int, _ value: Int) {
        if let entity = game.entities[id] {
            if entity.getTag(.CONTROLLER) == game.player.id {
                game.handleAttackingEntity(value == 1 ? game.entities[id] : nil)
            }
        }
    }

    private func proposedDefenderChange(game: Game, _ value: Int) {
        // Game.instance.OpponentSecrets.ProposedDefenderEntityId = value
    }

    private func proposedAttackerChange(game: Game, _ value: Int) {
        // Game.instance.OpponentSecrets.ProposedAttackerEntityId = value
    }

    private func numMinionsPlayedThisTurnChange(game: Game, _ value: Int) {
        if value <= 0 {
            return
        }
        /*let game = Game.instance
         if game.PlayerEntity.IsCurrentPlayer() {
         game.PlayerMinionPlayed()
         }*/
    }

    private func predamageChange(game: Game, _ id: Int, _ value: Int)
    {
        if value <= 0 {
            return
        }
        /*
         let game = Game.instance
         if game.PlayerEntity.IsCurrentPlayer() {
         game.OpponentDamage(game.Entities[id])
         }
         */
    }

    private func numTurnsInPlayChange(game: Game, _ id: Int, _ value: Int)
    {
        if value <= 0 {
            return
        }
        /*
         let game = Game.instance
         if game.PlayerEntity.IsCurrentPlayer() {
         game.OpponentTurnStart(game.Entities[id])
         }*/
    }

    private func fatigueChange(game: Game, _ value: Int, _ id: Int) {
        if let entity = game.entities[id] {
            let controller = entity.getTag(.CONTROLLER)
            if controller == game.player.id {
                game.playerFatigue(value)
            }
            else if controller == game.opponent.id {
                game.opponentFatigue(value)
            }
        }
    }

    private func controllerChange(game: Game, _ id: Int, _ prevValue: Int, _ value: Int) {
        if prevValue <= 0 {
            return
        }
        if let entity = game.entities[id] {
            if entity.hasTag(.PLAYER_ID) {
                return
            }

            if value == game.player.id {
                if entity.isInZone(.SECRET) {
                    game.opponentStolen(entity, entity.cardId, game.turnNumber())
                }
                else if entity.isInZone(.PLAY) {
                    game.opponentStolen(entity, entity.cardId, game.turnNumber())
                }
            }
            else if value == game.opponent.id {
                if entity.isInZone(.SECRET) {
                    game.opponentStolen(entity, entity.cardId, game.turnNumber())
                }
                else if entity.isInZone(.PLAY) {
                    game.playerStolen(entity, entity.cardId, game.turnNumber())
                }
            }
        }
    }

    private func exhaustedChange(game: Game, _ id: Int, _ value: Int) {
        if value <= 0 {
            return
        }

        if let entity = game.entities[id] {
            if entity.getTag(.CARDTYPE) != CardType.HERO_POWER.rawValue {
                return
            }
            let controller = entity.getTag(.CONTROLLER)
            if controller == game.player.id {
                // gameState.ProposeKeyPoint(HeroPower, id, ActivePlayer.Player)
            }
            else if controller == game.opponent.id {
                // gameState.ProposeKeyPoint(HeroPower, id, ActivePlayer.Opponent)
            }
        }
    }

    private func equippedWeaponChange(game: Game, _ id: Int, _ value: Int) {
        if value != 0 {
            return
        }
        if let entity = game.entities[id] {
            let controller = entity.getTag(.CONTROLLER)
            if controller == game.player.id {
                // gameState.ProposeKeyPoint(WeaponDestroyed, id, ActivePlayer.Player)
            }
            else if controller == game.opponent.id {
                // gameState.ProposeKeyPoint(WeaponDestroyed, id, ActivePlayer.Opponent)
            }
        }
    }

    private func cardTargetChange(game: Game, _ id: Int, _ value: Int)
    {
        if value <= 0 {
            return
        }
        if let entity = game.entities[id] {
            let controller = entity.getTag(.CONTROLLER)
            if controller == game.player.id {
                // gameState.ProposeKeyPoint(PlaySpell, id, ActivePlayer.Player)
            }
            else if controller == game.opponent.id {
                // gameState.ProposeKeyPoint(PlaySpell, id, ActivePlayer.Opponent)
            }
        }
    }

    private func zonePositionChange(game: Game, _ id: Int) {
        if let entity = game.entities[id] {
            let zone = entity.getTag(.ZONE)
            let controller = entity.getTag(.CONTROLLER)
            if zone == Zone.HAND.rawValue {
                if controller == game.player.id {
                    game.zonePositionUpdate(.Player, entity, .HAND, game.turnNumber())
                }
                else if controller == game.opponent.id {
                    game.zonePositionUpdate(.Opponent, entity, .HAND, game.turnNumber())
                }
            }
            else if zone == Zone.PLAY.rawValue
            {
                if controller == game.player.id {
                    game.zonePositionUpdate(.Player, entity, .PLAY, game.turnNumber())
                }
                else if controller == game.opponent.id {
                    game.zonePositionUpdate(.Opponent, entity, .PLAY, game.turnNumber())
                }
            }
        }
    }

    private func numAttacksThisTurnChange(game: Game, _ id: Int, _ value: Int) {
        if value <= 0 {
            return
        }

        if let entity = game.entities[id] {
            let controller = entity.getTag(.CONTROLLER)
            if controller == game.player.id {
                // gameState.ProposeKeyPoint(Attack, id, ActivePlayer.Player)
            }
            else if controller == game.opponent.id {
                // gameState.ProposeKeyPoint(Attack, id, ActivePlayer.Opponent)
            }
        }
    }

    private func turnChange(game: Game) {
        if !game.setupDone || game.playerEntity == nil {
            return
        }
        let activePlayer: PlayerType = game.playerEntity!.hasTag(.CURRENT_PLAYER) ? .Player : .Opponent
        game.turnStart(activePlayer, game.turnNumber())

        if activePlayer == .Player {
            game.playerUsedHeroPower = false
        }
        else {
            game.opponentUsedHeroPower = false
        }
    }

    private func stepChange(game: Game) {
        if game.setupDone || game.entities.first?.1.name != "GameEntity" {
            return
        }

        DDLogVerbose("Game was already in progress.")
        // game.wasInProgress = true
    }

    private func cardTypeChange(game: Game, _ id: Int, _ value: Int) {
        if value == CardType.HERO.rawValue {
            setHeroAsync(game, id)
        }
    }

    private func playstateChange(game: Game, _ id: Int, _ value: Int) {
        if value == PlayState.CONCEDED.rawValue {
            game.concede()
        }

        if (game.gameEnded) {
            return
        }

        if let entity = game.entities[id] where !entity.isPlayer {
            return
        }

        if let value = PlayState(rawValue: value) {
            switch value {
            case .WON:
                game.win()
                game.gameEnd()
                game.gameEnded = true

            case .LOST:
                game.loss()
                game.gameEnd()
                game.gameEnded = true

            case .TIED:
                game.tied()
                game.gameEnd()

            default: break
            }
        }
    }

    private func zoneChange(game: Game, _ id: Int, _ value: Int, _ prevValue: Int) {
        if let entity = game.entities[id] {
            let controller = entity.getTag(.CONTROLLER)
            if let zoneValue = Zone(rawValue: prevValue) {
                switch zoneValue {
                case .DECK:
                    zoneChangeFromDeck(game, id, value, prevValue, controller, entity.cardId)

                case .HAND:
                    zoneChangeFromHand(game, id, value, prevValue, controller, entity.cardId)

                case .PLAY:
                    zoneChangeFromPlay(game, id, value, prevValue, controller, entity.cardId)

                case .SECRET:
                    zoneChangeFromSecret(game, id, value, prevValue, controller, entity.cardId)

                case .CREATED:
                    if !game.setupDone && id <= 68 {
                        simulateZoneChangesFromDeck(game, id, value, entity.cardId)
                    }
                    else {
                        zoneChangeFromOther(game, id, value, prevValue, controller, entity.cardId)
                    }

                case .GRAVEYARD,
                        .SETASIDE,
                        .INVALID,
                        .REMOVEDFROMGAME:
                        zoneChangeFromOther(game, id, value, prevValue, controller, entity.cardId)
                }
            }
        }
    }

    private func simulateZoneChangesFromDeck(game: Game, _ id: Int, _ value: Int, _ cardId: String?) {
        if let entity = game.entities[id] {
            if entity.isHero || entity.isHeroPower || entity.hasTag(.PLAYER_ID) || entity.getTag(.CARDTYPE) == CardType.GAME.rawValue || entity.hasTag(.CREATOR) {
                return
            }

            if value == Zone.DECK.rawValue {
                return
            }

            if id < 68 {
                zoneChangeFromDeck(game, id, Zone.HAND.rawValue, Zone.DECK.rawValue, entity.getTag(.CONTROLLER), cardId)
            }
            else if id == 68 && entity.getTag(.ZONE_POSITION) == 5 {
                zoneChangeFromOther(game, id, Zone.HAND.rawValue, Zone.CREATED.rawValue, entity.getTag(.CONTROLLER), cardId)
            }
            if value == Zone.HAND.rawValue {
                return
            }
            zoneChangeFromHand(game, id, Zone.PLAY.rawValue, Zone.HAND.rawValue, entity.getTag(.CONTROLLER), cardId)
            if value == Zone.PLAY.rawValue {
                return
            }
            zoneChangeFromPlay(game, id, value, Zone.PLAY.rawValue, entity.getTag(.CONTROLLER), cardId)
        }
    }

    private func zoneChangeFromOther(game: Game, _ id: Int, _ value: Int, _ prevValue: Int, _ controller: Int, _ cardId: String?) {
        if let value = Zone(rawValue: value), let entity = game.entities[id] {
            switch value {
            case .PLAY:
                if controller == game.player.id {
                    game.playerCreateInPlay(entity, cardId, game.turnNumber())
                }
                else if controller == game.opponent.id {
                    game.opponentCreateInPlay(entity, cardId, game.turnNumber())
                }

            case .DECK:
                if controller == game.player.id {
                    if game.joustReveals > 0 {
                        break
                    }
                    game.playerGetToDeck(entity, cardId, game.turnNumber())
                }
                if controller == game.opponent.id {

                    if game.joustReveals > 0 {
                        break
                    }
                    game.opponentGetToDeck(entity, game.turnNumber())
                }

            case .HAND:
                if controller == game.player.id {
                    game.playerGet(entity, cardId, game.turnNumber())
                }
                else if controller == game.opponent.id {
                    game.opponentGet(entity, game.turnNumber(), id)
                }

            default:
                DDLogWarn("unhandled zone change (id=\(id)): \(prevValue) -> \(value)")
            }
        }
    }

    private func zoneChangeFromSecret(game: Game, _ id: Int, _ value: Int, _ prevValue: Int, _ controller: Int, _ cardId: String?) {
        if let zoneValue = Zone(rawValue: value), let entity = game.entities[id] {
            switch zoneValue {
            case .SECRET, .GRAVEYARD:
                if controller == game.player.id {
                }
                else if controller == game.opponent.id {
                    game.opponentSecretTrigger(entity, cardId, game.turnNumber(), id)
                }

            default:
                DDLogWarn("unhandled zone change (id=\(id)): \(prevValue) -> \(value)")
            }
        }
    }

    private func zoneChangeFromPlay(game: Game, _ id: Int, _ value: Int, _ prevValue: Int, _ controller: Int, _ cardId: String?) {
        if let zoneValue = Zone(rawValue: value), let entity = game.entities[id] {
            switch zoneValue {
            case .HAND:
                if controller == game.player.id {
                    game.playerBackToHand(entity, cardId, game.turnNumber())
                }
                else if controller == game.opponent.id {
                    game.opponentPlayToHand(entity, cardId, game.turnNumber(), id)
                }

            case .DECK:
                if controller == game.player.id {
                    game.playerPlayToDeck(entity, cardId, game.turnNumber())
                }
                else if controller == game.opponent.id {
                    game.opponentPlayToDeck(entity, cardId, game.turnNumber())
                }

            case .GRAVEYARD:
                if controller == game.player.id {
                    game.playerPlayToGraveyard(entity, cardId, game.turnNumber())
                    /*if let entity = entity where entity.hasTag(.HEALTH) {
                     }*/
                }
                else if controller == game.opponent.id {
                    game.opponentPlayToGraveyard(entity, cardId, game.turnNumber(), game.playerEntity!.isCurrentPlayer)
                    /*if let entity = entity where entity.hasTag(.HEALTH) {
                     }*/
                }

            case .REMOVEDFROMGAME,
                    .SETASIDE:
                    if controller == game.player.id {
                        game.playerRemoveFromPlay(entity, game.turnNumber())
                }
                else if controller == game.opponent.id {
                    game.opponentRemoveFromPlay(entity, game.turnNumber())
                }

            case .PLAY:
                break

            default:
                DDLogWarn("unhandled zone change (id=\(id)): \(prevValue) -> \(value)")
            }
        }
    }

    private func zoneChangeFromHand(game: Game, _ id: Int, _ value: Int, _ prevValue: Int, _ controller: Int, _ cardId: String?) {
        if let zoneValue = Zone(rawValue: value), let entity = game.entities[id] {
            switch zoneValue {
            case .PLAY:
                if controller == game.player.id {
                    game.playerPlay(entity, cardId, game.turnNumber())
                }
                else if controller == game.opponent.id {
                    game.opponentPlay(entity, cardId, entity.getTag(.ZONE_POSITION), game.turnNumber())
                }

            case .REMOVEDFROMGAME, .SETASIDE, .GRAVEYARD:
                if controller == game.player.id {
                    game.playerHandDiscard(entity, cardId, game.turnNumber())
                }
                else if controller == game.opponent.id {
                    game.opponentHandDiscard(entity, cardId, entity.getTag(.ZONE_POSITION), game.turnNumber())
                }

            case .SECRET:
                if controller == game.player.id {
                    game.playerSecretPlayed(entity, cardId, game.turnNumber(), false)
                }
                else if controller == game.opponent.id {
                    game.opponentSecretPlayed(entity, cardId, entity.getTag(.ZONE_POSITION), game.turnNumber(), false, id)
                }

            case .DECK:
                if controller == game.player.id {
                    game.playerMulligan(entity, cardId)
                }
                else if controller == game.opponent.id {
                    game.opponentMulligan(entity, entity.getTag(.ZONE_POSITION))
                }

            default:
                DDLogWarn("unhandled zone change (id=\(id)): \(prevValue) -> \(value)")
            }
        }
    }

    private func zoneChangeFromDeck(game: Game, _ id: Int, _ value: Int, _ prevValue: Int, _ controller: Int, _ cardId: String?) {
        if let zoneValue = Zone(rawValue: value), let entity = game.entities[id] {
            switch zoneValue {
            case .HAND:
                if controller == game.player.id {
                    game.playerDraw(entity, cardId, game.turnNumber())
                }
                else if controller == game.opponent.id {
                    if entity.cardId != nil && !entity.cardId!.isEmpty {
                        entity.cardId = ""
                    }
                    game.opponentDraw(entity, game.turnNumber())
                }

            case .SETASIDE, .REMOVEDFROMGAME:
                if controller == game.player.id {
                    if game.joustReveals > 0 {
                        game.joustReveals--
                        break
                    }
                    game.playerRemoveFromDeck(entity, game.turnNumber())
                }
                else if controller == game.opponent.id {
                    if game.joustReveals > 0 {
                        game.joustReveals--
                        break
                    }
                    game.opponentRemoveFromDeck(entity, game.turnNumber())
                }

            case .GRAVEYARD:
                if controller == game.player.id {
                    game.playerDeckDiscard(entity, cardId, game.turnNumber())
                }
                else if controller == game.opponent.id {
                    game.opponentDeckDiscard(entity, cardId, game.turnNumber())
                }

            case .PLAY:
                if controller == game.player.id {
                    game.playerDeckToPlay(entity, cardId, game.turnNumber())
                }
                else if controller == game.opponent.id {
                    game.opponentDeckToPlay(entity, cardId, game.turnNumber())
                }

            case .SECRET:
                if controller == game.player.id {
                    game.playerSecretPlayed(entity, cardId, game.turnNumber(), true)
                }
                else if controller == game.opponent.id {
                    game.opponentSecretPlayed(entity, cardId, -1, game.turnNumber(), true, id)
                }

            default:
                DDLogWarn("unhandled zone change (id=\(id)): \(prevValue) -> \(value)")
            }
        }
    }

    private func setHeroAsync(game: Game, _ id: Int) {
        DDLogVerbose("Found hero with id \(id)")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            if game.playerEntity == nil {
                DDLogVerbose("Waiting for playerEntity")
                while game.playerEntity == nil {
                    NSThread.sleepForTimeInterval(0.1)
                }
            }
            if let playerEntity = game.playerEntity {
                if game.player.playerClass == nil && id == playerEntity.getTag(GameTag.HERO_ENTITY) {
                    dispatch_async(dispatch_get_main_queue()) {
                        game.setPlayerHero(game.entities[id]!.cardId!)
                    }
                    return
                }
            }

            if game.opponentEntity == nil {
                DDLogVerbose("Waiting for opponentEntity")
                while game.opponentEntity == nil {
                    NSThread.sleepForTimeInterval(0.1)
                }
            }
            if let opponentEntity = game.opponentEntity {
                if game.opponent.playerClass == nil && id == opponentEntity.getTag(GameTag.HERO_ENTITY) {
                    dispatch_async(dispatch_get_main_queue()) {
                        game.setOpponentHero(game.entities[id]!.cardId!)
                    }
                    return
                }
            }
        }
    }
}