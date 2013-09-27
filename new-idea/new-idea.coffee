if Meteor.isClient
    Template.newIdea.events
        'click button.cancel-button': (e) ->
            NewIdeas.remove (_id: @._id)
        'submit form': (e) ->
            e.preventDefault()
        
            title = $(e.target).find('input.idea-title').val()
            description = $(e.target).find('textarea.idea-description').val()
            
            if title?.length > 0 and description?.length > 0
                id = Ideas.insert
                    user: Meteor.user().username
                    title: title
                    description: description 
                    changed: new Date
                    version: 1
                    votes: []
                    votesCount: 0
                
                Spomet.add new Spomet.Findable title, 'title', id, 'idea', 1
                Spomet.add new Spomet.Findable description, 'description', id, 'idea', 1
                
                NewIdeas.remove {_id: @._id}
        'keyup input.idea-title': (e) ->
            phrase = $(e.target).val()
            simSearch.find phrase
        'keyup textarea.idea-description': (e) ->
            phrase = $(e.target).val()
            simSearch.find phrase