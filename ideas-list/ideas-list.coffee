if Meteor.isClient
    Template.ideasListControl.searchFieldConf =
        fieldSizeClass: 'span8'
        buttonText: 'Find!'
    
    Meteor.subscribe 'ideas'
    
    Template.newIdeasList.ideas = () ->
        NewIdeas.find()
    
    Template.ideasList.ideas = () ->
        Ideas.find()
    
    Template.ideasListHeader.events
        'click button.new-button': (e) ->
            NewIdeas.insert 
                title: 'New Idea'
                description: ''
                

if Meteor.isServer
    Meteor.publish 'ideas', () ->
        Ideas.find()