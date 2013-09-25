if Meteor.isClient
    
    Template.idea.expanded = () ->
        @_id is Session.get 'selectedIdea'
    
    Template.idea.events
        'click div.idea': (e) ->
            Session.set 'selectedIdea', @_id
            
    Template.ideaHeader.prettyChangedDate = () ->
        moment(@changed).fromNow()
    
    Template.ideaVotes.numberOfVotes = () ->
        @votes.length
        
    Template.ideaVotes.userIsNotAuthor = () ->
        Meteor.user()? and Meteor.user().username isnt @user
    
    Template.ideaVotes.userHasVoted = () ->
        Meteor.user()? and _.any @votes, (u) -> Meteor.user().username is u
    
    Template.ideaVotes.events
        'click button.vote-idea': (e) ->
            e.stopPropagation()
            Ideas.update {_id: @_id}, {$push: {votes: Meteor.user().username}}
    
    Template.ideaDetails.userIsAuthor = () ->
        Meteor.user()? and Meteor.user().username is @user
        
    Template.ideaDetails.transientDescription = () ->
        changedIdeas = Session.get 'changedIdeas'
        unless changedIdeas?
            changedIdeas = {}
        unless changedIdeas[@_id]?
            changedIdeas[@_id] = @description
        Session.set 'changedIdeas', changedIdeas
        changedIdeas[@_id]
        
    Template.ideaDetails.descUpdated = () ->
        changedIdeas = Session.get 'changedIdeas'
        changedIdeas[@_id] isnt @description
        
    Template.ideaDetails.events
        'keyup textarea.idea-description': (e) ->
            newValue = e.target.value
            changedIdeas = Session.get 'changedIdeas'
            changedIdeas[@_id] = newValue
            Session.set 'changedIdeas', changedIdeas
        'submit form': (e) ->
            e.preventDefault()
            newDesc = Session.get('changedIdeas')[@_id]
            rev = @rev + 1
            Ideas.update {_id: @_id}, 
                $set: 
                    description: newDesc
                    version: rev
                    updated: new Date
            
            Spomet.update new Spomet.Findable newDesc, 'description', @_id, 'idea', rev
        'click button.cancel-button': (e) ->
            changedIdeas = Session.get 'changedIdeas'
            changedIdeas[@_id] = @description
            Session.set 'changedIdeas', changedIdeas
            